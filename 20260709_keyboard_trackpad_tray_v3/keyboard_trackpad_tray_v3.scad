// Magic Keyboard + Magic Trackpad tray v3 for Bambu Lab A1 mini.
// Torsion-box lattice (5 mm ribs + 10 mm rails) locked by keyboard deck skins.
// The v2 front rail (R1) is gone: each palm unit (WR/WL) carries its own desk
// wall, trackpad front lip and a palm-rejection flap that overhangs the
// trackpad sides. Keyboard tilt is set by two swappable riser bars (riser_h),
// trackpad overlap by reprinting the palm units (tp_exposed_w / tp_exposed_d).
//   openscad -D 'part="plate1"' -o stl/plate1.stl keyboard_trackpad_tray_v3.scad

part = "assembly"; // assembly, plate1..plate4, piece names, check_*
riser_h = 4;        // keyboard rear riser height; 0 = flat, no riser pieces
tp_exposed_w = 130; // trackpad width left open between the palm flaps
tp_exposed_d = 90;  // trackpad depth left open in front of the keyboard

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
rail_t = 10;                  // X rails
skin_t = 5;
h_kb = 12.6;                  // keyboard deck top; trackpad sits on the desk
h_sub = h_kb - skin_t;        // 7.6, lattice top under the deck skin
stop_h = 5.5;                 // side stops keep engaging the tilted keyboard
float_gap = 0.4;              // rails and center rib hover above the desk
slot_clearance = 0.25;
splice_clearance = 0.15;
tenon_clearance = 0.2;

wrist_ledge = 7;              // rib ledge carrying the palm plates
wrist_top = 13.5;             // palm surface, just above the keyboard deck
flap_bottom = 10.5;           // palm flap underside, clears the trackpad wedge

kb_half = keyboard_width / 2 + kb_clear_x;             // 140.25
tp_half = trackpad_width / 2 + tp_clear_x;             // 80.6
tp_front = -103;
tp_rear = tp_front + trackpad_depth + 2 * tp_clear_y;  // 12.9
kb_front = tp_front + tp_clear_y + tp_exposed_d;       // -12.5
kb_rear = kb_front + keyboard_depth + 2 * kb_clear_y;  // 103.4

rib_y0 = tp_front - 10;       // -113
rib_y1 = kb_rear + 6.1;       // 109.5
rib_xs = [-(kb_half + rib_t / 2), -(tp_half + rib_t / 2), 0,
          tp_half + rib_t / 2, kb_half + rib_t / 2];   // +-142.75, +-83.1, 0
r2_half = 88;                 // rails span only the stop ribs -> one piece
rail_ys = [tp_rear + rail_t / 2, 55, 88];              // 17.9, R2/R3/R4
rail_splits = [4, 4, 4];      // z plane where top/bottom slots meet, per rail

lip_top = h_kb + 5;           // 17.6, keyboard front lip on the ribs
side_stop_top = h_kb + stop_h;       // 18.1, outer-rib tenons double as stops
rear_tab_top = h_kb + 12;     // 24.6, keyboard rear stop tabs (tilt-proof)
center_y0 = 40;               // center rib starts behind the plug reach

splice_a_y = 40;              // outer rib splice, clamped by deck tenon holes
splice_b_y = rail_ys[0];      // stop rib splice lives inside the R2 slot
dt_len = 9;
// dovetail tops stay >= 1.2 under h_sub: the socket hook must keep meat, or it
// tapers to a point and slices as a loose sliver (v2 second print)
dt_a = [[-0.1, 0], [dt_len, 0], [dt_len, h_sub - 2], [-0.1, h_sub - 3.5]];
dt_b = [[-0.1, 4], [dt_len, 4], [dt_len, h_sub - 1.4], [-0.1, h_sub - 2.4]];
dt_w = [[0.1, -111], [-6, -112], [-6, -105], [0.1, -106]]; // palm seam, plan

tenon_len = 12;
wrist_tenon_ys = [-98, -63, -30]; // rib tenons through the palm plates
a1_deck_ys = [22];            // outer rib front piece, flush with deck
a2_deck_ys = [55, 78, 95];    // outer rib rear; first two rise as side stops
b_deck_ys = [30, 85];         // stop rib tenons through the deck
c_deck_ys = [50, 90];         // center rib tenons at the deck seam
rail_tenon_x = 45;            // R2/R3/R4 tenons through the deck, +-

