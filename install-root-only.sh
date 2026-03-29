#!/usr/bin/env bash

set -euo pipefail

ROOT_PARTITION="/dev/nvme0n1p2"
BOOT_PARTITION="/dev/nvme0n1p1"
HOME_PARTITION="/dev/nvme0n1p3"
FLAKE_HOST="tarckan"
REPO_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
TMP_HARDWARE="/tmp/tarckan-hardware-configuration.nix"
BOOT_TEST_MOUNT="/tmp/tarckan-boot-check"
HOME_TEST_MOUNT="/tmp/tarckan-home-check"

cleanup() {
  umount "$BOOT_TEST_MOUNT" 2>/dev/null || true
  umount "$HOME_TEST_MOUNT" 2>/dev/null || true
  rmdir "$BOOT_TEST_MOUNT" 2>/dev/null || true
  rmdir "$HOME_TEST_MOUNT" 2>/dev/null || true
}

trap cleanup EXIT

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

check_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  }
}

check_uefi() {
  [[ -d /sys/firmware/efi && -d /sys/firmware/efi/efivars ]] || {
    printf '%s\n' 'This installer session is not booted in UEFI mode.' >&2
    printf '%s\n' 'Reboot, open the boot menu, and select the USB entry that explicitly says UEFI.' >&2
    exit 1
  }
}

check_repo() {
  [[ -f "$REPO_DIR/flake.nix" ]] || {
    printf 'Repo not found or incomplete: %s\n' "$REPO_DIR" >&2
    exit 1
  }
}

preflight_mount_check() {
  mkdir -p "$BOOT_TEST_MOUNT" "$HOME_TEST_MOUNT"

  mount -o ro "$BOOT_PARTITION" "$BOOT_TEST_MOUNT"
  mount -o ro "$HOME_PARTITION" "$HOME_TEST_MOUNT"

  if [[ ! -d "$BOOT_TEST_MOUNT/EFI" && ! -d "$BOOT_TEST_MOUNT/loader" ]]; then
    printf 'Boot partition mounted but does not look like an EFI boot partition: %s\n' "$BOOT_PARTITION" >&2
    exit 1
  fi

  if [[ -z "$(ls -A "$HOME_TEST_MOUNT" 2>/dev/null)" ]]; then
    printf 'Home partition mounted but appears empty: %s\n' "$HOME_PARTITION" >&2
    exit 1
  fi

  umount "$BOOT_TEST_MOUNT"
  umount "$HOME_TEST_MOUNT"
}

check_network() {
  ping -c 1 -W 3 github.com >/dev/null 2>&1 || {
    printf '%s\n' 'Network check failed. Connect with nmtui first.' >&2
    exit 1
  }
}

show_preflight() {
  printf '%s\n' 'Preflight checks passed:'
  printf '  repo: %s\n' "$REPO_DIR"
  printf '  boot: %s\n' "$BOOT_PARTITION"
  printf '  root: %s\n' "$ROOT_PARTITION"
  printf '  home: %s\n' "$HOME_PARTITION"
  printf '%s\n' '  boot/home mount read checks: OK'
  printf '%s\n' '  network to github.com: OK'
}

confirm() {
  printf '%s\n' 'About to do a root-only NixOS install with this layout:'
  printf '  boot: %s (preserve)\n' "$BOOT_PARTITION"
  printf '  root: %s (FORMAT)\n' "$ROOT_PARTITION"
  printf '  home: %s (preserve)\n' "$HOME_PARTITION"
  printf '%s\n' 'The destructive step starts only after the checks above have passed.'
  printf '%s' 'Type the exact root device (/dev/nvme0n1p2) to continue: '
  read -r answer
  [[ "$answer" == "$ROOT_PARTITION" ]] || {
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
check_command git
check_command mount
check_command mkfs.ext4
check_command nixos-generate-config
check_command nixos-install
check_partition "$BOOT_PARTITION"
check_partition "$ROOT_PARTITION"
check_partition "$HOME_PARTITION"
check_uefi
check_repo
check_network
preflight_mount_check
show_preflight
confirm
mount_target
generate_hardware
install_repo
run_install
post_install_note
