#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get mgm OTP
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Get mgm OTP via bash script
# @raycast.author rovn208
# @raycast.authorURL github.com/rovn208

cat ~/.mgm-totp-code | oathtool -b --totp - | xargs echo -n | pbcopy

