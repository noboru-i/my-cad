include <BOSL2/std.scad>
include <BOSL2/walls.scad>

wall_width = 100;          // wall length along X axis
wall_height = 50;          // wall height along Z axis
wall_thin = 4;             // wall thickness at the top
wall_thin_base = 8;        // wall thickness at the base (wider for strength)
wall_base_height = 4;      // height of the triangular base section

wall_distance_array = [18, 18, 18, 18, 18]; // spacing between each wall (Y axis)

extra_space = 14;          // margin beyond the outermost walls on the base plate

base_height = 8;           // thickness of the base plate

hole_radius = 6;           // radius of screw holes on the base plate
hole_height = 2;           // depth of screw holes

$fn = 32;

// Wall with a triangular base for improved root strength.
module tapered_wall() {
  taper_extra = (wall_thin_base - wall_thin) / 2;
  hull() {
    translate([0, -taper_extra, 0])
      cube([wall_width, wall_thin_base, 0.001]);
    translate([0, 0, wall_base_height])
      cube([wall_width, wall_thin, 0.001]);
  }
  translate([0, 0, wall_base_height])
    cube([wall_width, wall_thin, wall_height - wall_base_height]);
}

module model() {
  wall_distance_sum = sum(wall_distance_array);
  base_length = wall_distance_sum + extra_space * 2;

  for (i = [0:len(wall_distance_array)]) {
    list = [for (a = [0:len(wall_distance_array)]) if (a < i) wall_distance_array[a]];
    translate([-wall_width / 2, sum(list), 0])
      tapered_wall();
  }

  difference() {
    translate([-wall_width / 2 - extra_space, -extra_space, -base_height])
      cube([wall_width + extra_space * 2, base_length, base_height]);
    for (x = [-wall_width / 2, wall_width / 2], y = [0, wall_distance_sum])
      translate([x, y, -base_height])
        cylinder(h=hole_height, r=hole_radius);
  }
}

model();
