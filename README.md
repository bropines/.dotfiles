# Hedgehog Dotfiles 🦔

My personal Zsh configuration optimized for speed, cleanliness, and cross-platform compatibility (WSL & Servers).

## Features
- **Zero Home Garbage**: All configs, history, and Oh My Zsh live inside the `.dotfiles` directory.
- **Modular Config**: Separated `env`, `aliases`, `plugins`, and `options`.
- **Dual Mode**: Lightweight for servers, "heavy" for dev environments.
- **Top-tier Plugins**: Autosuggestions, Syntax Highlighting, FZF-tab, and more.

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### Heavy Mode (WSL / Desktop)
Installs `pyenv`, `sdkman` and enables their loading:
```bash
./install.sh --heavy
```

## Structure
- `zsh/` - ZDOTDIR content
  - `env.zsh` - PATH and exports
  - `aliases.zsh` - Commands shortcuts
  - `plugins.zsh` - OMZ and plugins setup
  - `options.zsh` - Shell behavior and history
  - `.zshrc.local` - Machine-specific overrides (ignored by git)
