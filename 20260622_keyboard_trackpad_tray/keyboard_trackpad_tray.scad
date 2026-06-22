include <BOSL2/std.scad>

// PLA keyboard + trackpad tray inspired by Crispy Backboard PRO.
// Designed as A1 mini friendly split parts: every printable part is under 180 x 180 x 180 mm.
// Source dimensions checked from Apple Store tech specs, 2026-06-22:
// - Magic Keyboard (USB-C): 278.9 x 114.9 x 4.1-10.9 mm
// - Magic Trackpad (USB-C): 160.0 x 114.9 x 4.9-10.9 mm
// Render one part at a time with:
//   openscad -D 'part="back_left"' -o stl/back_left.stl keyboard_trackpad_tray.scad

part = "full"; // full, back_left, back_right, front_left, front_right,
               // connector_x_back, connector_x_front, connector_y_left, connector_y_right

keyboard_width = 278.9;
keyboard_depth = 114.9;
trackpad_width = 160.0;
trackpad_depth = 114.9;

fit_clearance = 0.8;
tray_width = 292;
tray_depth = 218;
base_thickness = 4;
corner_radius = 8;

keyboard_y = 45;
trackpad_y = -47;

stop_height = 5.5;
stop_width = 4;
front_lip_height = 3.2;
front_lip_width = 4;

trackpad_pocket_depth = 1.0;
trackpad_corner_radius = 11;
trackpad_cable_gap = 22;
trackpad_side_stop_length = 44;

wrist_rest_width = 58;
wrist_rest_depth = 88;
wrist_rest_height = 4;
wrist_rest_rounding = 12;

rib_width = 5;
rib_height = 3;
rib_spacing = 32;

m3_clearance_radius = 1.8;
connector_plate_thickness = 3;
connector_plate_rounding = 3;
connector_x_size = [64, 20, connector_plate_thickness];
connector_y_size = [20, 64, connector_plate_thickness];
connector_hole_spacing = 36;

split_gap = 0.35;
max_part_xy = 178;

$fn = 48;

module rounded_cube(size, r) {
  x = size[0];
  y = size[1];
  z = size[2];
  hull() {
    for (px = [-x / 2 + r, x / 2 - r], py = [-y / 2 + r, y / 2 - r]) {
      translate([px, py, 0])
        cylinder(h = z, r = r);
    }
  }
}

module through_hole(h = 30, r = m3_clearance_radius) {
  translate([0, 0, -h / 2])
    cylinder(h = h, r = r);
}

module keyboard_stops() {
  outer_w = keyboard_width + fit_clearance * 2;
  outer_d = keyboard_depth + fit_clearance * 2;

  translate([0, keyboard_y + outer_d / 2 + stop_width / 2, base_thickness])
    rounded_cube([outer_w + stop_width * 2, stop_width, stop_height], 1.4);

  for (x = [-outer_w / 2 - stop_width / 2, outer_w / 2 + stop_width / 2]) {
    translate([x, keyboard_y, base_thickness])
      rounded_cube([stop_width, outer_d, stop_height], 1.4);
  }

  translate([0, keyboard_y - outer_d / 2 - front_lip_width / 2, base_thickness])
    rounded_cube([outer_w * 0.76, front_lip_width, front_lip_height], 1.4);
}

module trackpad_recess() {
  recess_w = trackpad_width + fit_clearance * 2;
  recess_d = trackpad_depth + fit_clearance * 2;

  translate([0, trackpad_y, base_thickness - trackpad_pocket_depth])
    rounded_cube([recess_w, recess_d, trackpad_pocket_depth + 0.3], trackpad_corner_radius);

  // Front USB-C cable / finger access notch.
  translate([0, trackpad_y - recess_d / 2 - 2, base_thickness - trackpad_pocket_depth])
    cube([trackpad_cable_gap, 12, trackpad_pocket_depth + 0.4], center = true);
}

module trackpad_stops() {
  outer_w = trackpad_width + fit_clearance * 2;
  outer_d = trackpad_depth + fit_clearance * 2;

