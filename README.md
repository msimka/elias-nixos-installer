# ELIAS Universal NixOS Installer

A custom NixOS installer with modern hardware support, specifically designed for the ELIAS ecosystem.

## Features

- **WiFi 7 Support**: Includes MediaTek MT7925 chipset drivers for modern WiFi 6E/7 cards
- **Modern Kernel**: Uses latest kernel (6.7+) for cutting-edge hardware compatibility
- **Mission Briefing**: Helpful on-boot instructions for setup process
- **SSH Ready**: Pre-configured for key-based SSH access
- **NetworkManager**: Easy WiFi setup with `nmtui` interface
- **Essential Tools**: Includes all necessary tools for NixOS installation

## Quick Start

1. **Download the ISO**: 
   - Check the [Releases page](../../releases) for the latest build
   - Or trigger a new build using GitHub Actions

2. **Flash to USB**: 
   ```bash
   dd if=nixos-installer.iso of=/dev/sdX bs=1M status=progress
   ```

3. **Boot and Install**:
   - Boot from USB
   - Follow the Mission Briefing instructions
   - Connect to WiFi using `nmtui`
   - Proceed with standard NixOS installation

## Building Locally

This ISO is designed to be built on GitHub Actions for x86_64-linux compatibility, but you can build locally on a Linux machine:

```bash
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```

## Hardware Support

Specifically tested and optimized for:
- AMD Ryzen 9950X3D processors
- Modern WiFi 6E/7 cards (MediaTek MT7925)
- ASUS PRIME X870-P motherboards
- USB 3.0+ installation media

## ELIAS Ecosystem

This installer is part of the larger ELIAS (Enhanced Learning Intelligence & Automation System) ecosystem. Once installed, you can deploy the full ELIAS platform stack on your new NixOS system.

## Architecture

- **Base**: NixOS 24.05 minimal installation image
- **Kernel**: Latest stable with modern hardware support
- **Network**: NetworkManager + SSH for easy remote setup
- **Security**: Key-based authentication, no password login
- **UX**: Mission briefing with clear setup instructions