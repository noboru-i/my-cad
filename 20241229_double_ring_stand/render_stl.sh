#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/double_ring_stand.stl double_ring_stand.scad
