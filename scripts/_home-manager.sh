#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Check prerequisites
if ! command -v nix &> /dev/null; then
    echo "Error: Nix is not installed. See README.md for installation instructions."
    exit 1
fi

if ! command -v home-manager &> /dev/null; then
    echo "Error: Home Manager is not installed. See README.md for installation instructions."
    exit 1
fi

# Set up home-manager config symlink
mkdir -p "$HOME/.config/home-manager"
ln -sf "$SCRIPT_DIR/home.nix" "$HOME/.config/home-manager/home.nix"

# Install packages and symlink dotfiles via Home Manager
echo "Running home-manager switch..."
home-manager switch
