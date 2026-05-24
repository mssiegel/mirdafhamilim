# mirdafhamilim

Hebrew-first typing practice game. The current repository contains a
frontend-only `client` workspace for the Vite React app.

## Client workflow

Install client dependencies with npm:

```bash
npm --prefix client install
```

Start the client development server:

```bash
npm --prefix client run dev
```

Run the production build:

```bash
npm --prefix client run build
```

No dedicated test framework is configured for this foundation slice. Until one
exists, verify the client workflow by installing dependencies when needed,
running the production build, and rendering the Hebrew right-to-left placeholder
locally.

## Verification

- `npm --prefix client run build` passes.
- The local client dev server renders the Hebrew placeholder in right-to-left
  direction.
