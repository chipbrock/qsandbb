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
cp ../ORANGE.png "$DIRNAME/logo_orange_words.png"
cat <<EOF > "$DIRNAME/$POSTFILE"
---
title: "$TITLE_WITH_NUM"
image: "ORANGE.png"
categories: [$CATEGORY_LABEL, draft]
description: "ℹ️ **README:** $TITLE_DISPLAY CONTENT"
draft: false
---

<div class="breadcrumb">
  <a href="../../stories.html">Stories</a> > <a href="../index.qmd">TOC $CATEGORY_LABEL</a> > <strong>${TITLE_DISPLAY}</strong>
</div>
MARKER1

<div style="font-size:0.85em; color:#555; margin-top:0.5em;">
Author: Chip Brock · Published: $(date +"%B %d, %Y")
</div>

MARKER1-move the prev-next block here

---

MARKER2

Watch this space please.

---


EOF

# Append to index.qmd
echo "- [$TITLE_WITH_NUM]($DIRNAME/$POSTFILE)" >> index.qmd

echo "✅ Created: $TARGET_DIR/$DIRNAME/$POSTFILE"