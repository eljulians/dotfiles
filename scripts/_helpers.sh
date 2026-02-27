#!/bin/bash
# Shared helper functions

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
