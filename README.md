# Neovim Configuration

A modular Neovim configuration for software development, with additional support for Rust, Qt/QML, Markdown, LaTeX, Verilog, and SystemVerilog.

## Requirements

- Neovim 0.11 or newer
- Git
- A Nerd Font for icons
- Optional language tools used by the enabled formatters, linters, and language servers

On first launch, `lazy.nvim` is bootstrapped automatically and installs the configured plugins.

## Repository layout

```text
.
├── init.lua                    # Minimal Neovim entry point
├── lua/
│   ├── config/                 # Editor options and GUI-specific settings
│   ├── keymaps/                # Keymaps grouped by responsibility
│   ├── languages/              # Shared language-specific helpers
│   └── plugins/
│       ├── coding/             # LSP, completion, formatting, linting, treesitter
│       ├── editor/             # Editing behavior and session utilities
│       ├── integrations/       # Git, Copilot, and terminal image support
│       ├── languages/          # Language and filetype plugins
│       ├── navigation/         # Telescope, Neo-tree, terminal navigation
│       └── ui/                 # Colors, dashboard, statusline, and layout
├── scripts/                    # Platform setup helpers
└── lazy-lock.json              # Reproducible plugin versions
```

Plugin declarations are organized by domain. Add a plugin specification to the closest folder under `lua/plugins`; every domain is imported from `lua/plugins/init.lua`.

## Installation

Clone the repository into Neovim's configuration directory:

```sh
git clone <repository-url> "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

Platform-specific package setup is available in:

- `scripts/install-arch.sh`
- `scripts/install-ubuntu.sh`

Review a script before running it because it installs system packages. The Ubuntu helper also builds Verilator from source.

## Maintenance

- Run `:Lazy` to inspect, update, or synchronize plugins.
- Run `:Mason` to inspect external development tools.
- Run `:checkhealth` after changing plugin or language-tool configuration.

## Wakapi dashboard

The start screen shows 13 weeks of coding activity from Wakapi. It reads the
`api_url` and `api_key` directly from `~/.wakatime.cfg`, so no credentials are
stored in this repository.

The last successful report is cached for offline starts. Use `:WakapiRefresh` or
`:WeatherRefresh` to refresh the activity or Karlsruhe weather manually.

## Credits

Originally based on [nighty3098/nvim](https://github.com/nighty3098/nvim).
