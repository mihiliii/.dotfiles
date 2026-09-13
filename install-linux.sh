#!/bin/bash

set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# This script ends with `git checkout -- .` in the dotfiles repo, which
# discards ANY uncommitted changes there (not just files stow touches).
# Refuse to run on a dirty tree so we never clobber work in progress.
if [ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]; then
  echo "error: $DOTFILES_DIR has uncommitted changes." >&2
  echo "Commit or stash them before running this script." >&2
  exit 1
fi

# Update system

sudo pacman -Syu

# Install packages

## Essentials
sudo pacman -S --needed --noconfirm git vim base-devel stow github-cli zoxide ttf-jetbrains-mono-nerd-basic

## Install lazyvim and its dependencies
sudo pacman -S --needed --noconfirm neovim wl-clipboard fzf lazygit fd ast-grep ripgrep luarocks nodejs npm lynx
sudo npm install -g neovim

## Install yazi file explorer and starship prompt
sudo pacman -S --needed --noconfirm yazi starship

## Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup component add rust-analyzer

# Setting up config files

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

stow -d "$DOTFILES_DIR" -t "$HOME" --adopt .
git -C "$DOTFILES_DIR" checkout -- .
