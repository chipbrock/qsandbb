#!/bin/bash

DATE=$(date +"%Y%m%d")
read -p "Enter numeric prefix (e.g., 005): " PREFIX
read -p "Enter post title (e.g., Lorem Ipsum): " TITLE
read -p "Enter categories (comma-separated, e.g., fun, latin): " CATEGORIES

TITLE_DIR=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
TITLE_DISPLAY=$(echo "$TITLE" | sed 's/_/ /g')
DIRNAME="${DATE}_${PREFIX}-${TITLE_DIR}"
POSTFILE="${PREFIX}-${TITLE_DIR}.qmd"

mkdir -p "$DIRNAME"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_DISPLAY"
date: $(date +"%Y-%m-%d")
categories: [$(echo $CATEGORIES | sed 's/,/, /g')]
description: "$TITLE_DISPLAY post content"
---

# $PREFIX. $TITLE_DISPLAY

<div class="breadcrumb">
  <a href="../stories.html">Stories</a> › <strong>${TITLE_DISPLAY}</strong>
</div>


<div style="font-size:0.85em; color:#555; margin-top:0.5em;">
Author: Chip Brock · Published: $(date +"%B %d, %Y")
</div>

![Placeholder image](image.jpg)

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Write your content here.
EOF

echo "✅ Created: $DIRNAME/$POSTFILE"
