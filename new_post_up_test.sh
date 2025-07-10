#!/bin/bash

# Prompt for all three inputs
read -p "Enter subdirectory name (e.g., particle-bios): " TARGET_DIR
read -p "Enter numeric prefix (e.g., 0300 or 1913): " PREFIX
read -p "Enter post title (e.g., Neutron): " TITLE

# Verify the directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Error: Directory '$TARGET_DIR' does not exist."
  exit 1
fi

cd "$TARGET_DIR" || exit 1

# Compute today's date
DATE=$(date +"%Y%m%d")

# Normalized slug
TITLE_DIR=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')

# Display-friendly version
TITLE_DISPLAY=$(echo "$TITLE" | sed 's/_/ /g')

# Compute full title with number formatting
if [[ "$PREFIX" =~ ^0[0-9]+$ ]]; then
  MAJOR=$(echo "$PREFIX" | cut -c2)
  MINOR=$(echo "$PREFIX" | cut -c3-)
  TITLE_WITH_NUM="$MAJOR.$MINOR $TITLE_DISPLAY"
else
  TITLE_WITH_NUM="$PREFIX $TITLE_DISPLAY"
fi

# Directory and filename
DIRNAME="${DATE}_${PREFIX}-${TITLE_DIR}"
POSTFILE="${PREFIX}-${TITLE_DIR}.qmd"
CATEGORY_LABEL=$(basename "$PWD" | tr '-' ' ' | awk '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); print}')

# Create post content
mkdir -p "$DIRNAME"
cp ../logo_orange_words.png "$DIRNAME/logo_orange_words.png"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_WITH_NUM"
date: "DATE"
image: "logo_orange_words.png"
categories: [$CATEGORY_LABEL, drafting]
description: "ℹ️ **README:** $TITLE_DISPLAY post content"
draft: true
---

<div class="breadcrumb">
  <a href="../../stories.html">Stories</a> > <a href="../index.qmd">TOC $CATEGORY_LABEL</a> > <strong>${TITLE_DISPLAY}</strong>
</div>
MARK

<div style="font-size:0.85em; color:#555; margin-top:0.5em;">
Author: Chip Brock · Published: $(date +"%B %d, %Y")
</div>

---

::: {.column-margin}
![](logo_orange_words.png){ width=120px }
:::

Watch this space.

---

::: {.post-nav}
← [Previous: TITLE](../20250326_XXX/XXX.qmd) | [Next: TITLE](../20250326_XXX/XXX.qmd)
:::
EOF

# Append to index.qmd
echo "- [$TITLE_WITH_NUM]($DIRNAME/$POSTFILE)" >> index.qmd

echo "✅ Created: $TARGET_DIR/$DIRNAME/$POSTFILE"