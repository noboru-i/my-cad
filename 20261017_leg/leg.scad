// 箱型の物を左右2本で支える足
// 天面のコの字壁で載せた物の長辺方向・短辺方向のズレを止める。中央側は開放。
// 柱は中空にし、4面の壁に菱形の窓を開けてフィラメントを節約する。
// 窓の上辺・内部天井はすべて45°なので、サポートなしで造形できる。
//
// 座標系: 足1本の外側端 (コの字の閉じた側) の手前下角を原点とし、
//   X=載せる物の長辺方向 (+Xが中央側), Y=短辺方向, Z=上

/* [出力] */
// pair は左右2本を向かい合わせて A1 mini のプレートに並べた印刷用配置。左右の足は同一形状
part = "pair"; // [pair:2本並べて印刷, leg:1本, assembled:組立確認]

/* [載せる物の底面 mm] */
// 長辺 (足と足の間隔を決める)
item_length = 290; // [100:1:600]
// 短辺
item_width = 48; // [20:0.5:150]
// 載せる物とコの字壁の隙間 (片側)
clearance = 0.5; // [0:0.1:2]

/* [足の寸法 mm] */
// 床から載せる物の底面までの高さ
leg_height = 90; // [20:1:150]
// 長辺方向に支える長さ (コの字壁を含む)
leg_length = 50; // [20:1:80]

/* [ズレ止めの壁 mm] */
guide_height = 10; // [0:1:30]
guide_thickness = 3; // [1.2:0.2:8]

/* [構造 mm] */
// 柱の壁厚
shell_thickness = 2; // [1.2:0.2:5]
// 天板の厚さ
top_thickness = 3; // [1.2:0.2:8]
// 底面の外周に張り出すフランジ幅 (ベッドから剥がれやすい場合に使う。0で無し)
foot_flange = 0; // [0:0.5:10]

/* [菱形窓] */
windows = true;
// 菱形の対角長
window_size = 14; // [6:1:40]
// 窓と窓の間に残す桟の幅
window_strut = 4; // [2:0.5:10]
// 柱の角・下端・天井の立ち上がりから窓までの余白
window_edge = 5; // [2:0.5:15]

/* [Hidden] */
eps = 0.01;
pair_gap = 10;
plate_size = 180;  // A1 mini のビルドプレート
flange_thickness = 1;
item_preview_height = 40;

outer_w = item_width + clearance * 2 + guide_thickness * 2;
ceiling_z = leg_height - top_thickness;
in_x = leg_length - shell_thickness * 2;
in_y = outer_w - shell_thickness * 2;
// 内部天井は45°の寄棟にし、天板の下面をブリッジなしで支える
roof_h = min(in_x, in_y) / 2;
roof_start_z = ceiling_z - roof_h;
ridge_x = max(in_x - roof_h * 2, eps);
ridge_y = max(in_y - roof_h * 2, eps);

window_pitch = window_size + window_strut * sqrt(2);
window_margin = max(window_edge, shell_thickness + 1);
window_z_lo = window_edge + (foot_flange > 0 ? flange_thickness : 0);
window_z_hi = min(roof_start_z, ceiling_z) - window_edge;

module diamond_prism(depth) {
  rotate([90, 0, 0])
    linear_extrude(height = depth, center = true)
      polygon([
        [0, -window_size / 2],
        [window_size / 2, 0],
        [0, window_size / 2],
        [-window_size / 2, 0]
      ]);
}

