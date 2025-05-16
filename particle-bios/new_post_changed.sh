#!/bin/bash

# Get today's date
DATE=$(date +"%Y%m%d")

# Prompt for numeric prefix and post title
read -p "Enter numeric prefix (e.g., 0100): " PREFIX
read -p "Enter post title (e.g., Quantum Fields): " TITLE

# Normalize title and directory names
TITLE_DIR=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
TITLE_DISPLAY=$(echo "$TITLE" | sed 's/_/ /g')
DIRNAME="${DATE}_${PREFIX}-${TITLE_DIR}"
POSTFILE="${PREFIX}-${TITLE_DIR}.qmd"

# Infer category label from current directory name
#CATEGORY_LABEL=$(basename "$PWD" | sed -E 's/-/ /g' | sed -E 's/\b(.)/\u\1/g')
CATEGORY_LABEL=$(basename "$PWD" | tr '-' ' ' | awk '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')

# Create directory and post file
mkdir -p "$DIRNAME"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_DISPLAY"
date: $(date +"%Y-%m-%d")
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

# Append to category index
echo "- [$PREFIX. $TITLE_DISPLAY]($DIRNAME/$POSTFILE)" >> index.qmd

echo "✅ Created: $DIRNAME/$POSTFILE"