arch_r2_w = 20;               // trackpad USB-C plug pass-through
arch_r2_h = 9.5;
r2_block_half = 18;           // raised bridge over the plug arch, top = h_kb
window_x = 25;                // cable windows in mid/rear rails
window_w = 14;
rear_pad_xs = [-45, 45];      // R4 desk pads
pad_w = 14;

riser_y = 98;                 // riser web under the keyboard rear edge
riser_t = 6;
riser_x0 = 20;
riser_x1 = 139.5;
riser_tab_xs = [60, 120];     // tabs through the deck into the lattice cavity
riser_tab_w = 12;
riser_tab_d = 5.3;

flap_x = tp_exposed_w / 2;    // 65, palm flap inner edge over the trackpad
wrist_x1 = 147.5;             // keeps a wall outside the outer rib holes
wrist_y0 = -116;
wrist_y1 = kb_front - rib_t - 0.3;   // -17.8, butts the keyboard front lip
strip_y1 = tp_front + tp_clear_y;    // -102.5, center strips stop at the pad
wall_y1 = -113.3;             // front desk wall, clear of the rib ends
lip_y0 = -106;                // trackpad front lip under the palm plates
lip_y1 = tp_front;            // -103
lip_z0 = 2;
lip_x1 = tp_half - 0.4;       // 80.2, stops short of the stop ribs
deck_x1 = 147.5;
deck_y0 = tp_rear;            // 12.9, must not reach over the trackpad
deck_y1 = kb_rear;

label_d = 0.6;                // engraving depth of the piece codes
label_font = "Liberation Sans:style=Bold";

keyboard_y = (kb_front + kb_rear) / 2;   // 45.45
trackpad_y = (tp_front + tp_rear) / 2;   // -45.05
tilt_pivot = riser_y - riser_t / 2 - deck_y0;  // 82.1, deck front edge to seat
tilt_a = riser_h > 0 ? asin(riser_h / tilt_pivot) : 0;

$fn = 48;

function tp_h(y) = trackpad_front_h + (trackpad_rear_h - trackpad_front_h)
                   * (y - (tp_front + tp_clear_y)) / trackpad_depth;

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
}

module stop_rib_profile() { // desk contact too, carries the palm plates
  difference() {
    union() {
      top_band(rib_y0, kb_front - rib_t, wrist_ledge, 0);
      for (y = wrist_tenon_ys)
        tenon(y, wrist_top, 0);
      top_band(kb_front - rib_t, kb_front, lip_top, 0); // keyboard front lip
      top_band(kb_front, rib_y1, h_sub, 0);
      for (y = b_deck_ys)
        tenon(y, h_kb, 0);
      top_band(kb_rear, rib_y1, rear_tab_top, 0);       // keyboard rear stop
    }
    for (i = [0 : 2])
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
    bottom_slot(rail_ys[1], rail_splits[1], rail_t);
    bottom_slot(rail_ys[2], rail_splits[2], rail_t);
  }
}

// ---- X rail profiles, u = x ----

module tpstop_rail_profile() {
  difference() {
    union() {
      top_band(-r2_half, r2_half, h_sub); // trackpad rear stop + deck support
      top_band(-r2_block_half, r2_block_half, h_kb); // bridge over the plug
      for (s = [-1, 1])
        tenon(s * rail_tenon_x, h_kb);
    }
    arch(0, arch_r2_w, arch_r2_h);        // trackpad USB-C plug
    top_slot(rib_xs[1], rail_splits[0], rib_t);
    top_slot(rib_xs[3], rail_splits[0], rib_t);
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
      top_slot(x, rail_splits[1], rib_t);
  }
}

module rear_rail_profile() {
  difference() {
    union() {
      top_band(-r2_half, r2_half, h_sub);
      for (s = [-1, 1])
        tenon(s * rail_tenon_x, h_kb);
      desk_pads(rear_pad_xs);
    }
    window(window_x, window_w);
    for (x = [rib_xs[1], rib_xs[2], rib_xs[3]])
      top_slot(x, rail_splits[2], rib_t);
  }
}

// ---- riser profile, u = x, v = height above the deck ----

module riser_profile() {
  union() {
    translate([riser_x0, 0])
      square([riser_x1 - riser_x0, riser_h]);
    for (x = riser_tab_xs)
      translate([x - riser_tab_w / 2, -riser_tab_d])
        square([riser_tab_w, riser_tab_d + 0.1]);
  }
}

