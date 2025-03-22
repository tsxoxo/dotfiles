# Dotfiles

This repository contains my personal dotfiles, managed with a custom script.

## Contents

The repository includes configurations for:

- zsh: Shell configuration
- nvim: Neovim editor settings
- git: Git configuration
- karabiner: Keyboard customization
- wezterm: Terminal emulator settings

## Installation

To install these dotfiles on a new system:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Managing Dotfiles

The repository includes a management script with these commands:

- `./dotfiles-setup.sh` - Sync all dotfiles
- `./dotfiles-setup.sh add ~/.config/foo foo` - Add new dotfile
- `./dotfiles-setup.sh remove ~/.config/foo` - Remove a dotfile
- `./dotfiles-setup.sh list` - List tracked dotfiles
- `./dotfiles-setup.sh diff` - Show differences between local and repo
- `./dotfiles-setup.sh help` - Show help information

## Customization

Edit the `dotfiles.conf` file to add or remove tracked files.
