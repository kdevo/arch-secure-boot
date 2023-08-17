# UEFI Secure Boot for Arch Linux via sbctl and mkinitcpio UKI + btrfs snapshot recovery

Fork of a @maximbaz's highly opinionated setup that provides minimal Secure Boot for Arch Linux, and a few recovery tools.
Thanks to @maximbaz for the great approach that doesn't rely on a heavy bootloader.

This fork...
- might be even more opinionated (uses sbctl for signing, mkinitcpio for UKI)
  - Goal: Transfer responsibility to programs that know what they are doing
- might only work for specific setups (added instructions in `arch-secure-boot initial-setup`)
- should only be used if you understand the content of every single file and action
- is not tested thouroughly right now (use at own risk)


## Needed packages

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
