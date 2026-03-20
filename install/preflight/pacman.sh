if [ "${OMARCHY_DISTRO:-}" == "gentoo" ]; then
    pkg_update_system

    # Configure emerge to automatically unmask packages
    # This writes changes to /etc/portage/package.* and continues installation
    if ! grep -q "EMERGE_DEFAULT_OPTS" /etc/portage/make.conf; then
        echo 'EMERGE_DEFAULT_OPTS="--autounmask=y --autounmask-write --autounmask-continue"' | sudo tee -a /etc/portage/make.conf >/dev/null
    fi

    # Enable ~amd64 keyword globally for testing packages
    if ! grep -q "ACCEPT_KEYWORDS" /etc/portage/make.conf; then
        echo 'ACCEPT_KEYWORDS="~amd64"' | sudo tee -a /etc/portage/make.conf >/dev/null
    fi

    # Ensure build tools are present
    pkg_install base-devel
    exit 0
fi

if [[ -n ${OMARCHY_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  omarchy-pkg-add base-devel

  # Configure pacman
  sudo cp -f ~/.local/share/omarchy/default/pacman/pacman-${OMARCHY_MIRROR:-stable}.conf /etc/pacman.conf
  sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist-${OMARCHY_MIRROR:-stable} /etc/pacman.d/mirrorlist

  sudo pacman-key --recv-keys 40DFB630FF42BCFFB047046CF0134EE680CAC571 --keyserver keys.openpgp.org
  sudo pacman-key --lsign-key 40DFB630FF42BCFFB047046CF0134EE680CAC571

  sudo pacman -Sy
  omarchy-pkg-add omarchy-keyring

  # Refresh all repos
  sudo pacman -Syyuu --noconfirm
fi