// 幅face_wの面に、千鳥配置の菱形窓を並べる (面の左端がu=0、厚さ方向は中央)
module window_pattern(face_w, depth) {
  avail_u = face_w - window_margin * 2;
  avail_z = window_z_hi - window_z_lo;
  n_a = avail_u >= window_size ? floor((avail_u - window_size) / window_pitch) + 1 : 0;
  n_b = n_a - 1;
  rows_raw = avail_z >= window_size ? floor((avail_z - window_size) / (window_pitch / 2)) + 1 : 0;
  // 千鳥の偶数行に窓が入らない場合は、最終行が奇数行で終わるよう揃える
  n_rows = n_b > 0 ? rows_raw : (rows_raw > 0 ? floor((rows_raw - 1) / 2) * 2 + 1 : 0);
  span_z = window_size + (n_rows - 1) * window_pitch / 2;
  z0 = window_z_lo + (avail_z - span_z) / 2 + window_size / 2;
  if (n_a > 0 && n_rows > 0) {
    for (j = [0:n_rows - 1]) {
      n = j % 2 == 0 ? n_a : n_b;
      if (n > 0) {
        for (i = [0:n - 1]) {
          translate([face_w / 2 + (i - (n - 1) / 2) * window_pitch, 0, z0 + j * window_pitch / 2])
            diamond_prism(depth);
        }
      }
    }
  }
}

module inner_void() {
  intersection() {
    translate([shell_thickness, shell_thickness, -1])
      cube([in_x, in_y, ceiling_z + 1]);
    hull() {
      translate([shell_thickness, shell_thickness, min(roof_start_z, -1)])
        cube([in_x, in_y, eps]);
      translate([shell_thickness, shell_thickness, roof_start_z])
        cube([in_x, in_y, eps]);
      translate([leg_length / 2 - ridge_x / 2, outer_w / 2 - ridge_y / 2, ceiling_z - eps])
        cube([ridge_x, ridge_y, eps]);
    }
  }
}

module guide_walls() {
  if (guide_height > 0) {
    translate([0, 0, leg_height]) {
      cube([guide_thickness, outer_w, guide_height]);
      cube([leg_length, guide_thickness, guide_height]);
      translate([0, outer_w - guide_thickness, 0])
        cube([leg_length, guide_thickness, guide_height]);
    }
  }
}

module leg() {
  difference() {
    union() {
      cube([leg_length, outer_w, leg_height]);
      if (foot_flange > 0) {
        translate([-foot_flange, -foot_flange, 0])
          cube([leg_length + foot_flange * 2, outer_w + foot_flange * 2, flange_thickness]);
      }
    }
    inner_void();
    if (windows) {
      // 短辺側の面 (外側端と中央側)。窓は柱を貫通させ、両面を同時に抜く
      translate([leg_length / 2, 0, 0])
        rotate([0, 0, 90])
          window_pattern(outer_w, leg_length + foot_flange * 2 + 2);
      // 長辺側の面
      translate([0, outer_w / 2, 0])
        window_pattern(leg_length, outer_w + foot_flange * 2 + 2);
    }
  }
  guide_walls();
}

module model() {
  if (part == "leg") {
    leg();
  } else if (part == "assembled") {
    // 左右の足は同一形状。右側は中央側に向けて鏡映配置する
    x_outer = item_length / 2 + clearance + guide_thickness;
    translate([-x_outer, -outer_w / 2, 0])
      leg();
    mirror([1, 0, 0])
      translate([-x_outer, -outer_w / 2, 0])
        leg();
    %translate([-item_length / 2, -item_width / 2, leg_height])
      cube([item_length, item_width, item_preview_height]);
  }
}

// pair は A1 mini のプレート中央に、コの字の開いた側を向かい合わせて並べる
// --enable=lazy-union で 3MF に出すと足ごとに別オブジェクトになるよう、トップレベルに並べる
pair_pitch = leg_length + foot_flange * 2 + pair_gap;
pair_x0 = plate_size / 2 - (pair_pitch + leg_length) / 2;
pair_y0 = plate_size / 2 - outer_w / 2;
if (part == "pair") {
  translate([pair_x0, pair_y0, 0])
    leg();
  translate([pair_x0 + pair_pitch + leg_length, pair_y0 + outer_w, 0])
    rotate([0, 0, 180])
      leg();
}

model();
