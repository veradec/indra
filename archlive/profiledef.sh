#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="indra"
iso_label="INDRA_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Indra Linux <https://indranow.site>"
iso_application="Indra Linux Live/Rescue DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="indra"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)

# Define post-installation commands
_customize_airootfs() {
    echo "=== Customizing for Indra Linux ==="
    
    # Create custom os-release
    echo ">>> Creating Indra Linux os-release..."
    
    # First, remove any existing file
    rm -f /usr/lib/os-release
    
    # Create the new os-release file
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
    
    # Update /etc/os-release symlink
    rm -f /etc/os-release
    ln -sf /usr/lib/os-release /etc/os-release
    
    # Create issue files (shown on login)
    cat > /etc/issue << 'EOL'
Indra Linux \r (\l)
EOL
    
    cat > /etc/issue.net << 'EOL'
Indra Linux
EOL
    
    # Set motd (Message of the Day)
    cat > /etc/motd << 'EOL'
Welcome to Indra Linux!
Documentation: https://docs.indralinux.org
EOL
    
    # Create verification file
    echo "Indra Linux customization completed at: $(date)" > /root/indra-build-info.txt
    echo "os-release updated successfully" >> /root/indra-build-info.txt
    
    echo "=== Customization complete ==="
}

# Run the customization
_customize_airootfs
