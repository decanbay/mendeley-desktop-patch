#!/bin/bash
# Mendeley Desktop Launcher for Ubuntu 24.04
# Suppresses deprecation warnings for cleaner output

# Fix text scaling for displays
# Note: Adjust these values based on your screen resolution and DPI
# Full HD (1920x1080): QT_SCALE_FACTOR=0.5, QT_FONT_DPI=500 works well
# Higher DPI displays: QT_SCALE_FACTOR=1.5, QT_FONT_DPI=96 might be better
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=0.5
export QT_FONT_DPI=500

cd "$(dirname "$0")"
./bin/mendeleydesktop 2>&1 | grep -v "DeprecationWarning" | grep -v "distutils Version classes"
