# /elias-nixos-installer/flake.nix
{
  description = "ELIAS Universal NixOS Installer with Modern Hardware Support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    {
      nixosConfigurations.installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({ config, pkgs, ... }:
            let
              # Define the package set here for clarity
              installer-packages = with pkgs; [
                networkmanager # Includes nmcli and nmtui for easy WiFi
                wpa_supplicant
                iw
                dhcpcd
                openssh
                nano
                vim
                curl
                wget
                git
                parted
              ];

              # The "Mission Briefing" Message of the Day
              mission-briefing = ''

        #######################################################################
        #                                                                     #
        #             Welcome to the ELIAS Universal Installer                #
        #                                                                     #
        #######################################################################

        You have booted into the custom NixOS installation environment.
        Kernel: ${pkgs.linuxPackages_latest.kernel.version}

        Your primary goal is to establish a network connection and then
        begin the NixOS installation on the target drive.

        --- MISSION STEPS ---

        [1] AUTHORIZE SSH ACCESS (Recommended for ease of use)
            a. On your main machine (e.g., MacBook), get your public key:
               cat ~/.ssh/id_rsa.pub
            b. In this terminal, add the key:
               mkdir -p /root/.ssh
               echo "PASTE_YOUR_PUBLIC_KEY_HERE" >> /root/.ssh/authorized_keys
               chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
            c. Find this machine's IP address:
               ip addr
            d. You can now SSH in from your main machine:
               ssh root@<IP_ADDRESS>

        [2] CONNECT TO WIFI
            a. Run the simple, text-based network manager UI:
               nmtui
            b. Select "Activate a connection", choose your network, and enter the password.
            c. Alternatively, use the command line:
               nmcli device wifi list
               nmcli device wifi connect <SSID> --ask

        [3] BEGIN INSTALLATION
            a. Identify your target drive: lsblk
            b. Partition the drive using 'parted' or 'fdisk'.
            c. Mount the partitions at /mnt.
            d. Generate a base config: nixos-generate-config --root /mnt
            e. Edit the config and then run: nixos-install

        Good luck, Architect.
              '';
            in
            {
              # --- Core Hardware Support ---
              boot.kernelPackages = pkgs.linuxPackages_latest; # Kernel 6.7+ for modern WiFi
              hardware.enableRedistributableFirmware = true;   # Includes MediaTek, Intel, etc.
              boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "mt7925e" ];
              boot.kernelModules = [ "cdc_ether" "usbnet" "rndis_host" ]; # For USB tethering
              
              # Disable ZFS to avoid broken package issues
              boot.supportedFilesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" ];

              # --- Networking ---
              networking.networkmanager.enable = true;
              networking.wireless.enable = false; # Disable legacy wireless to avoid conflicts

              # --- Security: Key-Based SSH Only ---
              services.openssh.enable = true;
              services.openssh.settings.PermitRootLogin = pkgs.lib.mkForce "prohibit-password"; # Allow root login, but only with a key

              # --- User Experience: The Mission Briefing ---
              environment.systemPackages = installer-packages;
              environment.etc."motd".text = mission-briefing;
              services.getty.autologinUser = pkgs.lib.mkForce "root";

              # --- Bootloader ---
              boot.loader.efi.canTouchEfiVariables = true;
              boot.loader.systemd-boot.enable = true;
            })
        ];
      };
    };
}