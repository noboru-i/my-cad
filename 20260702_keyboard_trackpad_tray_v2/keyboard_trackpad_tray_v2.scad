// Magic Keyboard + Magic Trackpad tray v2 for Bambu Lab A1 mini.
// Egg-crate lattice: every part is a 5 mm-thick 2D profile printed flat,
// assembled with cross-lap slots and dovetail splices. Every splice sits
// inside a crossing slot, so the crossing member locks the joint rigid.
// The trackpad rests directly on the desk (rear stop rail behind it);
// the keyboard deck sits 12.6 mm up, keeping the same offset as before.
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

kb_clear_x = 0.8;
kb_clear_y = 0.5;             // depth pocket tightened 3 mm vs old build
tp_clear_x = 0.6;             // width pocket tightened 2 mm vs old build
tp_clear_y = 0.5;

rib_t = 5;
h_kb = trackpad_rear_h + 1.7; // 12.6, keyboard deck; trackpad sits on the desk
stop_h = 4;
float_gap = 0.4;              // inner members hover above the desk
slot_clearance = 0.25;
splice_clearance = 0.15;
tenon_clearance = 0.2;

wrist_ledge = 7;
wrist_top = wrist_ledge + rib_t; // 12, palm sits above the trackpad surface

kb_half = keyboard_width / 2 + kb_clear_x;             // 140.25
tp_half = trackpad_width / 2 + tp_clear_x;             // 80.6
tp_front = -103;
tp_rear = tp_front + trackpad_depth + 2 * tp_clear_y;  // 12.9
kb_front = 4;                 // keyboard front overhangs the trackpad rear
kb_rear = kb_front + keyboard_depth + 2 * kb_clear_y;  // 119.9

rib_y0 = tp_front - rib_t;    // -108
rib_y1 = kb_rear + 6.1;       // 126
rib_xs = [-(kb_half + rib_t / 2), -(tp_half + rib_t / 2), 0,
          tp_half + rib_t / 2, kb_half + rib_t / 2];   // +-142.75, +-83.1, 0
rail_half = kb_half + rib_t;  // 145.25, full-width rail ends
r2_half = 88;                 // trackpad stop rail only spans the stop ribs
rail_ys = [tp_front - rib_t / 2, tp_rear + rib_t / 2, 65, 112]; // -105.5, 15.4
rail_splits = [4, 5, 5, 5];   // z plane where top/bottom slots meet, per rail

lip_top = h_kb + 4.4;         // 17, keyboard front lip
tp_lip_top = trackpad_front_h + 3.5; // 8.4, trackpad front lip
rear_tab_top = h_kb + 7;      // 19.6, keyboard rear stop tabs
center_y0 = 25;               // center rib starts behind the plug arch

rib_splice_y = rail_ys[1];    // rib splices live inside the R2 slot
rail_splice_out = rib_xs[3];  // front rail splices inside the stop rib slots
dt_len = 9;
rib_dt = [[-0.1, 5.0], [dt_len, 5.0], [dt_len, 10.6], [-0.1, 9.35]];
rail_dt5 = [[-0.1, 0.4], [dt_len, 0.4], [dt_len, 5.0], [-0.1, 3.85]];
rail_dt4 = [[-0.1, 0.4], [dt_len, 0.4], [dt_len, 4.0], [-0.1, 3.0]];

arch_r2_w = 18;               // trackpad USB-C plug pass-through
arch_x = 25;                  // cable arches in mid/rear rails
arch_w = 14;
arch_h = 9;
pad_xs = [-130, -45, 45, 130];
pad_w = 14;

label_d = 0.6;                // engraving depth of the piece codes
label_font = "Liberation Sans:style=Bold";

tenon_ys = [-90, -45];        // wrist plate tenons on outer + stop ribs
tenon_len = 12;
plate_x0 = tp_half;           // wrist plate inner edge doubles as side stop
plate_x1 = rail_half + 2.25;  // 147.5, keeps a wall outside the tenon holes
plate_y0 = rib_y0;
plate_y1 = -28;

keyboard_y = (kb_front + kb_rear) / 2;   // 61.95
trackpad_y = (tp_front + tp_rear) / 2;   // -45.05

$fn = 48;

// ---- 2D helpers (profiles live in a (u, v) plane, v = height) ----

