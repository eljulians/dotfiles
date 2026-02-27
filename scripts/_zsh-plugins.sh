#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_helpers.sh"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull "https://github.com/MichaelAquilina/zsh-you-should-use" "$ZSH_CUSTOM/plugins/you-should-use"
clone_or_pull "https://github.com/fdellwing/zsh-bat" "$ZSH_CUSTOM/plugins/zsh-bat"
