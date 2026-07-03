// Magic Keyboard + Magic Trackpad tray v2 for Bambu Lab A1 mini.
// Egg-crate lattice: every part is a 3 mm-thick 2D profile printed flat,
// assembled with cross-lap slots, dovetail splices and through tenons.
// Two-level deck: the keyboard deck (h2) overhangs the trackpad rear.
// All parts fit on 2 plates (see part="plate1"/"plate2").
//   openscad -D 'part="plate1"' -o stl/plate1.stl keyboard_trackpad_tray_v2.scad

part = "assembly"; // assembly, plate1, plate2

keyboard_width = 278.9;
keyboard_depth = 114.9;
keyboard_front_h = 4.1;
keyboard_rear_h = 10.9;
trackpad_width = 160.0;
trackpad_depth = 114.9;
trackpad_front_h = 4.9;
trackpad_rear_h = 10.9;
fit_clearance = 0.8;

keyboard_y = 45;
trackpad_y = -47;

rib_t = 3;
h1 = 10;                      // trackpad support level
h2 = h1 + trackpad_rear_h + 1.7; // keyboard support level (22.6)
stop_h = 4;
lip_h = 3;
float_gap = 0.4;              // inner members hover above the desk
slot_split = 5;               // z plane where top/bottom slots meet
slot_clearance = 0.25;
splice_clearance = 0.15;
tenon_clearance = 0.2;

rib_y0 = -108;
rib_y1 = 108;
rail_x0 = -145.5;
rail_x1 = 145.5;
rail_ys = [-106.5, -45, 55, 106]; // front, tpmid, mid, rear
rib_xs = [-141.75, -83.1, 0, 83.1, 141.75];
stub_xs = [-45, 45];
stub_y1 = -30;

rib_splice_y = -35;
rail_splice_front = 15;       // front + tpmid rails
rail_splice_rear = -25;       // mid + rear rails

arch_x = 25;
arch_w = 14;
arch_h = 6.5;
pad_xs = [-130, -45, 45, 130];
pad_w = 14;

wrist_ledge = h1 + 1.9;       // 11.9, wrist plate rests here
wrist_top = wrist_ledge + rib_t; // 14.9, flush with trackpad front
plate_x0 = 86;
plate_x1 = 145;
plate_y0 = -108.5;
plate_y1 = -28;
tenon_ys = [-95, -60];        // through tenons on the outer ribs
tenon_len = 12;

kb_half = keyboard_width / 2 + fit_clearance;
tp_half = trackpad_width / 2 + fit_clearance;
kb_front = keyboard_y - keyboard_depth / 2 - fit_clearance;
kb_rear = keyboard_y + keyboard_depth / 2 + fit_clearance;
tp_rear = trackpad_y + trackpad_depth / 2 + fit_clearance;

$fn = 48;

// ---- 2D helpers (profiles live in a (u, v) plane, v = height) ----

module top_band(u1, u2, v_top, v_bot = float_gap) {
  translate([u1, v_bot])
    square([u2 - u1, v_top - v_bot]);
}

module bottom_slot(u) {
  translate([u - (rib_t + slot_clearance) / 2, -1])
    square([rib_t + slot_clearance, slot_split + 1]);
}

module top_slot(u) {
  translate([u - (rib_t + slot_clearance) / 2, slot_split])
    square([rib_t + slot_clearance, 100]);
}

module arch(u) {
  translate([u - arch_w / 2, -1])
    square([arch_w, arch_h + 1]);
}

module desk_pads() {
  for (x = pad_xs)
    translate([x - pad_w / 2, 0])
      square([pad_w, 1]);
}

module dovetail() {
  polygon([[-0.1, 2.5], [6, 1], [6, 9], [-0.1, 7.5]]);
}

// keep u < us, grow a dovetail tab past the joint line
module splice_lo(us) {
  intersection() {
    children();
    translate([us - 1000, -500])
      square([1000, 1500]);
  }
  translate([us, 0])
    dovetail();
}

// keep u > us, cut the matching socket
module splice_hi(us) {
  difference() {
    intersection() {
      children();
      translate([us + 0.1, -500])
        square([1000, 1500]);
    }
    translate([us, 0])
      offset(delta = splice_clearance)
        dovetail();
  }
}

// ---- Y rib profiles, u = y ----

module outer_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, rib_y1, wrist_ledge);
      top_band(-19, -14.5, h2 + lip_h);      // keyboard front lip tab
      top_band(-14.5, rib_y1, h2 + stop_h);  // keyboard side + rear stop
      for (y = tenon_ys)
        top_band(y - tenon_len / 2, y + tenon_len / 2, wrist_top); // wrist plate tenons
    }
    for (y = rail_ys)
      bottom_slot(y);
  }
}

