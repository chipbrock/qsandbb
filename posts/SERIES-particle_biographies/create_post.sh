#!/bin/bash

# Get the current date in yyyymoday format
DATE=$(date +"%Y%m%d")

# Ask the user for a title
read -p "Enter the title for the directory: " TITLE

# Remove spaces and replace them with underscores
TITLE_CLEAN=${TITLE// /_}

# Create the directory name
DIR_NAME="${DATE}_${TITLE_CLEAN}"

# Create the directory
mkdir -p "$DIR_NAME"

# Define the markdown template file
TEMPLATE_FILE="$DIR_NAME/${TITLE_CLEAN}.md"

# Define the template content
cat <<EOL > "$TEMPLATE_FILE"
---
title: "${TITLE_CLEAN}, 1"
author: "Chip Brock"
description: "An introduction to this post"
date: "$(date +"%Y-%m-%d")"
categories: [test] # self-defined categories
image: chip.png
draft: false # setting this to \`true\` will prevent your post from appearing on your listing page until you're ready!
fig-cap-location: margin
---

Content for this post
EOL

echo "Template created in $DIR_NAME/${TITLE_CLEAN}.md"