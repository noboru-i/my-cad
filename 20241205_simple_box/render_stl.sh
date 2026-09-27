#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -D 'variant="standard"' -o stl/simple_box.stl simple_box.scad
openscad --render -D 'variant="small"' -o stl/simple_box_small.stl simple_box.scad
