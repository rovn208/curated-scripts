#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Extract valid JSON
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Extract valid JSON from clipboard
# @raycast.author rovn208
# @raycast.authorURL github.com/rovn208

# Get clipboard content
clipboard_content=$(pbpaste)

# Function to extract the largest possible valid JSON
extract_json() {
    local content="$1"
    local depth=0
    local json=""
    local in_string=0

    # Iterate over each character
    for (( i=0; i<${#content}; i++ )); do
        char="${content:i:1}"

        # Check if we are entering or leaving a string
        if [[ "$char" == '"' ]]; then
            in_string=$((1 - in_string))
        fi

        # Adjust depth for braces
        if [[ "$in_string" -eq 0 ]]; then
            if [[ "$char" == '{' ]]; then
                depth=$((depth + 1))
            elif [[ "$char" == '}' ]]; then
                depth=$((depth - 1))
            elif [[ "$char" == '[' ]]; then
                depth=$((depth + 1))
            elif [[ "$char" == ']' ]]; then
                depth=$((depth - 1))
            fi
        fi

        # Add to json string
        json+="$char"

        # If depth is zero and we have some JSON collected, break
        if [[ $depth -eq 0 && -n "$json" ]]; then
            break
        fi
    done

    # Return the extracted JSON
    echo "$json"
}

# Extract potential JSON
extracted_json=$(extract_json "$clipboard_content")

# Check if the extracted JSON is valid
if echo "$extracted_json" | jq . > /dev/null 2>&1; then
    echo "$extracted_json" | pbcopy
else
    echo "No valid JSON found."
fi
