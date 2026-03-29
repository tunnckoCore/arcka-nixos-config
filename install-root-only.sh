#!/usr/bin/env bash

set -euo pipefail

ROOT_PARTITION="/dev/nvme0n1p2"
BOOT_PARTITION="/dev/nvme0n1p1"
HOME_PARTITION="/dev/nvme0n1p3"
FLAKE_HOST="tarckan"
REPO_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
TMP_HARDWARE="/tmp/tarckan-hardware-configuration.nix"

require_root() {
  if [[ "$(id -u)" -ne 0 ]]; then
    printf '%s\n' 'Run this script as root.' >&2
    exit 1
  fi
}

check_partition() {
  local part="$1"
  [[ -b "$part" ]] || {
    printf 'Missing block device: %s\n' "$part" >&2
    exit 1
  }
}

confirm() {
  printf '%s\n' 'About to do a root-only NixOS install with this layout:'
  printf '  boot: %s (preserve)\n' "$BOOT_PARTITION"
  printf '  root: %s (FORMAT)\n' "$ROOT_PARTITION"
  printf '  home: %s (preserve)\n' "$HOME_PARTITION"
  printf '%s' 'Type FORMAT-ROOT to continue: '
  read -r answer
  [[ "$answer" == "FORMAT-ROOT" ]] || {
    printf '%s\n' 'Aborted.' >&2
    exit 1
  }
}

mount_target() {
  umount -R /mnt 2>/dev/null || true
  mkfs.ext4 -F "$ROOT_PARTITION"
  mount "$ROOT_PARTITION" /mnt
  mkdir -p /mnt/boot /mnt/home
  mount "$BOOT_PARTITION" /mnt/boot
  mount "$HOME_PARTITION" /mnt/home
}

generate_hardware() {
  nixos-generate-config --root /mnt
  cp /mnt/etc/nixos/hardware-configuration.nix "$TMP_HARDWARE"
}

install_repo() {
  rm -rf /mnt/etc/nixos
  mkdir -p /mnt/etc
  cp -a "$REPO_DIR" /mnt/etc/nixos
  cp "$TMP_HARDWARE" /mnt/etc/nixos/hardware-configuration.nix
}

run_install() {
  nixos-install --flake "/mnt/etc/nixos#${FLAKE_HOST}"
}

post_install_note() {
  cat <<'EOF'

Install complete.

Before rebooting, set the user password:
  nixos-enter --root /mnt -c 'passwd arcka'

Then reboot:
  reboot
EOF
}

require_root
check_partition "$BOOT_PARTITION"
check_partition "$ROOT_PARTITION"
check_partition "$HOME_PARTITION"
confirm
mount_target
generate_hardware
install_repo
run_install
post_install_note
