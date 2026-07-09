// Magic Keyboard + Magic Trackpad tray v3 for Bambu Lab A1 mini.
// Torsion-box lattice: 5 mm ribs + 10 mm rails cross-lapped, locked rigid by
// two top skins (keyboard deck plates + wrist plates) whose closed tenon
// holes capture every rib, rail and splice. The keyboard sits on the deck
// skin; the trackpad rests directly on the desk.
//   openscad -D 'part="plate1"' -o stl/plate1.stl keyboard_trackpad_tray_v2.scad

part = "assembly"; // assembly, plate1, plate2, plate3

keyboard_width = 278.9;
keyboard_depth = 114.9;
keyboard_front_h = 4.1;
keyboard_rear_h = 10.9;
trackpad_width = 160.0;
trackpad_depth = 114.9;
trackpad_front_h = 4.9;
trackpad_rear_h = 10.9;

kb_clear_x = 0.8;
kb_clear_y = 0.5;
tp_clear_x = 0.6;
tp_clear_y = 0.5;

rib_t = 5;                    // Y ribs and skins
rail_t = 10;                  // X rails, doubled vs v2
skin_t = 5;
h_kb = 12.6;                  // keyboard deck top; trackpad sits on the desk
h_sub = h_kb - skin_t;        // 7.6, lattice top under the deck skin
stop_h = 4;
float_gap = 0.4;              // inner members hover above the desk
slot_clearance = 0.25;
splice_clearance = 0.15;
tenon_clearance = 0.2;

wrist_ledge = 7;
wrist_top = wrist_ledge + skin_t; // 12, palm sits above the trackpad surface

kb_half = keyboard_width / 2 + kb_clear_x;             // 140.25
tp_half = trackpad_width / 2 + tp_clear_x;             // 80.6
tp_front = -103;
tp_rear = tp_front + trackpad_depth + 2 * tp_clear_y;  // 12.9
kb_front = 4;                 // keyboard front overhangs the trackpad rear
kb_rear = kb_front + keyboard_depth + 2 * kb_clear_y;  // 119.9

rib_y0 = tp_front - rail_t;   // -113
rib_y1 = kb_rear + 6.1;       // 126
rib_xs = [-(kb_half + rib_t / 2), -(tp_half + rib_t / 2), 0,
          tp_half + rib_t / 2, kb_half + rib_t / 2];   // +-142.75, +-83.1, 0
rail_half = kb_half + rib_t;  // 145.25, front rail spans the full width
r2_half = 88;                 // R2/R3/R4 span only the stop ribs -> one piece
rail_ys = [tp_front - rail_t / 2, tp_rear + rail_t / 2, 65, 110]; // -108, 17.9
rail_splits = [3.5, 4, 4, 4]; // z plane where top/bottom slots meet, per rail

lip_top = h_kb + 4.4;         // 17, keyboard front lip
tp_lip_top = trackpad_front_h + 3.5; // 8.4, trackpad front lip
side_stop_top = h_kb + stop_h;       // 16.6, outer-rib tenons double as stops
rear_tab_top = h_kb + 7;      // 19.6, keyboard rear stop tabs
center_y0 = 40;               // center rib starts behind the plug reach

splice_a_y = 40;              // outer rib splice, clamped by deck tenon holes
splice_b_y = rail_ys[1];      // stop rib splice lives inside the R2 slot
splice_r1_x = rib_xs[3];      // front rail splices inside the stop rib slots
dt_len = 9;
// dovetail tops stay >= 1.2 under h_sub: the socket hook must keep meat, or it
// tapers to a point and slices as a loose sliver (v3 first print)
dt_a = [[-0.1, 0], [dt_len, 0], [dt_len, h_sub - 2], [-0.1, h_sub - 3.5]];
dt_b = [[-0.1, 4], [dt_len, 4], [dt_len, h_sub - 1.4], [-0.1, h_sub - 2.4]];
dt_r1 = [[-0.1, float_gap], [dt_len, float_gap], [dt_len, 3.5], [-0.1, 2.5]];

tenon_len = 12;
wrist_tenon_ys = [-95, -65];  // rib tenons through the wrist plates
r1_tenon_xs = [95, 125];      // front rail tenons through the wrist plates
a1_deck_ys = [31];            // outer rib front piece, flush with deck
a2_deck_ys = [57, 91, 109];   // outer rib rear; first two rise as side stops
b_deck_ys = [35, 88];         // stop rib tenons through the deck
c_deck_ys = [51, 91];         // center rib tenons at the deck seam
rail_tenon_x = 45;            // R2/R3/R4 tenons through the deck, +-

