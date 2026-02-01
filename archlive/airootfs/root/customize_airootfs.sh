#!/bin/bash

echo "=== Starting customization for Indra Linux ==="

# Customize os-release
echo ">>> Customizing os-release..."
cat > /usr/lib/os-release << 'EOL'
NAME="Indra Linux"
PRETTY_NAME="Indra Linux"
ID=indralinux
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://indralinux.org/"
DOCUMENTATION_URL="https://docs.indralinux.org/"
SUPPORT_URL="https://forum.indralinux.org/"
BUG_REPORT_URL="https://bugs.indralinux.org/"
LOGO=indralinux
EOL

# Also update /etc/os-release
cp /usr/lib/os-release /etc/os-release

# Create a test file to verify hook ran
echo "Customization completed at $(date)" > /root/customization-complete.txt

echo "=== Customization complete ==="
