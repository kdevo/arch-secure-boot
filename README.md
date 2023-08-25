# UEFI Secure Boot for Arch Linux + Recovery via BTRFS snapshots 


This is a fork of a @maximbaz's highly opinionated setup that provides minimal Secure Boot for Arch Linux, plus recovery tools.
Thanks to @maximbaz for the great approach that doesn't rely on a heavy bootloader.

This repo could be interesting for you if...
- you're using the BTRFS filesystem in combination with snapper
- you want to enable Secure Boot e.g. to avoid evil-maid attacks

## Differences of this fork

This fork...
- might be even more opinionated (uses sbctl for signing, mkinitcpio for UKI)
- transfers responsibility to programs that have one job at which they are good at
- should only be used if you understand the content of every single file and action
- is not tested thouroughly right now (use at own risk)


## Background

While I previously used grub-btrfs for recovery, I decided against Grub, as it turned out to be particularly buggy in combination with TPM and Secure Boot (see https://github.com/Antynea/grub-btrfs/issues/190). Summarizing the issue, it causes booting a snapshot to fail if a certain amount of text is displayed in a submenu and the TPM module is enabled (which is needed for Secure Boot).

This bug also shows how complex a fully-fledged bootloader such as Grub is and all the disadvantages that come with this complexity. I haven't looked at Grub's source code to understand what could cause the issue. Instead I invested my time to switch to the approach in this repository, after reading [@maximbaz's comment](https://github.com/Antynea/grub-btrfs/issues/92#issuecomment-705640920). 

## Requirements

- edk2-shell
- sbctl
- efibootmgr

```sh
sudo pacman -S edk2-shell sbctl efibootmgr
```

## Configuration

See the available configuration options in the top of the script.

Add your overrides to `/etc/arch-secure-boot/config`.

## Commands

- `arch-secure-boot generate-keys` generates new keys for Secure Boot
- `arch-secure-boot enroll-keys` adds them to your UEFI
- `arch-secure-boot generate-efi` creates recovery UKIs signed with Secure Boot keys
- `arch-secure-boot add-efi` adds UEFI entry for the main Secure Boot image
- `arch-secure-boot generate-snapshots` generates a list of btrfs snapshots for recovery
- `arch-secure-boot initial-setup` runs all the steps in the proper order with manual intervention

## Initial setup

- BIOS: Set admin password, disable Secure Boot, delete all Secure Boot keys
- Generate and enroll keys
- Generate EFI images and add the main one (only!) to UEFI
- BIOS: Enable Secure Boot
- BIOS: Lock boot order and settings

## Recovery instructions

- BIOS: use admin password to boot into `efi-shell` image
- Recovery will automatically start (via `startup.nsh`)
- Follow instructions on screen, remember snapshot-id (first number in each line)
- Inspect recovery script using `edit recovery.nsh`
- Run the script using `recovery.nsh <snapshot-id>`
- Optional (depends on BIOS): Once recovered, remove `efi-shell` entry from UEFI

## Related links:

- Original: https://github.com/maximbaz/arch-secure-boot
- https://github.com/gdamjan/secure-boot
- https://github.com/andreyv/sbupdate
