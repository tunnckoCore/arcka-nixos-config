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
- `mounts.nix` - root, boot, home mounts
- `system-packages.nix` - small global package set
- `users/` - user definitions
- `desktop/` - tty/sway session wiring
- `network/` - NextDNS and related network settings
- `home/` - Home Manager modules
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

After first boot into installer environment:

1. Confirm partitions with `lsblk -f`.
2. Clone or copy this repo locally.
3. Install with the generated root mounted the same way as above.
4. Set a temporary password for `arcka` during install or immediately after first boot.
5. Run `sudo nixos-rebuild switch --flake .#tarckan`.
6. Verify tty login, `tpm2ssh --login`, Sway start, WiFi switching, and NextDNS.

Things to be careful about:

- `mounts.nix` currently uses `/dev/nvme0n1p1/2/3`, not UUIDs.
- If the installer generates a different `hardware-configuration.nix`, merge it instead of blindly replacing this repo's version.
- Browser policies and CLI packages should work only after the first rebuild, not inside the live ISO.
- `tpm2ssh` setup itself is not automated here; only the package and login hook are wired.
- If tty login succeeds but `tpm2ssh --login` fails, the shell exits and you should get the tty login prompt again.

Notes:

- `helium`, `zen`, `crush`, and `xfce4-terminal` are intentionally not included yet.
- `tpm2ssh` is wired in with its current interactive `--login` flow.
- `mounts.nix` currently uses device paths for this laptop on purpose.
