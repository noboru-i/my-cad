#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
for p in plate1 plate2 plate3 plate4; do
  openscad --render -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray_v3.scad
done
# 傾斜違いのライザー（T8R/T8L など）。riser_h を変えて必要な高さだけ出力する
for h in 8; do
  for p in riser_r riser_l; do
    openscad --render -D "part=\"$p\"" -D "riser_h=$h" \
      -o "stl/${p}_h${h}.stl" keyboard_trackpad_tray_v3.scad
  done
done
