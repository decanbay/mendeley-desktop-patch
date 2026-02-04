# Mendeley Desktop 1.19.8 - Ubuntu 24.04 Compatibility Fix

This repository contains patches and scripts to fix Mendeley Desktop 1.19.8 compatibility issues on Ubuntu 24.04.

## Problem

Mendeley Desktop 1.19.8 doesn't work out of the box on Ubuntu 24.04 due to:
- Python 3.12 removing the `distutils` module
- Small text scaling on modern displays

## Prerequisites

1. **Download Mendeley Desktop 1.19.8**:
   ```bash
   wget https://desktop-download.mendeley.com/download/linux/mendeleydesktop-1.19.8-linux-x86_64.tar.bz2
   ```
   Or download from: https://www.mendeley.com/autoupdates/installers/1.19.8

2. **Extract the tarball**:
   ```bash
   tar -xf mendeleydesktop-1.19.8-linux-x86_64.tar.bz2
   cd mendeleydesktop-1.19.8-linux-x86_64
   ```

3. **Clone this repository**:
   ```bash
   git clone https://github.com/decanbay/mendeley-desktop-patch.git
   ```

4. **Install required dependencies**:
   ```bash
   sudo apt install python3-setuptools
   ```

## Installation

### Option 1: Automatic Installation (Recommended)

```bash
cd mendeleydesktop-1.19.8-linux-x86_64
bash mendeley-desktop-patch/install.sh
```

### Option 2: Manual Patch

```bash
cd mendeleydesktop-1.19.8-linux-x86_64
patch -p1 < mendeley-desktop-patch/mendeleydesktop.patch
cp mendeley-desktop-patch/start-mendeley.sh .
chmod +x start-mendeley.sh
```

## Usage

Run Mendeley Desktop using the launcher script:

```bash
./start-mendeley.sh
```

The launcher script:
- Fixes text scaling issues (1.0x scale, 200 DPI by default)
- Sets proper Qt environment variables for modern displays
- Suppresses deprecation warnings

### Adding `mendeley` Command to PATH

To launch Mendeley from anywhere by just typing `mendeley`:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/mendeley << 'EOF'
~/mendeleydesktop-1.19.8-linux-x86_64/start-mendeley.sh "$@"
EOF
chmod +x ~/.local/bin/mendeley

# Add to PATH if not already there
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Adjust the path if you extracted Mendeley to a different location
Replace `/path/to/` with your actual installation directory.

Now you can launch Mendeley from any terminal:
```bash
mendeley
```

## Customizing Text Scale

The default settings work well for Full HD (1920x1080) displays with balanced icon and text sizes. 

**Important**: `QT_SCALE_FACTOR` scales icons and UI elements, while `QT_FONT_DPI` scales text. Adjust both to keep them balanced.

### For Full HD (1920x1080) screens - Default:
```bash
export QT_SCALE_FACTOR=1.0
export QT_FONT_DPI=200
```
This provides good balance between icon size and text size.

### For High DPI / 4K displays:
```bash
export QT_SCALE_FACTOR=1.5
export QT_FONT_DPI=96
```

### Fine-tuning tips:
- **Icons too small?** Increase `QT_SCALE_FACTOR` (e.g., 1.25, 1.5, 2.0)
- **Text too small?** Increase `QT_FONT_DPI` (e.g., 120, 150, 200)
- **Icons too large?** Decrease `QT_SCALE_FACTOR` (e.g., 0.75, 0.5)
- **Text too large?** Decrease `QT_FONT_DPI` (e.g., 96, 120)

### Other common configurations:
- **Small overall**: `QT_SCALE_FACTOR=0.75` and `QT_FONT_DPI=96`
- **Medium overall**: `QT_SCALE_FACTOR=1.25` and `QT_FONT_DPI=150`
- **Large overall**: `QT_SCALE_FACTOR=2.0` and `QT_FONT_DPI=96`

**Tip**: Keep the ratio between `QT_SCALE_FACTOR` and `QT_FONT_DPI` balanced. If icons and text don't match, adjust one value at a time.

## Adding Desktop Entry (Application Menu)

To make Mendeley Desktop appear in your applications menu:

```mendeleydesktop-1.19.8-linux-x86_64
bash mendeley-desktop-patch/install-desktop-entry.sh
```

This will create a desktop entry
This will create a desktop entry at `~/.local/share/applications/mendeleydesktop.desktop` and you'll be able to launch Mendeley from your application menu.

### Manual Desktop Entry Installation

If you prefer to install manually:

```bash
cd /path/to/mendeleydesktop-1.19.8-linux-x86_64
INSTALL_DIR=$(pwd)
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/mendeleydesktop.desktop << EOF
[Desktop Entry]
Name=Mendeley Desktop
GenericName=Research Paper Manager
Comment=Mendeley Desktop is software for managing and sharing research papers
Exec=env QT_AUTO_SCREEN_SCALE_FACTOR=1 QT_SCALE_FACTOR=1.5 QT_FONT_DPI=bin/mendeleydesktop
- **Desktop entry quit issues**: When launched from GNOME menu, the application may not quit cleanly. Use `pkill -f mendeleydesktop` if needed, or prefer launching from terminal with `mendeley` command.200 $INSTALL_DIR/start-mendeley.sh %f
Icon=$INSTALL_DIR/share/icons/hicolor/128x128/apps/mendeleydesktop.png
Terminal=false
Type=Application
Categories=Education;Literature;Qt;Science;
MimeType=x-scheme-handler/mendeley;application/pdf;text/x-bibtex;
X-Mendeley-Version=1.19.8
StartupWMClass=mendeleydesktop
EOF

chmod +x ~/.local/share/applications/mendeleydesktop.desktop
update-desktop-database ~/.local/share/applications
```

### Uninstalling Desktop Entry

```bash
rm ~/.local/share/applications/mendeleydesktop.desktop
update-desktop-database ~/.local/share/applications
```

## Known Issues

- **gconf2 warning**: This is expected on Ubuntu 24.04 (package is obsolete). The warning is harmless and doesn't affect functionality.
- **Link handler warnings**: Non-critical, most features work normally.

## License

These patches are provided as-is for personal use. Mendeley Desktop itself is proprietary software owned by Elsevier.

**Note**: This repository does NOT contain Mendeley Desktop software itself, only compatibility patches. You must download Mendeley Desktop from the official source.

## Compatibility

- ✅ Ubuntu 24.04 LTS
- ✅ Python 3.12
- ✅ Qt 5.x applications

Should also work on other recent Debian-based distributions with Python 3.12+.
