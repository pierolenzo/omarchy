#!/bin/bash

# Omarchy Package Mapping
# Maps Arch Linux package names to Gentoo Linux package atoms

declare -A PKG_MAP_GENTOO

init_gentoo_map() {
    PKG_MAP_GENTOO=(
        # System / Core
        ["base-devel"]="sys-devel/base-devel" # Virtual in Gentoo? No, usually meta.
        ["git"]="dev-vcs/git"
        ["curl"]="net-misc/curl"
        ["wget"]="net-misc/wget"
        ["vim"]="app-editors/vim"
        ["neovim"]="app-editors/neovim"
        ["nvim"]="app-editors/neovim"
        ["sudo"]="app-admin/sudo"
        
        # Shell & Tools
        ["bat"]="sys-apps/bat"
        ["btop"]="sys-process/btop"
        ["eza"]="sys-apps/eza"
        ["fd"]="sys-apps/fd"
        ["fzf"]="app-shells/fzf"
        ["jq"]="app-misc/jq"
        ["ripgrep"]="sys-apps/ripgrep"
        ["starship"]="app-shells/starship"
        ["zoxide"]="app-shells/zoxide"
        
        # GUI / Wayland
        ["hyprland"]="gui-wm/hyprland"
        ["waybar"]="gui-apps/waybar"
        ["swaybg"]="gui-apps/swaybg"
        ["swaylock"]="gui-apps/swaylock" # Omarchy uses hyprlock?
        ["hyprlock"]="gui-apps/hyprlock"
        ["hypridle"]="gui-apps/hypridle"
        ["mako"]="gui-apps/mako"
        ["wofi"]="gui-apps/wofi" # Omarchy uses walker?
        ["walker"]="gui-apps/walker" # Might need overlay
        ["kitty"]="x11-terms/kitty"
        ["alacritty"]="x11-terms/alacritty"
        ["foot"]="x11-terms/foot"
        ["ghostty"]="x11-terms/ghostty" 
        
        # Apps
        ["firefox"]="www-client/firefox"
        ["chromium"]="www-client/chromium"
        ["mpv"]="media-video/mpv"
        ["imv"]="media-gfx/imv"
        ["thunar"]="xfce-base/thunar"
        ["nautilus"]="gnome-base/nautilus"
        
        # Fonts
        ["noto-fonts"]="media-fonts/noto"
        ["noto-fonts-emoji"]="media-fonts/noto-emoji"
        ["ttf-jetbrains-mono-nerd"]="media-fonts/jetbrains-mono" # Nerd fonts are complex in Gentoo
        
        # Audio
        ["pipewire"]="media-video/pipewire"
        ["wireplumber"]="media-video/wireplumber"
        ["pamixer"]="media-sound/pamixer"
        
        # Network
        ["iwd"]="net-wireless/iwd"
        
        # Misc
        ["docker"]="app-containers/docker"
        ["docker-compose"]="app-containers/docker-compose"
        
        # Tools
        ["wtype"]="gui-apps/wtype"
    )
}

# Function to translate a package name
get_mapped_pkg() {
    local pkg="$1"
    
    # Only map if on Gentoo
    if [ "$OMARCHY_DISTRO" != "gentoo" ]; then
        echo "$pkg"
        return
    fi

    # Initialize if empty
    if [ ${#PKG_MAP_GENTOO[@]} -eq 0 ]; then
        init_gentoo_map
    fi

    if [ -n "${PKG_MAP_GENTOO[$pkg]}" ]; then
        echo "${PKG_MAP_GENTOO[$pkg]}"
    else
        echo "$pkg"
    fi
}