// ---- top skins, drawn in tray (x, y) coordinates ----

module tenon_hole(cx, cy, wx, wy) {
  translate([cx - wx / 2 - tenon_clearance, cy - wy / 2 - tenon_clearance])
    square([wx + 2 * tenon_clearance, wy + 2 * tenon_clearance]);
}

module deck_plate_2d() { // right side
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
    tenon_hole(rail_tenon_x, rail_ys[0], tenon_len, rail_t); // R2, front notch
    tenon_hole(rail_tenon_x, rail_ys[1], tenon_len, rail_t); // R3
    tenon_hole(rail_tenon_x, rail_ys[2], tenon_len, rail_t); // R4
    for (x = riser_tab_xs)                            // tilt riser tab slots
      tenon_hole(x, riser_y, riser_tab_w, riser_t);
    translate([-1, deck_y0 - 1])                      // notch around R2 bridge
      square([r2_block_half + tenon_clearance + 1,
              rail_ys[0] + rail_t / 2 - deck_y0 + tenon_clearance + 1]);
  }
}

module wrist_outline_2d() { // right side: main plate + center front strip
  offset(r = 3) offset(delta = -3)
    union() {
      translate([flap_x, wrist_y0])
        square([wrist_x1 - flap_x, wrist_y1 - wrist_y0]);
      translate([0, wrist_y0])
        square([flap_x + 1, strip_y1 - wrist_y0]);
    }
}

module wrist_base_2d() {
  difference() {
    wrist_outline_2d();
    for (y = wrist_tenon_ys) {
      tenon_hole(rib_xs[3], y, rib_t, tenon_len);     // stop rib, closed holes
      tenon_hole(rib_xs[4], y, rib_t, tenon_len);     // outer rib, closed holes
    }
  }
}

module wrist_2d(right) { // strips meet at x = 0 with a drop-in dovetail
  if (right) {
    union() {
      wrist_base_2d();
      polygon(dt_w);
    }
  } else {
    difference() {
      mirror([1, 0]) wrist_base_2d();
      offset(delta = splice_clearance)
        polygon(dt_w);
    }
  }
}

module wrist_unit_3d(right) {
  s = right ? 1 : -1;
  spec = label_spec(right ? "wrist_r" : "wrist_l");
  difference() {
    union() {
      translate([0, 0, wrist_ledge])
        linear_extrude(wrist_top - wrist_ledge)
          wrist_2d(right);
      scale([s, 1, 1]) {
        translate([2, wrist_y0, 0])                   // front desk wall
          cube([142, wall_y1 - wrist_y0, wrist_ledge + 0.1]);
        translate([2, lip_y0, lip_z0])                // trackpad front lip
          cube([lip_x1 - 2, lip_y1 - lip_y0, wrist_ledge - lip_z0 + 0.1]);
      }
    }
    scale([s, 1, 1])                                  // palm flap relief
      translate([flap_x, strip_y1, wrist_ledge - 0.1])
        cube([tp_half + 1 - flap_x, wrist_y1 - strip_y1 + 1,
              flap_bottom - wrist_ledge + 0.1]);
    translate([spec[2], spec[3], wrist_ledge - 0.1])  // code on the underside
      linear_extrude(label_d + 0.1)
        mirror([1, 0])
          text(spec[1], size = spec[4], font = label_font,
               halign = "center", valign = "center");
  }
}

// ---- printable pieces (2D) ----

module piece_2d(name) {
  if (name == "outer_front") splice_lo(splice_a_y, dt_a) outer_rib_profile();
  else if (name == "outer_rear") splice_hi(splice_a_y, dt_a) outer_rib_profile();
  else if (name == "stop_front") splice_lo(splice_b_y, dt_b) stop_rib_profile();
  else if (name == "stop_rear") splice_hi(splice_b_y, dt_b) stop_rib_profile();
  else if (name == "center") center_rib_profile();
  else if (name == "tpstop_rail") tpstop_rail_profile();
  else if (name == "mid_rail") mid_rail_profile();
  else if (name == "rear_rail") rear_rail_profile();
  else if (name == "riser_r") riser_profile();
  else if (name == "riser_l") mirror([1, 0]) riser_profile();
  else if (name == "wrist_r") wrist_2d(true);
  else if (name == "wrist_l") wrist_2d(false);
  else if (name == "deck_r") deck_plate_2d();
  else if (name == "deck_l") mirror([1, 0]) deck_plate_2d();
}

