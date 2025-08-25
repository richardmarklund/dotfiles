# AGENTS.md - Dotfiles Configuration Guide

## Build/Lint/Test Commands

### Neovim Configuration
- **Format Lua files**: `stylua --config-path .stylua.toml lua/`
- **Lint Lua files**: Use nvim-lint plugin (configured in `lua/kickstart/plugins/lint.lua`)
- **Check health**: `:checkhealth` in Neovim
- **Update plugins**: `:Lazy update` in Neovim

### General
- **No build process** - This is a configuration repository
- **No test suite** - Configuration files don't require testing
- **Validate configs**: Run Neovim with `:checkhealth` to verify configuration

## Code Style Guidelines

### Lua (Neovim Configuration)
- **Formatter**: Stylua with config from `.stylua.toml`
- **Indentation**: 2 spaces, no tabs
- **Line width**: 160 characters
- **Quote style**: Auto-prefer single quotes
- **Function calls**: No parentheses for single string/table arguments
- **Naming**: snake_case for variables/functions, PascalCase for modules
- **Error handling**: Use `pcall()` for potentially failing operations
- **Comments**: Minimal comments, prefer descriptive variable names

### File Structure
- **Plugin configs**: `lua/custom/plugins/` for custom, `lua/kickstart/plugins/` for standard
- **Core configs**: `lua/options.lua`, `lua/keymaps.lua`, `lua/lazy-plugins.lua`
- **Modular approach**: Split configuration into logical modules

### Configuration Patterns
- **Plugin specs**: Return table with plugin name and config function
- **Keymaps**: Use `vim.keymap.set()` with descriptive descriptions
- **Options**: Group related settings with comments
- **Autocommands**: Use augroups to avoid duplicates

### Other Configurations
- **Starship**: TOML format, disable unused modules for performance
- **Wezterm**: Lua-based configuration, follow existing keybinding patterns
- **Zsh**: Standard shell configuration patterns

## Development Workflow
1. Edit configuration files
2. Test in Neovim with `:source %` or restart
3. Run `:checkhealth` to verify
4. Format with stylua before committing
5. Test across different file types and scenarios

## No Cursor/Copilot Rules Found
No `.cursor/rules/` or `.github/copilot-instructions.md` files detected.