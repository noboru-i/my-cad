include <BOSL2/std.scad>
include <BOSL2/walls.scad>

wall_width = 100;
wall_height = 50;
wall_thin = 4;

wall_distance_array = [18, 18, 18, 18, 18];

extra_space = 14;

base_height = 12;

hole_radius = 6;
hole_height = 2;

//Sum the elements of a list.
function SubSum(x=0,Index=0)=x[Index]+((Index<=0)?0:SubSum(x=x,Index=Index-1));
function Sum(x)=SubSum(x=x,Index=len(x)-1);

module model () {
  wall_distance_sum = Sum(wall_distance_array);
  for (i = [0 : len(wall_distance_array)]) {
    list = [ for (a = [0 : len(wall_distance_array)]) if (a < i) wall_distance_array[a]];
    translate([-wall_width/2, sum(list), 0])
      cube([wall_width, wall_thin, wall_height]);
  }

  difference() {
    base_length = wall_distance_sum + extra_space*2;
    translate([-wall_width/2 - extra_space, -extra_space, -base_height])
      cube([wall_width + extra_space*2, base_length, base_height]);
    translate([-wall_width/2, 0, -base_height])
      cylinder(h = hole_height, r=hole_radius);
    translate([wall_width/2, 0, -base_height])
      cylinder(h = hole_height, r=hole_radius);
    translate([-wall_width/2, base_length-extra_space*2, -base_height])
      cylinder(h = hole_height, r=hole_radius);
    translate([wall_width/2, base_length-extra_space*2, -base_height])
      cylinder(h = hole_height, r=hole_radius);
  }
}

model();