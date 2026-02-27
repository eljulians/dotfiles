#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/_helpers.sh"

# Install TPM (tmux plugin manager)
clone_or_pull "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

echo "TPM installed. Start tmux and press 'prefix + I' to install plugins."
