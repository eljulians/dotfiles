#!/bin/bash
set -e

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

FONT_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

for font in "MesloLGS%20NF%20Regular.ttf" "MesloLGS%20NF%20Bold.ttf" "MesloLGS%20NF%20Italic.ttf" "MesloLGS%20NF%20Bold%20Italic.ttf"; do
    font_name=$(echo "$font" | sed 's/%20/ /g')
    if [ ! -f "$FONT_DIR/$font_name" ]; then
        echo "Downloading $font_name..."
        curl -fsSL -o "$FONT_DIR/$font_name" "$FONT_BASE_URL/$font"
    fi
done

fc-cache -f "$FONT_DIR" 2>/dev/null || true
echo "Fonts installed. Set your terminal font to 'MesloLGS NF'."