module stop_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, tp_rear, h1 + stop_h); // trackpad side stop wall
      top_band(-19, -14.5, h2 + lip_h);       // keyboard front lip tab
      top_band(tp_rear, rib_y1, h2);          // keyboard support
      top_band(104.5, rib_y1, h2 + stop_h);   // keyboard rear stop tab
    }
    for (y = rail_ys)
      bottom_slot(y);
  }
}

module center_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, 33, h1);   // stays low through the trackpad plug bay
      top_band(33, rib_y1, h2);   // keyboard support
    }
    for (y = rail_ys)
      bottom_slot(y);
  }
}

module stub_rib_profile() {
  difference() {
    top_band(rib_y0, stub_y1, h1); // extra trackpad support at x = +-45
    bottom_slot(rail_ys[0]);
    bottom_slot(rail_ys[1]);
  }
}

// ---- X rail profiles, u = x ----

module front_rail_profile() {
  difference() {
    union() {
      top_band(rail_x0, rail_x1, wrist_ledge);
      top_band(-tp_half, tp_half, h1 + lip_h); // trackpad front lip
      desk_pads();
    }
    for (x = concat(rib_xs, stub_xs))
      top_slot(x);
  }
}

module tpmid_rail_profile() {
  difference() {
    top_band(rail_x0, rail_x1, wrist_ledge); // h1 support in the middle is lower
    top_band(-tp_half, tp_half, wrist_ledge + 1, h1); // trim center down to h1
    for (x = concat(rib_xs, stub_xs))
      top_slot(x);
  }
}

module mid_rail_profile() {
  difference() {
    top_band(rail_x0, rail_x1, h1);
    arch(arch_x);
    for (x = rib_xs)
      top_slot(x);
  }
}

module rear_rail_profile() {
  difference() {
    union() {
      top_band(rail_x0, rail_x1, h1);
      desk_pads();
    }
    arch(arch_x);
    for (x = rib_xs)
      top_slot(x);
  }
}

// ---- wrist plate, drawn in tray (x, y) coordinates, right side ----

module wrist_plate_2d() {
  difference() {
    offset(r = 3) offset(delta = -3)
      translate([plate_x0, plate_y0])
        square([plate_x1 - plate_x0, plate_y1 - plate_y0]);
    for (y = tenon_ys)
      translate([rib_xs[4] - (rib_t + tenon_clearance * 2) / 2, y - tenon_len / 2 - tenon_clearance])
        square([rib_t + tenon_clearance * 2, tenon_len + tenon_clearance * 2]);
  }
}

// ---- printable pieces (2D) ----

module piece_2d(name) {
  if (name == "outer_front") splice_lo(rib_splice_y) outer_rib_profile();
  else if (name == "outer_rear") splice_hi(rib_splice_y) outer_rib_profile();
  else if (name == "stop_front") splice_lo(rib_splice_y) stop_rib_profile();
  else if (name == "stop_rear") splice_hi(rib_splice_y) stop_rib_profile();
  else if (name == "center_front") splice_lo(rib_splice_y) center_rib_profile();
  else if (name == "center_rear") splice_hi(rib_splice_y) center_rib_profile();
  else if (name == "stub") stub_rib_profile();
  else if (name == "front_rail_l") splice_lo(rail_splice_front) front_rail_profile();
  else if (name == "front_rail_r") splice_hi(rail_splice_front) front_rail_profile();
  else if (name == "tpmid_rail_l") splice_lo(rail_splice_front) tpmid_rail_profile();
  else if (name == "tpmid_rail_r") splice_hi(rail_splice_front) tpmid_rail_profile();
  else if (name == "mid_rail_l") splice_lo(rail_splice_rear) mid_rail_profile();
  else if (name == "mid_rail_r") splice_hi(rail_splice_rear) mid_rail_profile();
  else if (name == "rear_rail_l") splice_lo(rail_splice_rear) rear_rail_profile();
  else if (name == "rear_rail_r") splice_hi(rail_splice_rear) rear_rail_profile();
  else if (name == "wrist_r") wrist_plate_2d();
  else if (name == "wrist_l") mirror([1, 0]) wrist_plate_2d();
}

// ---- assembly ----

