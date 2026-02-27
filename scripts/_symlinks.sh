#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

cd "$DOTFILES_DIR"
find * -maxdepth 0 -type f \
    -not -name "install.sh" \
    -not -name ".gitignore" \
    -not -name ".gitmodules" \
    -not -name "*.md" \
    -not -name "*.sw*" \
    -exec ln -sf "$DOTFILES_DIR"/{} "$HOME/."{} \;

echo "Symlinks created."
