#!/usr/bin/env bash

set -euo pipefail

# This is to install the cargo binaries in the system, lot of the times, Nix packages have outdated versions
# Installing directly from cargo is the best way to get the latest version of the binaries

input="cargo.list"

while read p; do
  echo "⚙️ Installing $p"
  cargo install $p
  echo "✅ $p"
  echo "-------------------"
done <cargo.list
