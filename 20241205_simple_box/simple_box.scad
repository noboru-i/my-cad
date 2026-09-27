/* [モデル選択] */
variant = "standard"; // [standard:標準, small:小型]

/* [外形寸法 mm] */
width = variant == "small" ? 20 : 30;
length = variant == "small" ? 20 : 80;
height = variant == "small" ? 10 : 30;

/* [肉厚 mm] */
wall = variant == "small" ? 1 : 2;

module model() {
  difference() {
    cube([width, length, height]);
    translate([wall, wall, wall])
      cube([width - wall * 2, length - wall * 2, height - wall]);
  }
}

model();
