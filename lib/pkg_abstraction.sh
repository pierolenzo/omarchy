#!/bin/bash

# Omarchy Package Manager Abstraction Layer
# Handles differences between Arch Linux (pacman) and Gentoo Linux (emerge/portage)

# Determine library path
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_LIB_DIR/pkg_mapping.sh"

get_distro() {
    if [ -f /etc/gentoo-release ]; then
        echo "gentoo"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        # Fallback detection
        if command -v emerge >/dev/null; then
            echo "gentoo"
        elif command -v pacman >/dev/null; then
            echo "arch"
        else
            echo "unknown"
        fi
    fi
}

export OMARCHY_DISTRO=$(get_distro)

# Wrapper to run commands with sudo if not root
_sudo_cmd() {
    if [ "$EUID" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Helper to map multiple packages
_map_packages() {
    local mapped=()
    for pkg in "$@"; do
        local mapped_pkg
        mapped_pkg=$(get_mapped_pkg "$pkg")
        # Ignore package if mapped to "IGNORE" or empty
        if [[ "$mapped_pkg" != "IGNORE" && -n "$mapped_pkg" ]]; then
            mapped+=("$mapped_pkg")
        fi
    done
    echo "${mapped[@]}"
}

# Install packages
# Usage: pkg_install package1 package2 ...
pkg_install() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        local mapped_pkgs=()
        for pkg in "$@"; do
            local mapped_pkg
            mapped_pkg=$(get_mapped_pkg "$pkg")

            # Skip IGNORED packages
            if [[ "$mapped_pkg" == "IGNORE" || -z "$mapped_pkg" ]]; then
                continue
            fi

            mapped_pkgs+=("$mapped_pkg")
        done

        # Only run emerge if there are packages to install
        if [ ${#mapped_pkgs[@]} -gt 0 ]; then
            # Gentoo: using emerge
            # --noreplace prevents re-installing if already there, similar to --needed
            _sudo_cmd emerge --ask=n --verbose --noreplace "${mapped_pkgs[@]}"
        fi
    else
        # Arch: using pacman
        _sudo_cmd pacman -S --noconfirm --needed -- "$@"
    fi
}

# Remove packages
# Usage: pkg_remove package1 package2 ...
pkg_remove() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        local mapped_pkgs=()
        for pkg in "$@"; do
            local mapped_pkg
            mapped_pkg=$(get_mapped_pkg "$pkg")

            # Skip IGNORED packages
            if [[ "$mapped_pkg" == "IGNORE" || -z "$mapped_pkg" ]]; then
                continue
            fi

            mapped_pkgs+=("$mapped_pkg")
        done

        if [ ${#mapped_pkgs[@]} -gt 0 ]; then
            # Gentoo: unmerge
            _sudo_cmd emerge --ask=n --unmerge "${mapped_pkgs[@]}"
        fi
    else
        # Arch: remove package and unneeded dependencies
        _sudo_cmd pacman -Rns --noconfirm -- "$@"
    fi
}

# Check if package is installed
# Usage: pkg_is_installed package_name
# Returns 0 if installed, 1 otherwise
pkg_is_installed() {
    local pkg="$1"
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        pkg="$(get_mapped_pkg "$pkg")"
        if [[ "$pkg" == "IGNORE" || -z "$pkg" ]]; then
            return 1 # Ignored packages are technically not installed in the context of our requirement
        fi

        # Gentoo: check with qlist (app-portage/portage-utils) or equery (app-portage/gentoolkit)
        if command -v qlist >/dev/null; then
            # qlist -I returns installed packages matching the arg
            qlist -I "$pkg" | grep -q .
        elif command -v eix >/dev/null; then
            eix -I -e "$pkg"
        elif command -v equery >/dev/null; then
            equery list "$pkg" >/dev/null 2>&1
        else
            # Fallback slow check via emerge
            # This is slow but reliable for standard atoms
            if emerge --list-sets | grep -q "^$pkg$"; then
                 return 0
            fi
            # Check if directory exists in var db (very rough check for atoms category/package)
            if [ -d "/var/db/pkg/$pkg" ] || ls -d /var/db/pkg/*/"${pkg##*/}"-[0-9]* >/dev/null 2>&1; then
                 return 0
            fi
            return 1
        fi
    else
        # Arch
        pacman -Q -- "$pkg" >/dev/null 2>&1
    fi
}

# Check if all of the named packages are installed
# Usage: pkgs_are_installed package1 package2 ...
# Returns 0 if all are installed, 1 otherwise
pkgs_are_installed() {
    if [ "$OMARCHY_DISTRO" == "arch" ]; then
        pacman -Q -- "$@" >/dev/null 2>&1
    else
        # Gentoo or fallback
        for pkg in "$@"; do
            pkg_is_installed "$pkg" || return 1
        done
        return 0
    fi
}

# Update the system
pkg_update_system() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        _sudo_cmd emaint -a sync
        _sudo_cmd emerge --ask=n --verbose --update --deep --newuse @world
    else
        _sudo_cmd pacman -Syu --noconfirm
    fi
}

# Remove orphan packages
pkg_remove_orphans() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        _sudo_cmd emerge --ask=n --depclean
    else
        local orphans
        orphans=$(pacman -Qtdq || true)
        if [[ -n $orphans ]]; then
             _sudo_cmd pacman -Rs --noconfirm $orphans
        fi
    fi
}

# List all available packages (for fuzzy search)
pkg_list_all() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        # This is tricky on Gentoo as the list is huge.
        # eix is best for this.
        if command -v eix >/dev/null; then
            eix -c --pure-packages
        else
            # Fallback: list category/package from portage tree (very slow)
            find /var/db/repos/gentoo -mindepth 2 -maxdepth 2 -type d | awk -F/ '{print $(NF-1)"/"$NF}'
        fi
    else
        pacman -Slq
    fi
}

# List installed packages (explicitly installed preferred)
pkg_list_installed() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        if command -v qlist >/dev/null; then
            qlist -I
        elif command -v equery >/dev/null; then
            equery list '*'
        else
            # Very basic fallback
            ls -d /var/db/pkg/*/* | cut -d/ -f5-6
        fi
    else
        if command -v yay >/dev/null; then
            yay -Qqe
        else
            pacman -Qqe
        fi
    fi
}

# Get info about a package
pkg_info() {
    local pkg="$1"
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        pkg="$(get_mapped_pkg "$pkg")"
        if [[ "$pkg" == "IGNORE" || -z "$pkg" ]]; then
            echo "Package $1 is ignored on Gentoo."
        else
            emerge --search "$pkg"
        fi
    else
        pacman -Sii -- "$pkg"
    fi
}

# List packages for debug info (name + version + repo)
pkg_list_debug_info() {
    if [ "$OMARCHY_DISTRO" == "gentoo" ]; then
        # qlist -IV lists category/package-version
        if command -v qlist >/dev/null; then
            qlist -IV
        elif command -v eix >/dev/null; then
            eix -I
        else
            emerge --info
        fi
    else
        { expac -S '%n %v (%r)' $(pacman -Qqe) 2>/dev/null; comm -13 <(pacman -Sql | sort) <(pacman -Qqe | sort) | xargs -r expac -Q '%n %v (AUR)'; } | sort
    fi
}
