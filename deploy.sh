#!/bin/sh

SYSTEM="x86_64-linux"
KEXEC_TAG="kexec-installer-nixos-unstable"
KEXEC_IMAGE_OUTPUT=$(nix build --print-out-paths "github:nix-community/nixos-images#packages.$SYSTEM.$KEXEC_TAG")

USER="root"
HOST="170.187.156.72"

nix run "github:numtide/nixos-anywhere" -- \
  --kexec "$KEXEC_IMAGE_OUTPUT/$KEXEC_TAG-$SYSTEM.tar.gz" \
  --flake ".#linode" \
  "root@$HOST"
