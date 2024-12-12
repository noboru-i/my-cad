include <BOSL2/std.scad>
include <BOSL2/walls.scad>

wall_count = 5;

wall_width = 130;
wall_height = 60;
wall_thin = 4;

wall_distance = 30;

module model () {
  for (i = [0 : wall_count - 1]) {
    translate([0, i * wall_distance, -2])
      rotate([90, 0, 0])
        hex_panel([wall_width, wall_height, wall_thin], 2, 10, frame = 2, anchor = [0,-1,0]);
  }

  base_height = 12;
  base_length = wall_distance * wall_count;
  translate([-wall_width/2, -wall_distance/2, -base_height])
    cube([wall_width, base_length, 12]);
}

model();