module top_band(u1, u2, v_top, v_bot = float_gap) {
  translate([u1, v_bot])
    square([u2 - u1, v_top - v_bot]);
}

module bottom_slot(u, split) {
  translate([u - (rib_t + slot_clearance) / 2, -1])
    square([rib_t + slot_clearance, split + 1]);
}

module top_slot(u, split) {
  translate([u - (rib_t + slot_clearance) / 2, split])
    square([rib_t + slot_clearance, 100]);
}

module arch(u, w, h) {
  translate([u - w / 2, -1])
    square([w, h + 1]);
}

module desk_pads() {
  for (x = pad_xs)
    translate([x - pad_w / 2, 0])
      square([pad_w, 1]);
}

// keep u < us, grow a half-dovetail tab past the joint line
module splice_lo(us, dt) {
  intersection() {
    children();
    translate([us - 1000, -500])
      square([1000, 1500]);
  }
  translate([us, 0])
    polygon(dt);
}

// keep u > us, cut the matching socket
module splice_hi(us, dt) {
  difference() {
    intersection() {
      children();
      translate([us + 0.1, -500])
        square([1000, 1500]);
    }
    translate([us, 0])
      offset(delta = splice_clearance)
        polygon(dt);
  }
}

// ---- Y rib profiles, u = y ----

module rib_slots() {
  for (i = [0 : 3])
    bottom_slot(rail_ys[i], rail_splits[i]);
}

module outer_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, kb_front - rib_t, wrist_ledge);
      for (y = tenon_ys)
        top_band(y - tenon_len / 2, y + tenon_len / 2, wrist_top);
      top_band(kb_front - rib_t, kb_front, lip_top);   // keyboard front lip
      top_band(kb_front, rib_y1, h_kb + stop_h);       // deck + side stop
      top_band(kb_rear, rib_y1, rear_tab_top);         // keyboard rear stop
    }
    rib_slots();
  }
}

module stop_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, kb_front - rib_t, wrist_ledge); // trackpad side wall
      for (y = tenon_ys)
        top_band(y - tenon_len / 2, y + tenon_len / 2, wrist_top);
      top_band(kb_front - rib_t, kb_front, lip_top);   // keyboard front lip
      top_band(kb_front, kb_rear, h_kb);               // keyboard deck
      top_band(kb_rear, rib_y1, rear_tab_top);         // keyboard rear stop
    }
    rib_slots();
  }
}

module center_rib_profile() {
  difference() {
    top_band(center_y0, kb_rear, h_kb);
    bottom_slot(rail_ys[2], rail_splits[2]);
    bottom_slot(rail_ys[3], rail_splits[3]);
  }
}

// ---- X rail profiles, u = x ----

module front_rail_profile() {
  difference() {
    union() {
      top_band(-rail_half, rail_half, wrist_ledge);
      top_band(-tp_half, tp_half, tp_lip_top);         // trackpad front lip
      desk_pads();
    }
    for (x = [rib_xs[0], rib_xs[1], rib_xs[3], rib_xs[4]])
      top_slot(x, rail_splits[0]);
  }
}

module tpstop_rail_profile() {
  difference() {
    top_band(-r2_half, r2_half, h_kb); // trackpad rear stop + keyboard front support
    arch(0, arch_r2_w, arch_h);        // trackpad USB-C plug
    top_slot(rib_xs[1], rail_splits[1]);
    top_slot(rib_xs[3], rail_splits[1]);
  }
}

module mid_rail_profile() {
  difference() {
    top_band(-rail_half, rail_half, h_kb);
    arch(arch_x, arch_w, arch_h);
    for (x = rib_xs)
      top_slot(x, rail_splits[2]);
  }
}

module rear_rail_profile() {
  difference() {
    union() {
      top_band(-rail_half, rail_half, h_kb);
      desk_pads();
    }
    arch(arch_x, arch_w, arch_h);
    for (x = rib_xs)
      top_slot(x, rail_splits[3]);
  }
}

// ---- wrist plate, drawn in tray (x, y) coordinates, right side ----