arch_r2_w = 20;               // trackpad USB-C plug pass-through
arch_r2_h = 9.5;
r2_block_half = 18;           // raised bridge over the plug arch, top = h_kb
window_x = 25;                // cable windows in mid/rear rails
window_w = 14;
r1_pad_xs = [-130, -45, 0, 45, 130];
r4_pad_xs = [-45, 45];
pad_w = 14;

wrist_x0 = tp_half;           // wrist plate inner edge doubles as side stop
wrist_x1 = rail_half;         // 145.25, flush with the front rail ends
wrist_y0 = rib_y0 - 3;        // -116, closes the wall around the R1 tenons
wrist_y1 = -53;
deck_x1 = rail_half + 2.25;   // 147.5, keeps a wall outside the outer holes
deck_y0 = tp_rear;            // 12.9, must not reach over the trackpad
deck_y1 = kb_rear;

label_d = 0.6;                // engraving depth of the piece codes
label_font = "Liberation Sans:style=Bold";

keyboard_y = (kb_front + kb_rear) / 2;   // 61.95
trackpad_y = (tp_front + tp_rear) / 2;   // -45.05

$fn = 48;

// ---- 2D helpers (profiles live in a (u, v) plane, v = height) ----

module top_band(u1, u2, v_top, v_bot = float_gap) {
  translate([u1, v_bot])
    square([u2 - u1, v_top - v_bot]);
}

module tenon(u, v_top, v_bot = float_gap) {
  top_band(u - tenon_len / 2, u + tenon_len / 2, v_top, v_bot);
}

module bottom_slot(u, split, w) {
  translate([u - (w + slot_clearance) / 2, -1])
    square([w + slot_clearance, split + 1]);
}

module top_slot(u, split, w) {
  translate([u - (w + slot_clearance) / 2, split])
    square([w + slot_clearance, 100]);
}

module arch(u, w, h) {
  translate([u - w / 2, -1])
    square([w, h + 1]);
}

module window(u, w) { // cable pass, keeps a bottom chord so rails stay one piece
  translate([u - w / 2, 2])
    square([w, h_sub - 2]);
}