function piece_t(name) =
  (name == "tpstop_rail" || name == "mid_rail" || name == "rear_rail")
    ? rail_t
  : (name == "riser_r" || name == "riser_l") ? riser_t
  : rib_t;

// ---- engraved piece codes (see README): same letter mates, 1=front, 2=rear ----

label_specs = [
  // name, code, u, v, size, engrave bottom face
  ["outer_front", "A1", -60, 3.5, 4, false],
  ["outer_rear", "A2", 75, 3.7, 4, false],
  ["stop_front", "B1", -60, 3.5, 4, false],
  ["stop_rear", "B2", 50, 3.7, 4, false],
  ["center", "C", 80, 3.7, 4, false],
  ["tpstop_rail", "R2", -45, 3.7, 4, false],
  ["mid_rail", "R3", -60, 3.7, 4, false],
  ["rear_rail", "R4", -60, 3.7, 4, false],
  ["riser_r", str("T", riser_h, "R"), 60, -2.8, 3, false],
  ["riser_l", str("T", riser_h, "L"), -60, -2.8, 3, false],
  ["wrist_r", "WR", 112, -85, 8, true],  // bottom: top face stays clean
  ["wrist_l", "WL", -112, -85, 8, true],
  ["deck_r", "DR", 112, 60, 8, true],
  ["deck_l", "DL", -112, 60, 8, true],
];

function label_spec(name) = [for (s = label_specs) if (s[0] == name) s][0];

