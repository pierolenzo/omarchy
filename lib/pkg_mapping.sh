#!/bin/bash

# Omarchy Package Mapping
# Maps Arch Linux package names to Gentoo Linux package atoms

declare -A PKG_MAP_GENTOO

init_gentoo_map() {
    PKG_MAP_GENTOO=(
        # System / Core
        ["base-devel"]="IGNORE" # Assumed to be covered by @system
        ["git"]="dev-vcs/git"
        ["curl"]="net-misc/curl"
        ["wget"]="net-misc/wget"
        ["vim"]="app-editors/vim"
        ["neovim"]="app-editors/neovim"
        ["nvim"]="app-editors/neovim"
        ["sudo"]="app-admin/sudo"
        ["man-db"]="sys-apps/man-db"
        ["less"]="sys-apps/less"
        ["unzip"]="app-arch/unzip"
        ["polkit-gnome"]="sys-auth/polkit-gnome"

        # Arch specific - IGNORE
        ["expac"]="IGNORE"
        ["yay"]="IGNORE"
        ["pacman-contrib"]="IGNORE"
        ["debtap"]="IGNORE" # Often used in Arch
        
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
        ["fastfetch"]="app-misc/fastfetch"
        ["lazygit"]="dev-vcs/lazygit"
        ["lazydocker"]="app-containers/lazydocker"
        ["yq"]="app-misc/yq"
        ["gum"]="app-shells/gum"
        ["tldr"]="app-text/tldr"
        ["plocate"]="sys-apps/plocate"
        ["whois"]="net-misc/whois"
        ["inetutils"]="sys-apps/inetutils"
        ["tree-sitter-cli"]="dev-util/tree-sitter-cli"
        ["inxi"]="sys-apps/inxi"
        ["dust"]="sys-fs/dust"

        # GUI / Wayland
        ["hyprland"]="gui-wm/hyprland"
        ["waybar"]="gui-apps/waybar"
        ["swaybg"]="gui-apps/swaybg"
        ["hyprlock"]="gui-apps/hyprlock"
        ["hypridle"]="gui-apps/hypridle"
        ["hyprpicker"]="gui-apps/hyprpicker"
        ["hyprsunset"]="gui-apps/hyprsunset"
        ["mako"]="gui-apps/mako"
        ["walker"]="gui-apps/walker"
        ["omarchy-walker"]="gui-apps/walker" # Assuming omarchy-walker is just walker config or similar, but if it is a pkg, it might need ignore. Assuming walker here.
        ["kitty"]="x11-terms/kitty"
        ["alacritty"]="x11-terms/alacritty"
        ["foot"]="x11-terms/foot"
        ["ghostty"]="x11-terms/ghostty" 
        ["sddm"]="x11-misc/sddm"
        ["plymouth"]="sys-boot/plymouth"
        ["brightnessctl"]="dev-libs/brightnessctl"
        ["playerctl"]="media-sound/playerctl"
        ["grim"]="gui-apps/grim"
        ["slurp"]="gui-apps/slurp"
        ["wl-clipboard"]="gui-apps/wl-clipboard"
        ["cliphist"]="gui-apps/cliphist" # often paired
        ["uwsm"]="gui-apps/uwsm"
        
        # Desktop / Apps
        ["nautilus"]="gnome-base/nautilus"
        ["gnome-disk-utility"]="gnome-extra/gnome-disk-utility"
        ["gnome-calculator"]="gnome-extra/gnome-calculator"
        ["evince"]="app-text/evince"
        ["sushi"]="gnome-extra/sushi"
        ["loupe"]="media-gfx/loupe" # Arch might use this
        ["baobab"]="gnome-extra/baobab"
        ["totem"]="media-video/totem"
        ["file-roller"]="app-arch/file-roller"
        ["xdg-desktop-portal-gtk"]="sys-apps/xdg-desktop-portal-gtk"
        ["xdg-desktop-portal-hyprland"]="gui-libs/xdg-desktop-portal-hyprland"
        ["xdg-terminal-exec"]="gui-libs/xdg-terminal-exec"
        ["libsecret"]="app-crypt/libsecret"
        ["gnome-keyring"]="gnome-base/gnome-keyring"
        ["gnome-themes-extra"]="x11-themes/gnome-themes-extra"

        # Web / Comms
        ["firefox"]="www-client/firefox"
        ["chromium"]="www-client/chromium"
        ["omarchy-chromium"]="www-client/chromium" # Fallback
        ["signal-desktop"]="net-im/signal-desktop-bin" # Gentoo often uses bin for signal
        ["discord"]="net-im/discord-bin" # Common app
        ["spotify"]="media-sound/spotify"

        # Creative / Office
        ["inkscape"]="media-gfx/inkscape"
        ["gimp"]="media-gfx/gimp"
        ["libreoffice-fresh"]="app-office/libreoffice" # Gentoo just has libreoffice
        ["obs-studio"]="media-video/obs-studio"
        ["kdenlive"]="media-video/kdenlive"
        ["pinta"]="media-gfx/pinta"
        ["xournalpp"]="app-text/xournalpp"
        ["mpv"]="media-video/mpv"
        ["imv"]="media-gfx/imv"
        ["imagemagick"]="media-gfx/imagemagick"
        ["ffmpegthumbnailer"]="media-video/ffmpegthumbnailer"

        # Development
        ["code"]="app-editors/vscode" # Arch usually visual-studio-code-bin
        ["visual-studio-code-bin"]="app-editors/vscode"
        ["opencode"]="IGNORE" # Custom package?
        ["github-cli"]="dev-util/github-cli"
        ["docker"]="app-containers/docker"
        ["docker-buildx"]="app-containers/docker-buildx"
        ["docker-compose"]="app-containers/docker-compose"
        ["clang"]="sys-devel/clang"
        ["llvm"]="sys-devel/llvm"
        ["rust"]="dev-lang/rust"
        ["ruby"]="dev-lang/ruby"
        ["luarocks"]="dev-lua/luarocks"
        ["mise"]="dev-util/mise" # Version manager
        ["python-poetry-core"]="dev-python/poetry-core"
        
        # Fonts
        ["noto-fonts"]="media-fonts/noto"
        ["noto-fonts-cjk"]="media-fonts/noto-cjk"
        ["noto-fonts-emoji"]="media-fonts/noto-emoji"
        ["fontconfig"]="media-libs/fontconfig"
        # Nerd fonts are often split in Gentoo GURU or other overlays
        ["ttf-jetbrains-mono-nerd"]="media-fonts/jetbrains-mono"
        ["ttf-cascadia-mono-nerd"]="media-fonts/cascadia-code"
        
        # Audio / Bluetooth
        ["pipewire"]="media-video/pipewire"
        ["wireplumber"]="media-video/wireplumber"
        ["pamixer"]="media-sound/pamixer"
        ["bluez"]="net-wireless/bluez"
        ["bluetui"]="net-wireless/bluetui"
        
        # Network / Hardware
        ["iwd"]="net-wireless/iwd"
        ["avahi"]="net-dns/avahi"
        ["nss-mdns"]="net-dns/nss-mdns"
        ["cups"]="net-print/cups"
        ["cups-filters"]="net-print/cups-filters"
        ["cups-browsed"]="net-print/cups-browsed" # Sometimes part of filters or separate
        ["system-config-printer"]="app-admin/system-config-printer"
        ["ufw"]="net-firewall/ufw"
        ["ufw-docker"]="IGNORE" # Arch specific helper? Or check overlay
        ["bolt"]="sys-apps/bolt"
        ["power-profiles-daemon"]="sys-power/power-profiles-daemon"
        ["wireless-regdb"]="net-wireless/wireless-regdb"
        
        # Misc / Libs
        ["xmlstarlet"]="app-text/xmlstarlet"
        ["libyaml"]="dev-libs/libyaml"
        ["libqalculate"]="sci-libs/libqalculate"
        ["exfatprogs"]="sys-fs/exfatprogs"
        ["kvantum-qt5"]="x11-themes/kvantum"
        ["qt5-wayland"]="dev-qt/qtwayland:5"
        ["fcitx5"]="app-i18n/fcitx"
        ["fcitx5-gtk"]="app-i18n/fcitx-gtk"
        ["fcitx5-qt"]="app-i18n/fcitx-qt"
        
        # Omarchy specifics / Custom / AUR
        ["1password-beta"]="IGNORE" # AUR
        ["1password-cli"]="app-admin/1password-cli"
        ["aether"]="IGNORE" # Theme?
        ["asdcontrol"]="IGNORE" # Apple Silicon daemon?
        ["satty"]="gui-apps/satty"
        ["wayfreeze"]="gui-apps/wayfreeze"
        ["gpu-screen-recorder"]="media-video/gpu-screen-recorder" # Might be in overlay
        ["omarchy-nvim"]="IGNORE" # Config package
        ["tobi-try"]="IGNORE" # Unknown
        ["wiremix"]="IGNORE" # Unknown
        ["usage"]="IGNORE" # Unknown tool
        ["yaru-icon-theme"]="x11-themes/yaru-theme"
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
