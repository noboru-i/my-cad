#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/nitori_caesar_box.stl nitori_caesar_box.scad