module wrist_plate_2d() {
  difference() {
    offset(r = 3) offset(delta = -3)
      translate([plate_x0, plate_y0])
        square([plate_x1 - plate_x0, plate_y1 - plate_y0]);
    for (y = tenon_ys) {
      translate([rib_xs[4] - (rib_t + tenon_clearance * 2) / 2,
                 y - tenon_len / 2 - tenon_clearance])
        square([rib_t + tenon_clearance * 2, tenon_len + tenon_clearance * 2]);
      translate([plate_x0 - 1, y - tenon_len / 2 - tenon_clearance]) // edge notch
        square([rib_t + tenon_clearance + 1, tenon_len + tenon_clearance * 2]);
    }
  }
}

// ---- printable pieces (2D) ----

module piece_2d(name) {
  if (name == "outer_front") splice_lo(rib_splice_y, rib_dt) outer_rib_profile();
  else if (name == "outer_rear") splice_hi(rib_splice_y, rib_dt) outer_rib_profile();
  else if (name == "stop_front") splice_lo(rib_splice_y, rib_dt) stop_rib_profile();
  else if (name == "stop_rear") splice_hi(rib_splice_y, rib_dt) stop_rib_profile();
  else if (name == "center") center_rib_profile();
  else if (name == "front_rail_l") splice_lo(-rail_splice_out, rail_dt4) front_rail_profile();
  else if (name == "front_rail_c") splice_hi(-rail_splice_out, rail_dt4) splice_lo(rail_splice_out, rail_dt4) front_rail_profile();
  else if (name == "front_rail_r") splice_hi(rail_splice_out, rail_dt4) front_rail_profile();
  else if (name == "tpstop_rail") tpstop_rail_profile();
  else if (name == "mid_rail_l") splice_lo(0, rail_dt5) mid_rail_profile();
  else if (name == "mid_rail_r") splice_hi(0, rail_dt5) mid_rail_profile();
  else if (name == "rear_rail_l") splice_lo(0, rail_dt5) rear_rail_profile();
  else if (name == "rear_rail_r") splice_hi(0, rail_dt5) rear_rail_profile();
  else if (name == "wrist_r") wrist_plate_2d();
  else if (name == "wrist_l") mirror([1, 0]) wrist_plate_2d();
}

// ---- engraved piece codes (see README): same letter mates, 1=front, 2=rear ----

label_specs = [
  // name, code, u, v, size, engrave bottom face
  ["outer_front", "A1", -60, 3.7, 4, false],
  ["outer_rear", "A2", 40, 8, 5, false],
  ["stop_front", "B1", -60, 3.7, 4, false],
  ["stop_rear", "B2", 40, 6.5, 5, false],
  ["center", "C", 42, 6.5, 4.5, false],
  ["front_rail_l", "R1L", -120, 3.7, 4, false],
  ["front_rail_c", "R1C", 0, 4.2, 4, false],
  ["front_rail_r", "R1R", 120, 3.7, 4, false],
  ["tpstop_rail", "R2", -40, 6.5, 5, false],
  ["mid_rail_l", "R3L", -60, 6.5, 5, false],
  ["mid_rail_r", "R3R", 60, 6.5, 5, false],
  ["rear_rail_l", "R4L", -60, 6.5, 5, false],
  ["rear_rail_r", "R4R", 60, 6.5, 5, false],
  ["wrist_r", "WR", 114, -68, 8, true], // bottom: top face stays clean
  ["wrist_l", "WL", -114, -68, 8, true],
];

function label_spec(name) = [for (s = label_specs) if (s[0] == name) s][0];

module piece_3d(name) {
  spec = label_spec(name);
  difference() {
    linear_extrude(rib_t) piece_2d(name);
    if (spec[5]) {
      translate([spec[2], spec[3], -0.1])
        linear_extrude(label_d + 0.1)
          mirror([1, 0])
            text(spec[1], size = spec[4], font = label_font, halign = "center", valign = "center");
    } else {
      translate([spec[2], spec[3], rib_t - label_d])
        linear_extrude(label_d + 0.1)
          text(spec[1], size = spec[4], font = label_font, halign = "center", valign = "center");
    }
  }
}

// ---- assembly ----

module place_y_rib(x) {
  translate([x - rib_t / 2, 0, 0])
    rotate([90, 0, 90])
      children();
}

