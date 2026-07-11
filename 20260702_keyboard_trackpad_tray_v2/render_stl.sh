#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
for p in plate1 plate2 plate3; do
  openscad --render -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray_v2.scad
done
