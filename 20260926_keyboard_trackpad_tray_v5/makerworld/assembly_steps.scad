// Assembly guide illustrations. Each step shows the parts already in place in
// grey and the part to add in orange, lifted above its position. The tray is
// put together first (steps 1-4), then lowered over the trackpad (step 5).
// BOSL2's global $ variables are only set by include, not by use.
include <../BOSL2/std.scad>
use <../keyboard_trackpad_tray_v5.scad>

step = 1;   // [1:Frame, 2:KeyboardBase_L, 3:KeyboardBase_R, 4:WristRests, 5:OverTrackpad, 6:Keyboard]
lift = 45;  // How far the new part floats above its position

frame_color = "#5c5c63";
base_color = "#46464c";
rest_color = "#78787f";
new_color = "#ff9f1c";
device_color = "#b9cde3";
cable_color = "#8fa9c4";

module arrow(pos, len = 30) {
  color("#e4572e") translate(pos) {
    translate([0, 0, 10]) cylinder(h = len, r = 2.2, $fn = 24);
    cylinder(h = 10, r1 = 0, r2 = 6, $fn = 24);
  }
}

// Wedge in place of trackpad_dummy(), whose BOSL2 shapes ignore color() here
module trackpad() {
  w = 160; d = 114.9; hf = 4.9; hr = 10.9;
  color(device_color) polyhedron(
    points = [[0, 0, 0], [w, 0, 0], [w, d, 0], [0, d, 0],
              [0, 0, hf], [w, 0, hf], [w, d, hr], [0, d, hr]],
    faces = [[0, 1, 2, 3], [4, 7, 6, 5], [0, 4, 5, 1], [1, 5, 6, 2], [2, 6, 7, 3], [3, 7, 4, 0]]);
}

// Trackpad cable: from the rear port, straight back under the keyboard base
module cable() {
  color(cable_color) {
    translate([80, 114.9, 3]) rotate([-90, 0, 0]) cylinder(h = 140, r = 1.8, $fn = 16);
    translate([80 - 4, 112, 0.5]) cube([8, 8, 5]);
  }
}

// Step 5 lifts the whole tray, so every tray part is "new" there.
module part_at(s, active, placed_color) {
  if (active || step == 5) {
    translate([0, 0, lift]) color(new_color) children();
  } else if (step > s) {
    color(placed_color) children();
  }
}

module model() {
  if (step >= 5) {
    trackpad();
    cable();
  }
  part_at(1, step == 1, frame_color) trackpad_frame();
  part_at(2, step == 2, base_color) keyboard_base_half(-1);
  part_at(3, step == 3, base_color) keyboard_base_half(1);
  part_at(4, step == 4, rest_color) {
    wrist_rest(-1);
    wrist_rest(1);
  }
  if (step == 6) translate([0, 0, lift]) color("#d4d4d9") keyboard_dummy();

  if (step == 1) arrow([80, 57, lift + 15]);
  if (step == 2) arrow([20, 165, lift + 28]);
  if (step == 3) arrow([165, 165, lift + 28]);
  if (step == 4) {
    arrow([-35, 50, lift + 20]);
    arrow([195, 50, lift + 20]);
  }
  if (step == 5) {
    arrow([-35, 50, lift + 20]);
    arrow([195, 50, lift + 20]);
  }
  if (step == 6) arrow([80, 165, lift + 25]);
}

model();
