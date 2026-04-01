#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.claude/agents"

mkdir -p "$TARGET_DIR"

copied=0
for file in "$SCRIPT_DIR"/*.md; do
    [ -f "$file" ] || continue
    name=$(basename "$file")
    cp "$file" "$TARGET_DIR/$name"
    echo "Installed: $name"
    copied=$((copied + 1))
done

echo ""
echo "$copied agents installed to $TARGET_DIR"
