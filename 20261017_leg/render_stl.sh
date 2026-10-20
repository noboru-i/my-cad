#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
mkdir -p stl
openscad --backend=manifold -D 'part="leg"' -o stl/leg.stl leg.scad
openscad --backend=manifold -D 'part="assembled"' -o stl/assembled.stl leg.scad
openscad --backend=manifold --enable=lazy-union -D 'part="pair"' -o leg.3mf leg.scad  # A1 mini 1プレート分 (足ごとに別オブジェクト)
