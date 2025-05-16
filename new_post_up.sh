#!/bin/bash

# Prompt for all three inputs
read -p "Enter subdirectory name (e.g., feynman-diagrams): " TARGET_DIR
read -p "Enter numeric prefix (e.g., 0300): " PREFIX
read -p "Enter post title (e.g., Gamma Particle): " TITLE

# Verify the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Error: Directory '$TARGET_DIR' does not exist."
  exit 1
fi

# Move into the target directory
cd "$TARGET_DIR" || exit 1

# Get date and normalize
DATE=$(date +"%Y%m%d")
TITLE_DIR=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
TITLE_DISPLAY=$(echo "$TITLE" | sed 's/_/ /g')
DIRNAME="${DATE}_${PREFIX}-${TITLE_DIR}"
POSTFILE="${PREFIX}-${TITLE_DIR}.qmd"
CATEGORY_LABEL=$(basename "$PWD" | tr '-' ' ' | awk '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')

# Create folder and file
mkdir -p "$DIRNAME"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_DISPLAY"
# date: $(date +"%Y-%m-%d")
categories: [$CATEGORY_LABEL]
description: "$TITLE_DISPLAY post content"
---

# $TITLE_DISPLAY

<div class="breadcrumb">
  <a href="../../stories.html">Stories</a> › <a href="../index.qmd">TOC $CATEGORY_LABEL</a> › <strong>${TITLE_DISPLAY}</strong>
</div>

<div style="font-size:0.85em; color:#555; margin-top:0.5em;">
Author: Chip Brock · Published: $(date +"%B %d, %Y")
</div>

---

Write your content here.

---

::: {{.post-nav}}
← [Previous: TITLE](../20250326_XXX/XXX.qmd) | [Next: TITLE](../20250326_XXX/XXX.qmd)
:::
EOF

# Append to index
echo "- [$PREFIX. $TITLE_DISPLAY]($DIRNAME/$POSTFILE)" >> index.qmd

echo "✅ Created: $TARGET_DIR/$DIRNAME/$POSTFILE"