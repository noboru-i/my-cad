#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/tcg_marker.stl tcg_marker.scad
