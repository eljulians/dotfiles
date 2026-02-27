#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPT_DIR/scripts/_home-manager.sh"
"$SCRIPT_DIR/scripts/_oh-my-zsh.sh"
"$SCRIPT_DIR/scripts/_zsh-theme.sh"
"$SCRIPT_DIR/scripts/_zsh-plugins.sh"
"$SCRIPT_DIR/scripts/_fonts.sh"
"$SCRIPT_DIR/scripts/_tmux.sh"

echo "Done."
echo "Start tmux and press 'prefix + I' to install tmux plugins (including tmux-powerline)."
