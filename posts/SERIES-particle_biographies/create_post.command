#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Change to the script's directory
cd "$SCRIPT_DIR" || exit

# Get the current date in yyyymoday format
DATE=$(date +"%Y%m%d")

# Prompt for title using AppleScript
TITLE=$(osascript -e 'Tell application "System Events" to display dialog "Enter the title for the directory:" default answer ""' -e 'text returned of result')

# Remove spaces and replace them with underscores
TITLE_CLEAN=${TITLE// /_}

# Create the directory name
DIR_NAME="${DATE}_${TITLE_CLEAN}"

# Create the directory in the same location as the script
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

echo "Template created in $SCRIPT_DIR/$DIR_NAME/${TITLE_CLEAN}.md"

# Keep the Terminal window open after execution
read -p "Press Enter to close this window..."