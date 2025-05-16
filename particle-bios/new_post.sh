#!/bin/bash

DATE=$(date +"%Y%m%d")
read -p "Enter numeric prefix (e.g., 042): " PREFIX
read -p "Enter post title (e.g., Quantum Fields): " TITLE

TITLE_DIR=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')
TITLE_DISPLAY=$(echo "$TITLE" | sed 's/_/ /g')
DIRNAME="${DATE}_${PREFIX}-${TITLE_DIR}"
POSTFILE="${PREFIX}-${TITLE_DIR}.qmd"
CATEGORY_LABEL=$(basename "$PWD" | sed -E 's/-/ /g' | sed -E 's/\b(.)/\u\1/g')

mkdir -p "$DIRNAME"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_DISPLAY"
date: $(date +"%Y-%m-%d")
categories: [$CATEGORY_LABEL]
description: "$TITLE_DISPLAY post content"
---

# $PREFIX. $TITLE_DISPLAY

<div class="breadcrumb">
  <a href="../../stories.html">Stories</a> › <a href="../index.qmd">TOC Particle Bios</a> › <strong>${TITLE_DISPLAY}</strong>
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

echo "- [$PREFIX. $TITLE_DISPLAY]($DIRNAME/$POSTFILE)" >> index.qmd
echo "✅ Created: $DIRNAME/$POSTFILE"
