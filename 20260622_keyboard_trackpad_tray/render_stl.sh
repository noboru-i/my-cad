#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p stl
parts=(
  back_left
  back_right
  front_left
  front_right
  connector_x_back
  connector_x_front
  connector_y_left
  connector_y_right
)
for p in "${parts[@]}"; do
  echo "Rendering $p"
  openscad -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray.scad
done
