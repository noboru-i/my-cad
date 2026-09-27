#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/switch_lite_holder.stl switch_lite_holder.scad
