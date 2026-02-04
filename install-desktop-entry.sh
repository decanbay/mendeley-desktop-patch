#!/bin/bash
# Desktop entry installer for Mendeley Desktop

set -e

# Check if we're in the Mendeley installation directory
if [ ! -f "bin/mendeleydesktop" ] || [ ! -f "start-mendeley.sh" ]; then
    echo "Error: This script must be run from the mendeleydesktop-1.19.8-linux-x86_64 directory"
    echo "Usage: cd mendeleydesktop-1.19.8-linux-x86_64 && ./install-desktop-entry.sh"
    exit 1
fi

INSTALL_DIR=$(pwd)
DESKTOP_FILE="$HOME/.local/share/applications/mendeleydesktop.desktop"

# Create desktop applications directory if it doesn't exist
mkdir -p "$HOME/.local/share/applications"

echo "Creating desktop entry for Mendeley Desktop..."
echo "Installation directory: $INSTALL_DIR"

# Create the desktop file with environment variables
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Mendeley Desktop
GenericName=Research Paper Manager
Comment=Mendeley Desktop is software for managing and sharing research papers
Exec=env QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_SCALE_FACTOR=1.0 QT_FONT_DPI=200 $INSTALL_DIR/start-mendeley.sh %f
Icon=$INSTALL_DIR/share/icons/hicolor/128x128/apps/mendeleydesktop.png
Terminal=false
Type=Application
Categories=Education;Literature;Qt;Science;
MimeType=x-scheme-handler/mendeley;application/pdf;text/x-bibtex;
X-Mendeley-Version=1.19.8
StartupWMClass=mendeleydesktop
EOF

chmod +x "$DESKTOP_FILE"

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    echo "✓ Desktop database updated"
fi

echo "✓ Desktop entry installed successfully!"
echo ""
echo "Mendeley Desktop should now appear in your applications menu."
echo ""
echo "To uninstall:"
echo "  rm ~/.local/share/applications/mendeleydesktop.desktop"
echo "  update-desktop-database ~/.local/share/applications"
