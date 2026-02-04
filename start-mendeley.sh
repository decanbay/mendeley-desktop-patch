#!/bin/bash
# Mendeley Desktop Launcher for Ubuntu 24.04
# Suppresses deprecation warnings for cleaner output

# Fix text scaling for high-DPI displays
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.5
export QT_FONT_DPI=96

cd "$(dirname "$0")"
./bin/mendeleydesktop 2>&1 | grep -v "DeprecationWarning" | grep -v "distutils Version classes"
