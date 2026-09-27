#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/water_plant_holder.stl water_plant_holder.scad
