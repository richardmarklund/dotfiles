# Repository Guidelines

Brief contributor guide for this Neovim configuration. Keep changes small, readable, and easy to verify inside Neovim.

## Project Structure & Module Organization
- Core config: `lua/options.lua`, `lua/keymaps.lua`, `lua/lazy-plugins.lua`.
- Standard plugins: `lua/kickstart/plugins/` (one file per plugin/feature).
- Custom plugins: `lua/custom/plugins/` (overrides and add‑ons).
- Lint config: `lua/kickstart/plugins/lint.lua` (nvim-lint setup).

## Build, Test, and Development Commands
- Format Lua: `stylua --config-path .stylua.toml lua/`.
- Health check: inside Neovim, run `:checkhealth`.
- Update plugins: inside Neovim, run `:Lazy update`.
- Reload current file: `:source %` (use after local edits).

## Coding Style & Naming Conventions
- Lua style: 2‑space indent, max line ~160 chars, prefer single quotes.
- Formatting: use Stylua (config in `.stylua.toml`).
- Linting: nvim-lint runs via the plugin config; fix reported issues.
- Naming: snake_case for vars/functions; PascalCase for modules.
- Calls: omit parentheses for single string/table args where readable.
- Safety: wrap risky calls with `pcall()`; prefer descriptive names over comments.

## Testing Guidelines
- No test suite. Validate via `:checkhealth`, editing common filetypes, and opening plugin features.
- After changes: `stylua` clean, Neovim starts without errors, keymaps still work, and linters run.

## Commit & Pull Request Guidelines
- Commits: imperative, scoped, and focused. Example prefixes: `nvim:`, `plugins:`, `keymaps:`, `ui:`, `lint:`.
  - Example: `plugins: add gitsigns with inline blame`.
- Before committing: run Stylua and verify `:checkhealth` is green.
- PRs: include summary of changes, rationale, screenshots/gifs for UI changes, and reproduction/validation steps. Link related issues if any.

## Development Workflow
1) Edit files under `lua/`. 2) `:source %` or restart Neovim. 3) `:checkhealth`. 4) Run Stylua. 5) Exercise affected plugins/keymaps.

