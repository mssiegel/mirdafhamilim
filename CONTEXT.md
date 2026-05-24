# Word Chase

Word Chase is a Hebrew-first typing practice game where players type prompted words before an on-screen character reaches them.

## Language

**Hebrew-first**:
The product defaults to Hebrew language content and right-to-left presentation while remaining open to future localization.
_Avoid_: Hebrew-only, localization-complete

**Words per minute**:
A typing speed measurement shown to players in Hebrew as "מילים לדקה" and represented internally as `wpm`.
_Avoid_: WPM as player-facing copy

**Speed preset**:
A predefined practice pace with a Hebrew player-facing name and a target **Words per minute** value.
_Avoid_: Difficulty, level

**Client**:
The frontend application workspace that contains the Vite React app and its dependencies.
_Avoid_: Frontend app at repository root

## Relationships

- **Hebrew-first** applies to all player-facing text and layout direction.
- **Words per minute** measures player typing speed during practice.
- A **Speed preset** has exactly one target **Words per minute** value.
- The initial **Speed presets** are "מתחיל" at 10 **Words per minute**, "בינוני" at 25 **Words per minute**, and "מהיר" at 50 **Words per minute**.
- The first project version establishes the frontend foundation without implementing **Speed presets** in code.
- The **Client** owns all frontend code and dependencies while the project has no backend.
- The **Client** starts with a light feature-ready structure and does not create empty gameplay folders before the UI exists.
- The **Client** includes complete Material UI right-to-left infrastructure from the first version.
- The first placeholder page confirms the **Client** is running without introducing gameplay concepts or visuals.
- The first **Client** version is verified by install, build, and render checks rather than a dedicated test suite.
- The **Client** has a dev-server smoke test that verifies the landing page loads at `/`.
- The project uses npm for the first **Client** package workflow.

## Example dialogue

> **Dev:** "Should the first placeholder page be English because it is only temporary?"
> **Domain expert:** "No, the product is **Hebrew-first**, so even temporary player-facing text should be Hebrew and right-to-left."

> **Dev:** "Should the speed display say WPM?"
> **Domain expert:** "No, show **Words per minute** as 'מילים לדקה' in the Hebrew UI."

> **Dev:** "Are beginner, medium, and fast just implementation constants?"
> **Domain expert:** "No, they are **Speed presets** with Hebrew names shown to players: מתחיל, בינוני, and מהיר."

> **Dev:** "Should the Vite dependencies live at the repository root?"
> **Domain expert:** "No, the **Client** owns the frontend app and dependencies until a broader workspace is needed."

> **Dev:** "Should we create a full game feature folder now?"
> **Domain expert:** "No, keep the **Client** structure light until the first gameplay or Figma-driven UI work needs it."

> **Dev:** "Is setting `dir='rtl'` enough for the first version?"
> **Domain expert:** "No, the **Client** should include the full Material UI right-to-left foundation from the start."

> **Dev:** "Should the placeholder page show a sample chase word?"
> **Domain expert:** "No, the placeholder only confirms the **Client** is running; gameplay visuals wait for the design."

> **Dev:** "Should we add a test suite before there is game behavior?"
> **Domain expert:** "No, verify the first **Client** foundation by installing, building, and rendering the Hebrew right-to-left placeholder."

> **Dev:** "Should we use pnpm because this may later become a multi-package repo?"
> **Domain expert:** "No, start with npm for the first **Client** workflow unless the repository later standardizes on another package manager."

## Flagged ambiguities

- "Hebrew-first" could mean permanently Hebrew-only or Hebrew-default with future localization support; resolved: Hebrew-default and localization-ready.
- "WPM" is acceptable as an internal code concept, but player-facing copy should use "מילים לדקה".
- "beginner / medium / fast" are internal preset identifiers; player-facing names are "מתחיל", "בינוני", and "מהיר".
- "basic foundation" excludes gameplay constants for now; resolved: document **Speed presets** but do not implement them until gameplay or settings UI exists.
- "client" is the frontend workspace, not just an arbitrary folder name; resolved: keep app dependencies inside `client` for now.
- "starter structure" means light feature-ready folders, not a speculative full game architecture.
- "RTL support" includes document direction, Material UI theme direction, and Emotion RTL styling support.
- "placeholder page" is not the first game screen; resolved: no sample words, speed display, character, or gameplay layout yet.
- "quality checks" for the first version mean build and render verification, not a dedicated test framework.
- "package manager" is npm for the initial **Client** setup.
