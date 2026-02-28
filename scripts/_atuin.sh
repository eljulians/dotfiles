#!/bin/bash
set -e

if [ "$(atuin history list 2>/dev/null | wc -l)" -eq 0 ]; then
    echo "Importing shell history into atuin..."
    atuin import auto
else
    echo "Atuin history already populated, skipping import."
fi