module desk_pads(xs) {
  for (x = xs)
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

module outer_rib_profile() { // desk contact along the whole bottom edge
  difference() {
    union() {
      top_band(rib_y0, kb_front - rib_t, wrist_ledge, 0);
      for (y = wrist_tenon_ys)
        tenon(y, wrist_top, 0);
      top_band(kb_front - rib_t, kb_front, lip_top, 0); // keyboard front lip
      top_band(kb_front, rib_y1, h_sub, 0);
      for (y = a1_deck_ys)
        tenon(y, h_kb, 0);
      for (y = [a2_deck_ys[0], a2_deck_ys[1]])
        tenon(y, side_stop_top, 0);                     // keyboard side stops
      tenon(a2_deck_ys[2], h_kb, 0);
      top_band(kb_rear, rib_y1, rear_tab_top, 0);       // keyboard rear stop
    }
    bottom_slot(rail_ys[0], rail_splits[0], rail_t);    // only R1 crosses
  }
}

module stop_rib_profile() {
  difference() {
    union() {
      top_band(rib_y0, kb_front - rib_t, wrist_ledge);  // trackpad side wall
      for (y = wrist_tenon_ys)
        tenon(y, wrist_top);
      top_band(kb_front - rib_t, kb_front, lip_top);    // keyboard front lip
      top_band(kb_front, rib_y1, h_sub);
      for (y = b_deck_ys)
        tenon(y, h_kb);
      top_band(kb_rear, rib_y1, rear_tab_top);          // keyboard rear stop
    }
    for (i = [0 : 3])
      bottom_slot(rail_ys[i], rail_splits[i], rail_t);
  }
}

module center_rib_profile() {
  difference() {
    union() {
      top_band(center_y0, deck_y1, h_sub);
      for (y = c_deck_ys)
        tenon(y, h_kb);
    }
    bottom_slot(rail_ys[2], rail_splits[2], rail_t);
    bottom_slot(rail_ys[3], rail_splits[3], rail_t);
  }
}

// ---- X rail profiles, u = x ----

module front_rail_profile() {
  difference() {
    union() {
      top_band(-rail_half, rail_half, wrist_ledge);
      top_band(-tp_half, tp_half, tp_lip_top);          // trackpad front lip
      for (x = r1_tenon_xs)
        for (s = [-1, 1])
          tenon(s * x, wrist_top);
      desk_pads(r1_pad_xs);
    }
    for (x = [rib_xs[0], rib_xs[1], rib_xs[3], rib_xs[4]])
      top_slot(x, rail_splits[0], rib_t);
  }
}

module tpstop_rail_profile() {
  difference() {
    union() {
      top_band(-r2_half, r2_half, h_sub); // trackpad rear stop + deck support
      top_band(-r2_block_half, r2_block_half, h_kb); // bridge over the plug
      for (s = [-1, 1])
        tenon(s * rail_tenon_x, h_kb);
    }
    arch(0, arch_r2_w, arch_r2_h);        // trackpad USB-C plug
    top_slot(rib_xs[1], rail_splits[1], rib_t);
    top_slot(rib_xs[3], rail_splits[1], rib_t);
  }
}

module mid_rail_profile() {
  difference() {
    union() {
      top_band(-r2_half, r2_half, h_sub);
      for (s = [-1, 1])
        tenon(s * rail_tenon_x, h_kb);
    }
    window(window_x, window_w);
    for (x = [rib_xs[1], rib_xs[2], rib_xs[3]])
      top_slot(x, rail_splits[2], rib_t);
  }
}

module rear_rail_profile() {
  difference() {
    union() {
      top_band(-r2_half, r2_half, h_sub);
      for (s = [-1, 1])
        tenon(s * rail_tenon_x, h_kb);
      desk_pads(r4_pad_xs);
    }
    window(window_x, window_w);
    for (x = [rib_xs[1], rib_xs[2], rib_xs[3]])
      top_slot(x, rail_splits[3], rib_t);
  }
}

// ---- top skins, drawn in tray (x, y) coordinates, right side ----

module tenon_hole(cx, cy, wx, wy) {
  translate([cx - wx / 2 - tenon_clearance, cy - wy / 2 - tenon_clearance])
    square([wx + 2 * tenon_clearance, wy + 2 * tenon_clearance]);
}

module wrist_plate_2d() {
  difference() {
    offset(r = 3) offset(delta = -3)
      translate([wrist_x0, wrist_y0])
        square([wrist_x1 - wrist_x0, wrist_y1 - wrist_y0]);
    for (x = r1_tenon_xs) // closed holes over the front rail tenons: x lock
      tenon_hole(x, rail_ys[0], tenon_len, rail_t);
    for (y = wrist_tenon_ys) {
      translate([wrist_x0 - 1, y - tenon_len / 2 - tenon_clearance]) // B notch
        square([rib_t + tenon_clearance + 1, tenon_len + 2 * tenon_clearance]);
      translate([rib_xs[4] - rib_t / 2 - tenon_clearance,             // A notch
                 y - tenon_len / 2 - tenon_clearance])
        square([rib_t + tenon_clearance + 1 + wrist_x1 - rib_xs[4] - rib_t / 2,
                tenon_len + 2 * tenon_clearance]);
    }
  }
}

module deck_plate_2d() {
  difference() {
    offset(r = 3) offset(delta = -3)
      translate([0, deck_y0])
        square([deck_x1, deck_y1 - deck_y0]);
    for (y = concat(a1_deck_ys, a2_deck_ys))          // outer rib, closed holes
      tenon_hole(rib_xs[4], y, rib_t, tenon_len);
    for (y = b_deck_ys)                               // stop rib, closed holes
      tenon_hole(rib_xs[3], y, rib_t, tenon_len);
    for (y = c_deck_ys)                               // center rib, seam notch
      translate([-1, y - tenon_len / 2 - tenon_clearance])
        square([rib_t / 2 + tenon_clearance + 1, tenon_len + 2 * tenon_clearance]);
    tenon_hole(rail_tenon_x, rail_ys[1], tenon_len, rail_t); // R2, front notch
    tenon_hole(rail_tenon_x, rail_ys[2], tenon_len, rail_t); // R3
    tenon_hole(rail_tenon_x, rail_ys[3], tenon_len, rail_t); // R4
    translate([-1, deck_y0 - 1])                      // notch around R2 bridge
      square([r2_block_half + tenon_clearance + 1,
              rail_ys[1] + rail_t / 2 - deck_y0 + tenon_clearance + 1]);
  }
}

// ---- printable pieces (2D) ----

module piece_2d(name) {
  if (name == "outer_front") splice_lo(splice_a_y, dt_a) outer_rib_profile();
  else if (name == "outer_rear") splice_hi(splice_a_y, dt_a) outer_rib_profile();
  else if (name == "stop_front") splice_lo(splice_b_y, dt_b) stop_rib_profile();
  else if (name == "stop_rear") splice_hi(splice_b_y, dt_b) stop_rib_profile();
  else if (name == "center") center_rib_profile();
  else if (name == "front_rail_l") splice_lo(-splice_r1_x, dt_r1) front_rail_profile();
  else if (name == "front_rail_c") splice_hi(-splice_r1_x, dt_r1) splice_lo(splice_r1_x, dt_r1) front_rail_profile();
  else if (name == "front_rail_r") splice_hi(splice_r1_x, dt_r1) front_rail_profile();
  else if (name == "tpstop_rail") tpstop_rail_profile();
  else if (name == "mid_rail") mid_rail_profile();
  else if (name == "rear_rail") rear_rail_profile();
  else if (name == "wrist_r") wrist_plate_2d();
  else if (name == "wrist_l") mirror([1, 0]) wrist_plate_2d();
  else if (name == "deck_r") deck_plate_2d();
  else if (name == "deck_l") mirror([1, 0]) deck_plate_2d();
}

function piece_t(name) =
  (name == "front_rail_l" || name == "front_rail_c" || name == "front_rail_r" ||
   name == "tpstop_rail" || name == "mid_rail" || name == "rear_rail")
    ? rail_t : rib_t;

// ---- engraved piece codes (see README): same letter mates, 1=front, 2=rear ----

label_specs = [
  // name, code, u, v, size, engrave bottom face
  ["outer_front", "A1", -60, 3.5, 4, false],
  ["outer_rear", "A2", 75, 3.7, 4, false],
  ["stop_front", "B1", -60, 3.5, 4, false],
  ["stop_rear", "B2", 50, 3.7, 4, false],
  ["center", "C", 80, 3.7, 4, false],
  ["front_rail_l", "R1L", -120, 3.5, 4, false],
  ["front_rail_c", "R1C", 0, 4.2, 4, false],
  ["front_rail_r", "R1R", 120, 3.5, 4, false],
  ["tpstop_rail", "R2", -45, 3.7, 4, false],
  ["mid_rail", "R3", -60, 3.7, 4, false],
  ["rear_rail", "R4", -60, 3.7, 4, false],
  ["wrist_r", "WR", 112, -85, 8, true],  // bottom: top face stays clean
  ["wrist_l", "WL", -112, -85, 8, true],
  ["deck_r", "DR", 112, 105, 8, true],
  ["deck_l", "DL", -112, 105, 8, true],
];

function label_spec(name) = [for (s = label_specs) if (s[0] == name) s][0];

module piece_3d(name) {
  spec = label_spec(name);
  t = piece_t(name);
  difference() {
    linear_extrude(t) piece_2d(name);
    if (spec[5]) {
      translate([spec[2], spec[3], -0.1])
        linear_extrude(label_d + 0.1)
          mirror([1, 0])
            text(spec[1], size = spec[4], font = label_font, halign = "center", valign = "center");
    } else {
      translate([spec[2], spec[3], t - label_d])
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
  translate([0, y + rail_t / 2, 0])
    rotate([90, 0, 0])
      children();
}

module device_wedge(w, d, front_h, rear_h) {
  translate([-w / 2, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(w)
        polygon([[-d / 2, 0], [d / 2, 0], [d / 2, rear_h], [-d / 2, front_h]]);
}

module ribs() {
  for (x = [rib_xs[0], rib_xs[4]]) {
    place_y_rib(x) piece_3d("outer_front");
    place_y_rib(x) piece_3d("outer_rear");
  }
  for (x = [rib_xs[1], rib_xs[3]]) {
    place_y_rib(x) piece_3d("stop_front");
    place_y_rib(x) piece_3d("stop_rear");
  }
  place_y_rib(0) piece_3d("center");
}

module rails() {
  place_x_rail(rail_ys[0]) piece_3d("front_rail_l");
  place_x_rail(rail_ys[0]) piece_3d("front_rail_c");
  place_x_rail(rail_ys[0]) piece_3d("front_rail_r");
  place_x_rail(rail_ys[1]) piece_3d("tpstop_rail");
  place_x_rail(rail_ys[2]) piece_3d("mid_rail");
  place_x_rail(rail_ys[3]) piece_3d("rear_rail");
}

module lattice() {
  ribs();
  rails();
}

module skins() {
  translate([0, 0, h_sub]) {
    piece_3d("deck_r");
    piece_3d("deck_l");
  }
  translate([0, 0, wrist_ledge]) {
    piece_3d("wrist_r");
    piece_3d("wrist_l");
  }
}

module assembly() {
  lattice();
  skins();
  %devices();
}


module devices(dz = 0) { // dz lifts the devices for the coplanar-face-free check
  translate([0, keyboard_y, h_kb + dz])
    device_wedge(keyboard_width, keyboard_depth, keyboard_front_h, keyboard_rear_h);
  translate([0, trackpad_y, dz])
    device_wedge(trackpad_width, trackpad_depth, trackpad_front_h, trackpad_rear_h);
}

// ---- print plates (A1 mini 180 x 180, 1.5 mm spacing) ----

plate1_layout = [
  // name, x, y, rotation
  ["stop_front", 114.5, 1.5, 0],
  ["stop_front", 114.5, 20, 0],
  ["outer_front", 114.5, 38.5, 0],
  ["outer_front", 114.5, 57, 0],
  ["center", -38.5, 75.1, 0],
  ["outer_rear", -38.6, 89.2, 0],
  ["outer_rear", -38.6, 110.3, 0],
  ["stop_rear", -16.5, 131.4, 0],
  ["stop_rear", -16.5, 152.5, 0],
  ["wrist_r", 30.4, 205.2, 0],
];

plate2_layout = [
  ["deck_r", 1.5, -11.4, 0],
  ["tpstop_rail", 89.5, 109.6, 0],
  ["mid_rail", 89.5, 123.7, 0],
  ["rear_rail", 89.5, 137.8, 0],
  ["front_rail_c", 84.6, 151.9, 0],
];

plate3_layout = [
  ["deck_l", 149, -11.4, 0],
  ["wrist_l", 146.75, 226, 0],
  ["front_rail_l", 212.9, 110, 0],
  ["front_rail_r", -15.45, 123.5, 0],
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
assert(splice_a_y + dt_len - rib_y0 <= 176, "outer rib front piece too long");
assert(rib_y1 - splice_a_y <= 176, "outer rib rear piece too long");
assert(splice_b_y + dt_len - rib_y0 <= 176, "stop rib front piece too long");
assert(rib_y1 - splice_b_y <= 176, "stop rib rear piece too long");
assert(2 * splice_r1_x + dt_len <= 176, "front rail center piece too long");
assert(2 * r2_half <= 176, "single-piece rails too long");
assert(deck_x1 <= 176, "deck plate too wide");
assert(deck_y1 - deck_y0 <= 176, "deck plate too deep");
assert(rib_xs[4] - rib_t / 2 >= kb_half - 0.01, "outer ribs narrower than keyboard");
assert(rib_xs[3] - rib_t / 2 >= tp_half - 0.01, "stop ribs narrower than trackpad");
assert(rail_ys[3] + rail_t / 2 + tenon_clearance < deck_y1 - 2, "R4 hole breaks deck rear edge");

// empty renders confirm plates fit 178 x 178 and nothing touches the devices
module check_plate_overflow(plate) {
  intersection() {
    plate_2d(plate == 1 ? plate1_layout : plate == 2 ? plate2_layout : plate3_layout);
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
  } else if (part == "check_fit3") {
    check_plate_overflow(3);
  } else if (part == "check_interference") {
    intersection() {
      assembly();
      devices(0.01);
    }
  } else if (part == "check_lattice") { // cross-laps must have clearance: empty
    intersection() {
      ribs();
      rails();
    }
  } else if (part == "check_skins") { // skins must clear every tenon: empty
    intersection() {
      lattice();
      skins();
      translate([-500, -500, h_sub + 0.05]) // resting planes are not overlap
        cube([1000, 1000, 100]);
    }
  } else if (part == "plate1") {
    plate_3d(plate1_layout);
  } else if (part == "plate2") {
    plate_3d(plate2_layout);
  } else if (part == "plate3") {
    plate_3d(plate3_layout);
  } else {
    piece_3d(part);
  }
}

model();
