if [ "${OMARCHY_DISTRO:-}" == "gentoo" ]; then
    pkg_update_system

    # Configure emerge to automatically unmask packages
    # This writes changes to /etc/portage/package.* and continues installation
    if ! grep -q "EMERGE_DEFAULT_OPTS" /etc/portage/make.conf; then
        echo 'EMERGE_DEFAULT_OPTS="--autounmask=y --autounmask-write --autounmask-continue"' | sudo tee -a /etc/portage/make.conf >/dev/null
    fi

    # Ensure build tools are present
    pkg_install base-devel
    exit 0
fi

if [[ -n ${OMARCHY_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  sudo pacman -S --needed --noconfirm base-devel

  # Configure pacman
  if [[ ${OMARCHY_MIRROR:-} == "edge" ]] ; then
    sudo cp -f ~/.local/share/omarchy/default/pacman/pacman-edge.conf /etc/pacman.conf
    sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist-edge /etc/pacman.d/mirrorlist
  else
    sudo cp -f ~/.local/share/omarchy/default/pacman/pacman-stable.conf /etc/pacman.conf
    sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist-stable /etc/pacman.d/mirrorlist
  fi

  sudo pacman-key --recv-keys 40DFB630FF42BCFFB047046CF0134EE680CAC571 --keyserver keys.openpgp.org
  sudo pacman-key --lsign-key 40DFB630FF42BCFFB047046CF0134EE680CAC571

  sudo pacman -Sy
  sudo pacman -S --noconfirm --needed omarchy-keyring


  # Refresh all repos
  sudo pacman -Syyu --noconfirm
fi
