#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl

openscad --render -D 'part=5' -o stl/base_front_left.stl keyboard_trackpad_tray_v4.scad
openscad --render -D 'part=6' -o stl/base_front_right.stl keyboard_trackpad_tray_v4.scad
openscad --render -D 'part=7' -o stl/base_rear_left.stl keyboard_trackpad_tray_v4.scad
openscad --render -D 'part=8' -o stl/base_rear_right.stl keyboard_trackpad_tray_v4.scad
openscad --render -D 'part=2' -o stl/wrist_rest_l.stl keyboard_trackpad_tray_v4.scad
openscad --render -D 'part=3' -o stl/wrist_rest_r.stl keyboard_trackpad_tray_v4.scad
