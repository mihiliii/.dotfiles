#!/usr/bin/env bash

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

# Install Homebrew if missing

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update system

brew update
brew upgrade

# Install packages

## Essentials
brew install git vim stow gh zoxide
brew install --cask font-jetbrains-mono-nerd-font

## Install lazyvim and its dependencies
brew install neovim fzf lazygit fd ast-grep ripgrep luarocks node lynx
npm install -g neovim npm-groovy-lint prettier

## Install yazi file explorer and starship prompt
brew install yazi starship

## Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup component add rust-analyzer

# Setting up config files

## Removing old neovim config installation
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

## Using git stow to update config files
stow -d "$DOTFILES_DIR" -t "$HOME" --adopt .
git -C "$DOTFILES_DIR" checkout -- .

## Change default shell to zsh
sudo chsh -s "$(which zsh)" "$USER"
