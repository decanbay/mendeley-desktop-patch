#!/bin/bash
# Automated installation script for Mendeley Desktop 1.19.8 on Ubuntu 24.04

set -e

echo "Mendeley Desktop 1.19.8 - Ubuntu 24.04 Compatibility Fix Installer"
echo "=================================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "bin/mendeleydesktop" ]; then
    echo "Error: This script must be run from the mendeleydesktop-1.19.8-linux-x86_64 directory"
    echo "Usage: cd mendeleydesktop-1.19.8-linux-x86_64 && ./path/to/install.sh"
    exit 1
fi

echo "✓ Found Mendeley installation directory"

# Check for dependencies
echo ""
echo "Checking dependencies..."
if ! dpkg -l | grep -q python3-setuptools; then
    echo "Installing python3-setuptools..."
    sudo apt update
    sudo apt install -y python3-setuptools
else
    echo "✓ python3-setuptools already installed"
fi

# Backup original file
echo ""
echo "Creating backup of original launcher..."
if [ ! -f "bin/mendeleydesktop.original" ]; then
    cp bin/mendeleydesktop bin/mendeleydesktop.original
    echo "✓ Backup created: bin/mendeleydesktop.original"
else
    echo "✓ Backup already exists"
fi

# Apply the Python 3.12 compatibility fix
echo ""
echo "Applying Python 3.12 compatibility fix..."
cat > /tmp/mendeley_header_fix.py << 'EOFPYTHON'
#!/usr/bin/env python

from __future__ import print_function
try:
    import distutils.version
except ImportError:
    # distutils was removed in Python 3.12, use packaging as fallback
    try:
        from packaging import version as distutils_version
        class version:
            class StrictVersion:
                def __init__(self, vstring):
                    self.version = distutils_version.parse(vstring)
                def __cmp__(self, other):
                    if self.version < other.version:
                        return -1
                    elif self.version > other.version:
                        return 1
                    return 0
                def __lt__(self, other):
                    return self.version < other.version
                def __le__(self, other):
                    return self.version <= other.version
                def __gt__(self, other):
                    return self.version > other.version
                def __ge__(self, other):
                    return self.version >= other.version
                def __eq__(self, other):
                    return self.version == other.version
        distutils = type('distutils', (), {'version': version})()
    except ImportError:
        # If packaging is also not available, create a minimal implementation
        class version:
            class StrictVersion:
                def __init__(self, vstring):
                    self.vstring = vstring
                    self.version = tuple(map(int, vstring.split('.')))
                def __cmp__(self, other):
                    if self.version < other.version:
                        return -1
                    elif self.version > other.version:
                        return 1
                    return 0
                def __lt__(self, other):
                    return self.version < other.version
                def __le__(self, other):
                    return self.version <= other.version
                def __gt__(self, other):
                    return self.version > other.version
                def __ge__(self, other):
                    return self.version >= other.version
                def __eq__(self, other):
                    return self.version == other.version
        distutils = type('distutils', (), {'version': version})()
import os
import platform
import subprocess
import sys
EOFPYTHON

# Replace the first 8 lines of bin/mendeleydesktop
tail -n +9 bin/mendeleydesktop.original > /tmp/mendeley_rest.py
cat /tmp/mendeley_header_fix.py /tmp/mendeley_rest.py > bin/mendeleydesktop
chmod +x bin/mendeleydesktop
rm /tmp/mendeley_header_fix.py /tmp/mendeley_rest.py

echo "✓ Python compatibility fix applied"

# Copy the launcher script
echo ""
echo "Installing launcher script..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "$SCRIPT_DIR/start-mendeley.sh" ]; then
    cp "$SCRIPT_DIR/start-mendeley.sh" ./start-mendeley.sh
    chmod +x start-mendeley.sh
    echo "✓ Launcher script installed"
else
    echo "Warning: start-mendeley.sh not found in script directory"
    echo "Creating default launcher..."
    cat > start-mendeley.sh << 'EOF'
#!/bin/bash
# Mendeley Desktop Launcher for Ubuntu 24.04

# Fix text scaling for high-DPI displays
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_SCALE_FACTOR=1.5
export QT_FONT_DPI=96

cd "$(dirname "$0")"
./bin/mendeleydesktop 2>&1 | grep -v "DeprecationWarning" | grep -v "distutils Version classes"
EOF
    chmod +x start-mendeley.sh
    echo "✓ Default launcher script created"
fi

echo ""
echo "=================================================================="
echo "Installation complete!"
echo ""
echo "To run Mendeley Desktop, use:"
echo "  ./start-mendeley.sh"
echo ""
echo "To restore the original version:"
echo "  cp bin/mendeleydesktop.original bin/mendeleydesktop"
echo ""
