# arcka-nixos-config

Flake-based NixOS setup for `tarckan`.

What this repo currently targets:

- plain NixOS reinstall on root only
- existing `/home` kept intact
- tty login on `tty1`
- `tpm2ssh --login` after user login, before `sway`
- `sway` + `rofi-wayland`
- `librewolf`, `brave`, `alacritty`, `ghostty`, `zed`, `opencode`, `codex`
- NextDNS via `systemd-resolved`

Layout:

- `flake.nix` - flake entrypoint
- `configuration.nix` - host imports
- `hardware-configuration.nix` - hardware baseline
- `system-packages.nix` - small global package set
- `users/` - user definitions
- `desktop/` - tty/sway session wiring
- `network/` - NextDNS and related network settings
- `home/` - Home Manager modules
- `theme/` - shared Catppuccin Macchiato palette values
- `packages/tpm2ssh/` - local package source copied from the current project

## Root-only reinstall notes

Target layout:

- `/dev/nvme0n1p1` -> keep as existing EFI `/boot`
- `/dev/nvme0n1p2` -> replace with fresh NixOS root `/`
- `/dev/nvme0n1p3` -> keep intact as existing `/home`

Before clicking through Calamares or doing manual partitioning:

1. Double-check the disk is `nvme0n1`, not another removable disk.
2. Do not format `/dev/nvme0n1p3`.
3. Do not recreate the partition table.
4. Reuse the existing EFI partition instead of creating a new one.
5. If Calamares proposes wiping the whole disk, back out and switch to manual partitioning.

Manual partition intent:

- `/dev/nvme0n1p1` mounted at `/boot`, `vfat`, keep contents
- `/dev/nvme0n1p2` mounted at `/`, `ext4`, format this one only
- `/dev/nvme0n1p3` mounted at `/home`, `ext4`, no format

Minimal ISO scripted path:

```bash
sudo -i
nmtui
git clone https://github.com/tunnckoCore/arcka-nixos-config.git
cd arcka-nixos-config
./install-root-only.sh
nixos-enter --root /mnt -c 'passwd arcka'
reboot
```

After first boot into installer environment:

1. Confirm partitions with `lsblk -f`.
2. Clone this repo in the live ISO.
3. Run `./install-root-only.sh`.
4. Set the password for `arcka` with `nixos-enter --root /mnt -c 'passwd arcka'`.
5. Reboot and test tty login, `tpm2ssh --login`, Sway start, WiFi switching, and NextDNS.

Things to be careful about:

- The install script regenerates `hardware-configuration.nix` from the mounted target and drops it into the repo automatically.
- The install script does a preflight first: checks UEFI mode, verifies network, test-mounts `/boot` and `/home` read-only, and only formats root after those pass.
- Browser policies and CLI packages should work only after the first rebuild, not inside the live ISO.
- `tpm2ssh` setup itself is not automated here; only the package and login hook are wired.
- If tty login succeeds but `tpm2ssh --login` fails, the shell exits and you should get the tty login prompt again.