module piece_3d(name) {
  if (name == "wrist_r" || name == "wrist_l") {
    wrist_unit_3d(name == "wrist_r");
  } else {
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
}

// ---- assembly ----

module place_y_rib(x) {
  translate([x - rib_t / 2, 0, 0])
    rotate([90, 0, 90])
      children();
}

module place_x_rail(y, t = rail_t) {
  translate([0, y + t / 2, 0])
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
  place_x_rail(rail_ys[0]) piece_3d("tpstop_rail");
  place_x_rail(rail_ys[1]) piece_3d("mid_rail");
  place_x_rail(rail_ys[2]) piece_3d("rear_rail");
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
  piece_3d("wrist_r");
  piece_3d("wrist_l");
}

module risers() {
  if (riser_h > 0)
    translate([0, 0, h_kb]) {
      place_x_rail(riser_y, riser_t) piece_3d("riser_r");
      place_x_rail(riser_y, riser_t) piece_3d("riser_l");
    }
}

module assembly() {
  lattice();
  skins();
  risers();
  %devices();
}

module devices(dz = 0) { // dz lifts the devices for the coplanar-face-free check
  translate([0, deck_y0, h_kb + dz])
    rotate([tilt_a, 0, 0])
      translate([0, keyboard_y - deck_y0, 0])
        device_wedge(keyboard_width, keyboard_depth, keyboard_front_h, keyboard_rear_h);
  translate([0, trackpad_y, dz])
    device_wedge(trackpad_width, trackpad_depth, trackpad_front_h, trackpad_rear_h);
}

// ---- print plates (A1 mini 180 x 180, 1.5 mm spacing) ----

plate1_layout = [
  // name, x, y, rotation, [flip: piece top z, prints upside down]
  ["deck_r", 1.5, -11.4, 0],
  ["tpstop_rail", 89.5, 93.5, 0],
  ["mid_rail", 89.5, 107.6, 0],
  ["rear_rail", 89.5, 121.7, 0],
  ["center", -38.5, 135.8, 0],
];

plate2_layout = [
  ["deck_l", 149, -11.4, 0],
  ["outer_front", 114.5, 93.5, 0],
  ["outer_front", 114.5, 112.6, 0],
  ["stop_front", 114.5, 131.7, 0],
  ["stop_front", 114.5, 150.8, 0],
];

plate3_layout = [
  ["wrist_r", 20.5, -16.3, 0, wrist_top],
  ["outer_rear", -38.5, 101.2, 0],
  ["outer_rear", 32.5, 101.2, 0],
  ["riser_r", -18.5, 132.6, 0],
  ["riser_l", 141, 148.1, 0],
];

plate4_layout = [
  ["wrist_l", 149, -16.3, 0, wrist_top],
  ["stop_rear", -16.4, 101.2, 0],
  ["stop_rear", -16.4, 127.3, 0],
];

module plate_2d(layout) {
  for (p = layout)
    translate([p[1], p[2]]) {
      if (len(p) > 4)
        mirror([0, 1]) rotate(p[3]) piece_2d(p[0]);
      else
        rotate(p[3]) piece_2d(p[0]);
    }
}

module plate_3d(layout) {
  for (p = layout) {
    if (len(p) > 4)
      translate([p[1], p[2], p[4]])
        rotate([180, 0, 0])
          rotate(p[3])
            piece_3d(p[0]);
    else
      translate([p[1], p[2], 0])
        rotate(p[3])
          piece_3d(p[0]);
  }
}

function plate_layout(n) =
  n == 1 ? plate1_layout
  : n == 2 ? plate2_layout
  : n == 3 ? plate3_layout
  : plate4_layout;

// ---- sanity checks ----

assert(h_kb - trackpad_rear_h >= 1.5, "keyboard deck too low over trackpad");
assert(splice_a_y + dt_len - rib_y0 <= 176, "outer rib front piece too long");
assert(rib_y1 - splice_a_y <= 176, "outer rib rear piece too long");
assert(splice_b_y + dt_len - rib_y0 <= 176, "stop rib front piece too long");
assert(rib_y1 - splice_b_y <= 176, "stop rib rear piece too long");
assert(2 * r2_half <= 176, "single-piece rails too long");
assert(deck_x1 <= 176 && deck_y1 - deck_y0 <= 176, "deck plate too big");
assert(wrist_x1 <= 176 && wrist_y1 - wrist_y0 <= 176, "palm unit too big");
assert(rib_xs[4] - rib_t / 2 >= kb_half - 0.01, "outer ribs narrower than keyboard");
assert(rib_xs[3] - rib_t / 2 >= tp_half - 0.01, "stop ribs narrower than trackpad");
assert(rail_ys[2] + rail_t / 2 + tenon_clearance < deck_y1 - 2, "R4 hole breaks deck rear edge");
assert(riser_y + riser_t / 2 + tenon_clearance < deck_y1 - 2, "riser slot breaks deck rear edge");
assert(riser_h == 0 || riser_h >= 2, "riser too thin to print");
assert(flap_x < tp_half - 4 && tp_exposed_d <= trackpad_depth, "bad exposure params");
assert(flap_bottom - tp_h(wrist_y1) >= 1, "palm flap touches the trackpad");
assert(lip_top - (h_kb + riser_h * (deck_y0 - kb_front) / tilt_pivot) >= 2,
       "tilted keyboard rides over the front lip");
assert(riser_h == 0 ||
       side_stop_top - (h_kb + riser_h * (a2_deck_ys[0] - deck_y0) / tilt_pivot) >= 1,
       "tilted keyboard rides over the side stops");
assert(rear_tab_top - (h_kb + riser_h * (kb_rear - deck_y0) / tilt_pivot) >= 2,
       "tilted keyboard rides over the rear tabs");

// empty renders confirm plates fit 178 x 178 and nothing touches the devices
module check_plate_overflow(n) {
  intersection() {
    plate_2d(plate_layout(n));
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
  } else if (part == "check_fit4") {
    check_plate_overflow(4);
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
      union() { // skip the two resting planes (z = 7 and z = 7.6)
        translate([-500, -500, wrist_ledge + 0.05])
          cube([1000, 1000, h_sub - wrist_ledge - 0.1]);
        translate([-500, -500, h_sub + 0.05])
          cube([1000, 1000, 100]);
      }
    }
  } else if (part == "check_riser") { // riser tabs must clear deck and lattice
    intersection() {
      union() {
        lattice();
        skins();
      }
      risers();
      translate([-500, -500, -500]) // deck top is a resting plane, not overlap
        cube([1000, 1000, 500 + h_kb - 0.05]);
    }
  } else if (part == "plate1") {
    plate_3d(plate1_layout);
  } else if (part == "plate2") {
    plate_3d(plate2_layout);
  } else if (part == "plate3") {
    plate_3d(plate3_layout);
  } else if (part == "plate4") {
    plate_3d(plate4_layout);
  } else {
    piece_3d(part);
  }
}

model();
