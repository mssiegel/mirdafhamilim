#!/usr/bin/env bash
set -euo pipefail

MAX_ITERATIONS="${1:-${RALPH_MAX_ITERATIONS:-1}}"
COMPLETION_SIGIL="<promise>COMPLETE</promise>"
RESULT_PATH=".sandcastle/ralph-result.json"
WORKTREE_ROOT=".sandcastle/worktrees"
LOG_DIR=".sandcastle/logs"
SOURCE_BRANCH="$(git branch --show-current)"
SOURCE_ROOT="$(pwd)"

usage() {
  echo "Usage: npm run ralph -- [iterations]"
  echo
  echo "Runs local Ralph implement/review cycles in fresh git worktrees."
  echo "Set RALPH_MAX_ITERATIONS to change the default iteration count."
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

ensure_clean_worktree() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "The current worktree has uncommitted changes." >&2
    echo "Commit or stash them before running Ralph so the new worktree starts cleanly." >&2
    exit 1
  fi
}

reuse_local_dependencies() {
  local source_node_modules="$SOURCE_ROOT/client/node_modules"
  local worktree_node_modules="$WORKTREE_PATH/client/node_modules"

  if [[ -e "$worktree_node_modules" || ! -d "$source_node_modules" ]]; then
    return
  fi

  echo "Reusing existing client dependencies from $source_node_modules"
  if ln -s "$source_node_modules" "$worktree_node_modules" 2>/dev/null; then
    return
  fi

  if command -v cygpath >/dev/null 2>&1; then
    cmd.exe //c mklink //J "$(cygpath -w "$worktree_node_modules")" "$(cygpath -w "$source_node_modules")" >/dev/null
    return
  fi

  echo "Could not link client dependencies into the worktree." >&2
  echo "Run npm --prefix client ci in the worktree if verification commands need dependencies." >&2
}

json_field() {
  local file="$1"
  local field="$2"

  node -e "
const fs = require('fs');
const data = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'));
const value = data[process.argv[2]];
if (value !== undefined && value !== null) {
  process.stdout.write(String(value));
}
" "$file" "$field"
}

run_codex() {
  local name="$1"
  local prompt_file="$2"
  local log_file="$3"

  local prompt
  prompt="$(
    cat "$prompt_file"
    printf '\n\n# Local Ralph runtime\n\n'
    printf -- '- Source branch: `%s`\n' "$SOURCE_BRANCH"
    printf -- '- Working branch: `%s`\n' "$BRANCH"
    printf -- '- Result file: `%s`\n' "$RESULT_PATH"
    printf -- '- Completion signal: `%s`\n' "$COMPLETION_SIGIL"
  )"

  echo "Starting $name agent..."
  export SOURCE_BRANCH
  export BRANCH
  export RESULT_PATH
  codex -a on-request exec -C "$WORKTREE_PATH" -s danger-full-access "$prompt" | tee "$log_file"
}

if [[ "$MAX_ITERATIONS" == "-h" || "$MAX_ITERATIONS" == "--help" ]]; then
  usage
  exit 0
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Iterations must be a non-negative integer." >&2
  usage >&2
  exit 1
fi

if [[ "$MAX_ITERATIONS" -eq 0 ]]; then
  echo "No iterations requested."
  exit 0
fi

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Ralph requires a named source branch, but Git is currently detached." >&2
  exit 1
fi

require_command git
require_command gh
require_command codex
require_command node

ensure_clean_worktree
mkdir -p "$WORKTREE_ROOT" "$LOG_DIR"

for ((iteration = 1; iteration <= MAX_ITERATIONS; iteration++)); do
  RUN_ID="ralph-sequential-reviewer-$(date +%s)-$iteration"
  BRANCH="ralph/sequential-reviewer/$(date +%s)-$iteration"
  WORKTREE_PATH="$WORKTREE_ROOT/$RUN_ID"

  echo
  echo "=== Ralph iteration $iteration/$MAX_ITERATIONS ==="
  echo "Creating local worktree $WORKTREE_PATH on branch $BRANCH"

  git worktree add -b "$BRANCH" "$WORKTREE_PATH" "$SOURCE_BRANCH"
  reuse_local_dependencies

  implement_log="$LOG_DIR/$RUN_ID-iteration-$iteration-implementer.log"
  review_log="$LOG_DIR/$RUN_ID-iteration-$iteration-reviewer.log"

  run_codex "implementer" "$WORKTREE_PATH/.sandcastle/implement-prompt.md" "$implement_log"

  if [[ ! -f "$WORKTREE_PATH/$RESULT_PATH" ]]; then
    echo "Implementer did not write $RESULT_PATH. Leaving worktree for inspection: $WORKTREE_PATH" >&2
    exit 1
  fi

  status="$(json_field "$WORKTREE_PATH/$RESULT_PATH" status)"
  issue_number="$(json_field "$WORKTREE_PATH/$RESULT_PATH" issueNumber)"

  if [[ "$status" == "complete" ]]; then
    echo "Ralph reported that no actionable ready-for-agent issues remain."
    echo "$COMPLETION_SIGIL"
    exit 0
  fi

  if [[ "$status" != "implemented" ]]; then
    echo "Implementer stopped with status '$status'. Leaving worktree for inspection: $WORKTREE_PATH" >&2
    exit 1
  fi

  if [[ -z "$issue_number" ]]; then
    echo "Result file did not include issueNumber. Leaving worktree for inspection: $WORKTREE_PATH" >&2
    exit 1
  fi

  if [[ -z "$(git -C "$WORKTREE_PATH" log "$SOURCE_BRANCH..HEAD" --oneline)" ]]; then
    echo "Implementer reported success but made no commits. Leaving worktree for inspection: $WORKTREE_PATH" >&2
    exit 1
  fi

  run_codex "reviewer" "$WORKTREE_PATH/.sandcastle/review-prompt.md" "$review_log"

  if ! grep -q "$COMPLETION_SIGIL" "$review_log"; then
    echo "Reviewer did not output the completion signal. Leaving worktree for inspection: $WORKTREE_PATH" >&2
    exit 1
  fi

  gh issue close "$issue_number" \
    --comment "Completed by local Ralph after implement and review passes on branch $BRANCH."

  echo "Closed issue #$issue_number after review."
  echo "Worktree kept for inspection: $WORKTREE_PATH"
done

echo
echo "Ralph stopped after $MAX_ITERATIONS iteration(s)."
