#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/laptop_tablet_stand.stl laptop_tablet_stand.scad