  for (x = [-outer_w / 2 - stop_width / 2, outer_w / 2 + stop_width / 2]) {
    translate([x, trackpad_y, base_thickness])
      rounded_cube([stop_width, trackpad_side_stop_length, stop_height], 1.4);
  }

  translate([0, trackpad_y + outer_d / 2 + stop_width / 2, base_thickness])
    rounded_cube([outer_w * 0.70, stop_width, stop_height], 1.4);
}

module wrist_rests() {
  rest_y = -tray_depth / 2 + wrist_rest_depth / 2 + 7;
  rest_x = trackpad_width / 2 + (tray_width / 2 - trackpad_width / 2) / 2;

  for (x = [-rest_x, rest_x]) {
    translate([x, rest_y, base_thickness])
      rounded_cube([wrist_rest_width, wrist_rest_depth, wrist_rest_height], wrist_rest_rounding);
  }
}

module underside_ribs() {
  for (x = [-112:rib_spacing:112]) {
    translate([x, 0, -rib_height])
      rounded_cube([rib_width, tray_depth - 24, rib_height], 1.8);
  }

  for (y = [-78:rib_spacing:78]) {
    translate([0, y, -rib_height])
      rounded_cube([tray_width - 24, rib_width, rib_height], 1.8);
  }
}

module connector_holes_in_tray() {
  // Holes for two plates crossing the vertical split.
  for (y = [-82, 82], x = [-connector_hole_spacing / 2, connector_hole_spacing / 2]) {
    translate([x, y, base_thickness / 2])
      through_hole();
  }

  // Holes for two plates crossing the horizontal split.
  for (x = [-102, 102], y = [-connector_hole_spacing / 2, connector_hole_spacing / 2]) {
    translate([x, y, base_thickness / 2])
      through_hole();
  }
}

module full_tray() {
  difference() {
    union() {
      rounded_cube([tray_width, tray_depth, base_thickness], corner_radius);
      underside_ribs();
      keyboard_stops();
      trackpad_stops();
      wrist_rests();
    }

    trackpad_recess();
    connector_holes_in_tray();

    // Small clearance gaps on the split planes so separately printed parts assemble cleanly.
    translate([0, 0, base_thickness / 2])
      cube([split_gap, tray_depth + 2, 40], center = true);
    translate([0, 0, base_thickness / 2])
      cube([tray_width + 2, split_gap, 40], center = true);
  }
}

module quadrant(xside, yside) {
  xcenter = xside * tray_width / 4;
  ycenter = yside * tray_depth / 4;
  intersection() {
    full_tray();
    translate([xcenter, ycenter, 0])
      cube([tray_width / 2 + 2, tray_depth / 2 + 2, 60], center = true);
  }
}

module connector_x() {
  difference() {
    rounded_cube(connector_x_size, connector_plate_rounding);
    for (x = [-connector_hole_spacing / 2, connector_hole_spacing / 2]) {
      translate([x, 0, connector_plate_thickness / 2])
        through_hole(h = 20);
    }
  }
}

module connector_y() {
  difference() {
    rounded_cube(connector_y_size, connector_plate_rounding);
    for (y = [-connector_hole_spacing / 2, connector_hole_spacing / 2]) {
      translate([0, y, connector_plate_thickness / 2])
        through_hole(h = 20);
    }
  }
}

module selected_part() {
  if (part == "full") {
    full_tray();
  } else if (part == "back_left") {
    quadrant(-1, 1);
  } else if (part == "back_right") {
    quadrant(1, 1);
  } else if (part == "front_left") {
    quadrant(-1, -1);
  } else if (part == "front_right") {
    quadrant(1, -1);
  } else if (part == "connector_x_back") {
    connector_x();
  } else if (part == "connector_x_front") {
    connector_x();
  } else if (part == "connector_y_left") {
    connector_y();
  } else if (part == "connector_y_right") {
    connector_y();
  } else {
    full_tray();
  }
}

module model() {
  selected_part();
}

model();
