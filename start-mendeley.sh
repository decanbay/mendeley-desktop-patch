#!/bin/bash
# Mendeley Desktop Launcher for Ubuntu 24.04

# Fix text scaling for displays
# QT_SCALE_FACTOR scales icons and UI elements
# QT_FONT_DPI scales text/fonts
# Balance these to match icon and text sizes
# Note: Adjust these values based on your screen resolution and DPI
# Full HD (1920x1080): QT_SCALE_FACTOR=1.0, QT_FONT_DPI=200 balances icons and text
# Higher DPI displays: Try QT_SCALE_FACTOR=1.5, QT_FONT_DPI=96
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.0
export QT_FONT_DPI=200

cd "$(dirname "$0")"
# Run without grep to avoid keeping processes alive after quit
./bin/mendeleydesktop 2>/dev/null
