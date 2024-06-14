#!/bin/bash

# Function to display the menu
show_menu() {
    echo "Select an Option:"
    echo "1) Install Kopia and KopiaUI"
    echo "2) Setup Nvidia GPU drivers"
    echo "3) Setup RPM Fusion Free and Non-free"
    echo "4) Swap from Gnome Shell to KDE Plasma"
    echo "5) Setup Flatpak"
    echo "6) Install Essential Flatpak Apps"
    echo "7) Install Additional Flatpak Apps"
    echo "8) Setup Bluetooth"
    echo "9) Setup Tailscale"
    echo "10) Install Nix (Experimental)"
    echo "11) Exit"
}

# Function to execute the selected command
execute_command() {
    case $choice in
        1)
            sudo dnf install kopia kopia-ui
            ;;
        2)
            sudo dnf install akmod-nvidia xorg-x11-drv-nvidia
            sudo grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
            ;;
        3)
            sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            ;;
        4)
            sudo dnf swap @gnome-desktop @kde-desktop
            sudo dnf swap fedora-release-identity-workstation fedora-release-identity-kde
            ;;
        5)
            sudo dnf install flatpak
  	    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            ;;
        6)
            sudo dnf install gimp kdenlive geany qbittorrent
            ;;
        7)
            flatpak install -y flathub com.discordapp.Discord io.kopia.KopiaUI com.spotify.Client com.valvesoftware.Steam org.telegram.desktop tv.plex.PlexDesktop com.nextcloud.desktopclient.nextcloud im.riot.Riot
            ;;
        8)
            sudo dnf install bluez
            sudo modprobe btusb
            sudo systemctl enable --now bluetooth
            ;;
        9)
            read -rp "WARNING: This will install Tailscale. Are you sure? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                sudo dnf install curl
                sudo curl -s https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
                sudo rpm --import https://pkgs.tailscale.com/stable/fedora/repo.gpg
                sudo dnf install tailscale
                sudo systemctl enable --now tailscaled
                sudo tailscale up
            else
                echo "Tailscale installation cancelled."
            fi
            ;;
        10)
            echo "WARNING: Nix installation on Fedora is experimental."
            read -rp "Do you want to proceed? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                sh <(curl -L https://nixos.org/nix/install) --daemon
            else
                echo "Nix installation cancelled."
            fi
            ;;
        11)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid selection. Please try again."
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -rp "Enter your choice: " choice
    execute_command
done