module place_y_rib(x) {
  translate([x - rib_t / 2, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(rib_t)
        children();
}

module place_x_rail(y) {
  translate([0, y + rib_t / 2, 0])
    rotate([90, 0, 0])
      linear_extrude(rib_t)
        children();
}

module device_wedge(w, d, front_h, rear_h) {
  translate([-w / 2, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(w)
        polygon([[-d / 2, 0], [d / 2, 0], [d / 2, rear_h], [-d / 2, front_h]]);
}

module assembly() {
  for (x = [rib_xs[0], rib_xs[4]]) {
    place_y_rib(x) piece_2d("outer_front");
    place_y_rib(x) piece_2d("outer_rear");
  }
  for (x = [rib_xs[1], rib_xs[3]]) {
    place_y_rib(x) piece_2d("stop_front");
    place_y_rib(x) piece_2d("stop_rear");
  }
  place_y_rib(0) piece_2d("center_front");
  place_y_rib(0) piece_2d("center_rear");
  for (x = stub_xs)
    place_y_rib(x) piece_2d("stub");

  place_x_rail(rail_ys[0]) piece_2d("front_rail_l");
  place_x_rail(rail_ys[0]) piece_2d("front_rail_r");
  place_x_rail(rail_ys[1]) piece_2d("tpmid_rail_l");
  place_x_rail(rail_ys[1]) piece_2d("tpmid_rail_r");
  place_x_rail(rail_ys[2]) piece_2d("mid_rail_l");
  place_x_rail(rail_ys[2]) piece_2d("mid_rail_r");
  place_x_rail(rail_ys[3]) piece_2d("rear_rail_l");
  place_x_rail(rail_ys[3]) piece_2d("rear_rail_r");

  translate([0, 0, wrist_ledge])
    linear_extrude(rib_t) {
      piece_2d("wrist_r");
      piece_2d("wrist_l");
    }

  %devices();
}

module devices() {
  translate([0, keyboard_y, h2])
    device_wedge(keyboard_width, keyboard_depth, keyboard_front_h, keyboard_rear_h);
  translate([0, trackpad_y, h1])
    device_wedge(trackpad_width, trackpad_depth, trackpad_front_h, trackpad_rear_h);
}

// ---- print plates (A1 mini 180 x 180, 1.5 mm spacing) ----

module plate1_2d() {
  translate([-26.5, -84.5]) rotate(90) piece_2d("wrist_r");
  translate([56, 146.5]) rotate(90) piece_2d("wrist_l");
  translate([147, 62]) piece_2d("front_rail_l");
  translate([-13.6, 76.5]) piece_2d("front_rail_r");
  translate([147, 90.6]) piece_2d("tpmid_rail_l");
  translate([-13.6, 103.6]) piece_2d("tpmid_rail_r");
  translate([147, 116.6]) piece_2d("mid_rail_l");
  translate([26.4, 127.7]) piece_2d("mid_rail_r");
  translate([147, 139.2]) piece_2d("rear_rail_l");
  translate([26.4, 150.7]) piece_2d("rear_rail_r");
  translate([109.5, 161.8]) piece_2d("stub");
  translate([189, 161.8]) piece_2d("stub");
}

module plate2_2d() {
  translate([36.4, 1.1]) piece_2d("outer_rear");
  translate([36.4, 29.2]) piece_2d("outer_rear");
  translate([36.4, 57.3]) piece_2d("stop_rear");
  translate([36.4, 85.4]) piece_2d("stop_rear");
  translate([36.4, 113.5]) piece_2d("center_rear");
  translate([109.5, 137.6]) piece_2d("outer_front");
  translate([190, 137.6]) piece_2d("outer_front");
  translate([109.5, 153.9]) piece_2d("stop_front");
  translate([190, 153.9]) piece_2d("stop_front");
  translate([156.5, 109.5]) rotate(90) piece_2d("center_front");
}

// ---- sanity checks ----

assert(h2 - h1 >= trackpad_rear_h + 1.5, "keyboard deck too low over trackpad");
assert(rail_splice_front - rail_x0 + 6 <= 176, "front/tpmid rail left half too long");
assert(rail_x1 - rail_splice_front <= 176, "front/tpmid rail right half too long");
assert(rail_x1 - rail_splice_rear <= 176, "mid/rear rail right half too long");
assert(rib_y1 - rib_splice_y <= 176, "rib rear half too long");
assert(kb_half + rib_t <= rib_xs[4] + rib_t / 2 + 0.01, "outer ribs narrower than keyboard");
assert(tp_half <= rib_xs[3] - rib_t / 2 + 0.01, "stop ribs narrower than trackpad");

// empty renders confirm plates fit 178 x 178 and nothing touches the devices
module check_plate_overflow(plate) {
  intersection() {
    if (plate == 1) plate1_2d(); else plate2_2d();
    difference() {
      square([1000, 1000], center = true);
      square([178, 178]);
    }
  }
}

module model() {
  if (part == "assembly") {
    assembly();
  } else if (part == "check_fit1") {
    check_plate_overflow(1);
  } else if (part == "check_fit2") {
    check_plate_overflow(2);
  } else if (part == "check_interference") {
    intersection() {
      assembly();
      devices();
    }
  } else if (part == "plate1") {
    linear_extrude(rib_t) plate1_2d();
  } else if (part == "plate2") {
    linear_extrude(rib_t) plate2_2d();
  } else {
    linear_extrude(rib_t) piece_2d(part);
  }
}

model();
