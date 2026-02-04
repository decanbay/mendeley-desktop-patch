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

3. **Install required dependencies**:
   ```bash
   sudo apt install python3-setuptools
   ```

## Installation

### Option 1: Automatic Patch (Recommended)

```bash
cd /path/to/mendeleydesktop-1.19.8-linux-x86_64
patch -p1 < /path/to/mendeleydesktop.patch
cp /path/to/start-mendeley.sh .
chmod +x start-mendeley.sh
```

### Option 2: Manual Fix

1. **Fix Python compatibility** - Apply the changes from `mendeleydesktop.patch` to `bin/mendeleydesktop`

2. **Add the launcher script** - Copy `start-mendeley.sh` to the Mendeley installation directory

3. **Make it executable**:
   ```bash
   chmod +x start-mendeley.sh
   ```

## Usage

Run Mendeley Desktop using the launcher script:

```bash
./start-mendeley.sh
```

The launcher script:
- Fixes text scaling issues (1.5x by default)
- Filters out deprecation warnings for cleaner output
- Sets proper Qt environment variables for modern displays

## Customizing Text Scale

If the text is too small or too large, edit `start-mendeley.sh` and adjust the `QT_SCALE_FACTOR` value:

- `1.0` = Normal size
- `1.25` = 25% larger
- `1.5` = 50% larger (default)
- `2.0` = 100% larger (double size)

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
