#!/bin/bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --render -o stl/calendar_holder.stl model.scad
