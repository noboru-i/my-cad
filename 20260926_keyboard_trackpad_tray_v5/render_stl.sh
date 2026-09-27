#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl

openscad --render -D 'part=1' -o stl/trackpad_frame.stl keyboard_trackpad_tray_v5.scad
