#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl

openscad --render -D 'part=1' -o stl/trackpad_frame.stl keyboard_trackpad_tray_v5.scad
openscad --render -D 'part=2' -o stl/wrist_rest_l.stl keyboard_trackpad_tray_v5.scad
openscad --render -D 'part=3' -o stl/wrist_rest_r.stl keyboard_trackpad_tray_v5.scad
