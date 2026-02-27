#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Clone or pull a git repo
clone_or_pull() {
    local repo_url="$1"
    local target_dir="$2"

    if [ -d "$target_dir" ]; then
        echo "Updating $target_dir..."
        git -C "$target_dir" pull --ff-only
    else
        echo "Cloning $repo_url to $target_dir..."
        git clone --depth=1 "$repo_url" "$target_dir"
    fi
}

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Theme
clone_or_pull "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"

# Plugins
clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull "https://github.com/MichaelAquilina/zsh-you-should-use" "$ZSH_CUSTOM/plugins/you-should-use"
clone_or_pull "https://github.com/fdellwing/zsh-bat" "$ZSH_CUSTOM/plugins/zsh-bat"

echo "Done installing zsh plugins and theme."

# Create symlinks for dotfiles
cd "$SCRIPT_DIR"
find * -maxdepth 0 -type f \
    -not -name "install.sh" \
    -not -name ".gitignore" \
    -not -name ".gitmodules" \
    -not -name "*.md" \
    -not -name "*.sw*" \
    -exec ln -sf "$PWD"/{} "$HOME/."{} \;