module place_x_rail(y) {
  translate([0, y + rib_t / 2, 0])
    rotate([90, 0, 0])
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
    place_y_rib(x) piece_3d("outer_front");
    place_y_rib(x) piece_3d("outer_rear");
  }
  for (x = [rib_xs[1], rib_xs[3]]) {
    place_y_rib(x) piece_3d("stop_front");
    place_y_rib(x) piece_3d("stop_rear");
  }
  place_y_rib(0) piece_3d("center");

  place_x_rail(rail_ys[0]) piece_3d("front_rail_l");
  place_x_rail(rail_ys[0]) piece_3d("front_rail_c");
  place_x_rail(rail_ys[0]) piece_3d("front_rail_r");
  place_x_rail(rail_ys[1]) piece_3d("tpstop_rail");
  place_x_rail(rail_ys[2]) piece_3d("mid_rail_l");
  place_x_rail(rail_ys[2]) piece_3d("mid_rail_r");
  place_x_rail(rail_ys[3]) piece_3d("rear_rail_l");
  place_x_rail(rail_ys[3]) piece_3d("rear_rail_r");

  translate([0, 0, wrist_ledge]) {
    piece_3d("wrist_r");
    piece_3d("wrist_l");
  }

  %devices();
}

module devices(dz = 0) { // dz lifts the keyboard off the deck for the coplanar-face-free check
  translate([0, keyboard_y, h_kb + dz])
    device_wedge(keyboard_width, keyboard_depth, keyboard_front_h, keyboard_rear_h);
  translate([0, trackpad_y, 0])
    device_wedge(trackpad_width, trackpad_depth, trackpad_front_h, trackpad_rear_h);
}

// ---- print plates (A1 mini 180 x 180, 1.5 mm spacing) ----

plate1_layout = [
  // name, x, y, rotation
  ["outer_front", 110, 1, 0],
  ["outer_front", 110, 19.5, 0],
  ["stop_front", 110, 38, 0],
  ["stop_front", 110, 56.5, 0],
  ["outer_rear", -13.5, 75, 0],
  ["outer_rear", -13.5, 96.1, 0],
  ["stop_rear", -13.5, 117.2, 0],
  ["stop_rear", -13.5, 138.3, 0],
];

plate2_layout = [
  ["tpstop_rail", 89, 1.5, 0],
  ["mid_rail_l", 146.5, 15.6, 0],
  ["mid_rail_r", 1.5, 29.7, 0],
  ["rear_rail_l", 146.5, 43.8, 0],
  ["rear_rail_r", 1.5, 57.9, 0],
  ["front_rail_c", 84.5, 72, 0],
  ["front_rail_l", 146.75, 81.9, 0],
  ["front_rail_r", -8.5, 81.9, 0],
  ["center", -22, 90.4, 0],
  ["wrist_r", -26, 23.9, 90],
  ["wrist_l", 56, 252, 90],
];

module plate_2d(layout) {
  for (p = layout)
    translate([p[1], p[2]])
      rotate(p[3])
        piece_2d(p[0]);
}

module plate_3d(layout) {
  for (p = layout)
    translate([p[1], p[2], 0])
      rotate(p[3])
        piece_3d(p[0]);
}

// ---- sanity checks ----

assert(h_kb - trackpad_rear_h >= 1.5, "keyboard deck too low over trackpad");
assert(rib_splice_y + dt_len - rib_y0 <= 176, "rib front piece too long");
assert(rib_y1 - rib_splice_y <= 176, "rib rear piece too long");
assert(rail_half + dt_len <= 176, "mid/rear rail half too long");
assert(2 * rail_splice_out + dt_len <= 176, "front rail center piece too long");
assert(2 * r2_half <= 176, "trackpad stop rail too long");
assert(rib_xs[4] - rib_t / 2 >= kb_half - 0.01, "outer ribs narrower than keyboard");
assert(rib_xs[3] - rib_t / 2 >= tp_half - 0.01, "stop ribs narrower than trackpad");

// empty renders confirm plates fit 178 x 178 and nothing touches the devices
module check_plate_overflow(plate) {
  intersection() {
    plate_2d(plate == 1 ? plate1_layout : plate2_layout);
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
      devices(0.01);
    }
  } else if (part == "plate1") {
    plate_3d(plate1_layout);
  } else if (part == "plate2") {
    plate_3d(plate2_layout);
  } else {
    piece_3d(part);
  }
}

model();
