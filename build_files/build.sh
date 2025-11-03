#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
#rpm --import https://packages.microsoft.com/keys/microsoft.asc
#echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |  tee /etc/yum.repos.d/vscode.repo > /dev/null
#dnf check-update
#dnf -y install code 
dnf config-manager -y addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
dnf install -y mullvad-browser
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y @virtualization
dnf install -y @development-tools
#dnf install -y tmux neovim emacs zsh tailscale
#dnf install -y distrobox  usbguard usbguard-notifier setroubleshoot setools fscrypt neovim pam-u2f flatpak
#dnf install -y pam_yubico pamu2fcfg yubikey-manager  headsetcontrol gnome-text-editor evince 
#
FEDORA_PACKAGES=(
    mullvad-browser 
    deskflow
    tmux
    neovim
    emacs
    zsh
    fish
    tailscape
    freeipa-client
    distrobox
    usbguard
    usbguard-notifier
    setroubleshoot
    setools
    fscrypt
    neovim
    pam-u2f
    flatpak
    plasma-wallpapers-dynamic
    powertop
    ptyxis
    restic
    wireguard-tools
    zsh
    intel-media-driver
)

# Install all Fedora packages (bulk - safe from COPR injection)
echo "Installing ${#FEDORA_PACKAGES[@]} packages from Fedora repos..."
dnf -y install "${FEDORA_PACKAGES[@]}"
#
#
#systemctl enable podman.socket
#
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# Disable Fedora Flatpak remotes
for remote in fedora fedora-testing; do
   if flatpak remote-list | grep -q "$remote"; then
        flatpak remote-delete "$remote"
   fi
done

flatpak --system -y install --reinstall --or-update org.atheme.audacious org.videolan.VLC org.onlyoffice.desktopeditors io.mpv.Mpv com.usebottles.bottles net.lutris.Lutris
