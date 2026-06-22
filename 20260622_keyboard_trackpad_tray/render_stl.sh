#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p stl
rm -f stl/*.stl
parts=(
  back_left
  back_right
  front_left
  front_right
)
for p in "${parts[@]}"; do
  echo "Rendering $p"
  openscad -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray.scad
done
