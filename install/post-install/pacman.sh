# Configure pacman

# Load abstraction layer to be sure about distro
source "$OMARCHY_INSTALL/../lib/pkg_abstraction.sh"

if [ "$OMARCHY_DISTRO" != "arch" ]; then
    echo "Skipping pacman configuration on $OMARCHY_DISTRO"
    exit 0
fi

sudo cp -f ~/.local/share/omarchy/default/pacman/pacman-${OMARCHY_MIRROR:-stable}.conf /etc/pacman.conf
sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist-${OMARCHY_MIRROR:-stable} /etc/pacman.d/mirrorlist

if lspci -nn | grep -q "106b:180[12]"; then
  cat <<EOF | sudo tee -a /etc/pacman.conf >/dev/null

[arch-mact2]
Server = https://github.com/NoaHimesaka1873/arch-mact2-mirror/releases/download/release
SigLevel = Never
EOF
fi
