// =====================================================================
// keyboard_trackpad_tray v5
// パーツごとに分けて設計する構成: トラックパッド外枠 → 左右リストレスト → キーボード土台 (予定)
//
// 座標系: トラックパッド底面の手前左角を原点とし、X=幅方向, Y=奥行方向 (奥が +Y)
// 寸法根拠: Magic Trackpad 2: 160 x 114.9 x 4.9-10.9mm (Apple / Wikipedia)
// =====================================================================

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [表示・出力] */
// 2, 3 は上下反転した印刷向きで出力する
part = 0; // [0:Assembly, 1:TrackpadFrame, 2:WristRest_L, 3:WristRest_R]
show_devices = true;

/* [デバイス寸法 (実測で微調整可)] */
// 外形 (幅・奥行・高さ) は Lightning 版 (2015/2021) と USB-C 版 (2024) で共通
tp_w = 160.0;
tp_d = 114.4; // 公称 114.9 だが実機では前後に遊びが出るため 0.5mm 短くする
tp_h_front = 4.9;
tp_h_rear = 10.9;
// 天面視のコーナーR (要実測)。2015年 Lightning 版は小さく、2021年以降 (Lightning/USB-C) は大きい。
// ポケットは小さい方に合わせておけば、R の大きい世代も角に隙間ができるだけで収まる
tp_corner_r = 3;

/* [背面の電源スイッチ・充電ポート (要実測)] */
// X はトラックパッド手前から見た左端基準
tp_port_x = tp_w / 2;     // 充電ポート (Lightning / USB-C) は背面中央。上からケーブルを差し込めるよう全高で切り抜く
tp_port_cut_w = 14;       // ケーブルのプラグ根元が通る幅 (USB-C はプラグが太めなので余裕を持たせる)
tp_switch_x = tp_w - 11;  // 電源スイッチは手前から見て右奥
tp_switch_cut_w = 12;     // 指でスイッチを操作できる幅
tp_switch_cut_z = 2;      // スイッチ用切り欠きの下に残す壁の高さ (ポート切り欠きとの間の奥壁を分離させないため)

/* [トラックパッド外枠] */
margin = 0.5;        // トラックパッド周囲の遊び (片側)
frame_wall = 7;      // 枠の壁厚 (ダブテール溝を切っても内側に 2mm 以上残す)
frame_top_offset = 0; // 枠天面をトラックパッド天面からどれだけ下げるか (0 で面一)

/* [リストレスト] */
tray_w = 286;          // トレイ全幅 (キーボード土台と揃える予定。Magic Keyboard 279mm + 余裕、v4 と同じ)
rest_h = 15;           // 天面高さ (天面はフラット。上下反転で印刷するため)
rest_tp_cover = 20;    // トラックパッド左右端を覆う量
rest_tp_gap = 1;       // 覆い部分の下面とトラックパッド天面の隙間
rest_chamfer_d = 20;   // 内側奥の斜めカットの Y 方向長さ (奥端で覆い量 0 になる)
rest_top_chamfer = 1.5; // 天面エッジの面取り (反転印刷でベッド側になるので R ではなく 45°)
rest_corner_r = 4;     // 手前外側コーナーR

/* [ダブテール (リストレスト側が凸、枠の外側面が溝。上から差し込む)] */
dt_root_w = 8;       // 付け根 (枠外側面上) の幅
dt_tip_w = 11;       // 先端の幅
dt_depth = 4.5;      // 枠への食い込み量
dt_clearance = 0.2;  // 溝側のクリアランス (片側)
dt_y_ratios = [0.45, 0.8]; // 枠奥行に対する位置。手前は枠が低いので避ける

$fn = 64;

// ---------------------------------------------------------------------
// 派生値 (後続パーツから参照する)
// ---------------------------------------------------------------------
pocket_w = tp_w + 2*margin;
pocket_d = tp_d + 2*margin;
pocket_r = tp_corner_r + margin;
frame_r = pocket_r + frame_wall;
frame_x0 = -margin - frame_wall;
frame_x1 = tp_w + margin + frame_wall;
frame_y0 = -margin - frame_wall;
frame_y1 = tp_d + margin + frame_wall;
frame_w = frame_x1 - frame_x0;
frame_d = frame_y1 - frame_y0;

rest_side_w = (tray_w - frame_w) / 2; // 枠より外側のリストレスト幅
rest_x_out = frame_x0 - rest_side_w;  // 左リストレスト外側端
dt_ys = [for (r = dt_y_ratios) frame_y0 + frame_d * r];

// トラックパッド天面の高さ (Y 位置の関数、手前→奥へ直線的に高くなる)
function tp_top_z(y) = tp_h_front + (tp_h_rear - tp_h_front) * y / tp_d;

rest_lip_min_t = rest_h - (tp_top_z(frame_y1) + rest_tp_gap); // 覆い部分の最薄 (奥端)

echo(str("トラックパッド外枠: ", frame_w, " x ", frame_d, " mm"));
echo(str("リストレスト (片側): ", rest_side_w + frame_wall + margin + rest_tp_cover, " x ", frame_d,
         " x ", rest_h, " mm / 覆い部分の最薄 ", rest_lip_min_t, " mm"));
echo(str("トレイ全幅: ", tray_w, " mm"));
assert(frame_w <= 180, "外枠が A1 mini のベッド (180mm) に収まらない");
assert(rest_lip_min_t >= 1.5, "覆い部分が薄すぎる。rest_h を上げること");
assert(frame_wall - dt_depth - dt_clearance >= 1, "ダブテール溝と枠内側の間の肉が 1mm 未満");

// ---------------------------------------------------------------------
// 部品モジュール
// ---------------------------------------------------------------------

module rrect_2d(x0, y0, w, d, r) {
  translate([x0, y0])
    offset(r = r) offset(delta = -r)
      square([w, d]);
}

module frame_outer_2d() {
  rrect_2d(frame_x0, frame_y0, frame_w, frame_d, frame_r);
}

// 左側面のダブテール凸 (枠外側面 x=frame_x0 から枠内へ食い込む)
module dovetail_left_2d() {
  for (y = dt_ys)
    polygon([[frame_x0 - 1, y - dt_root_w/2], [frame_x0, y - dt_root_w/2],
             [frame_x0 + dt_depth, y - dt_tip_w/2], [frame_x0 + dt_depth, y + dt_tip_w/2],
             [frame_x0, y + dt_root_w/2], [frame_x0 - 1, y + dt_root_w/2]]);
}

module mirror_lr() {
  translate([tp_w, 0]) mirror([1, 0]) children();
}

module frame_2d() {
  difference() {
    frame_outer_2d();
    rrect_2d(-margin, -margin, pocket_w, pocket_d, pocket_r);
    translate([tp_port_x - tp_port_cut_w/2, tp_d])
      square([tp_port_cut_w, frame_y1 - tp_d + 1]);
    offset(delta = dt_clearance) {
      dovetail_left_2d();
      mirror_lr() dovetail_left_2d();
    }
  }
}

// トラックパッド天面の傾きに沿った高さ制限 (X 方向に押し出した側面プロファイル)
module slope_clip(offset_z) {
  y0 = frame_y0 - 1;
  y1 = frame_y1 + 1;
  translate([rest_x_out - 1, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(tray_w + 2)
        polygon([[y0, -1], [y1, -1],
                 [y1, tp_top_z(y1) - offset_z], [y0, tp_top_z(y0) - offset_z]]);
}

module trackpad_frame() {
  difference() {
    intersection() {
      linear_extrude(tp_h_rear + 1) frame_2d();
      slope_clip(frame_top_offset);
    }
    translate([tp_switch_x - tp_switch_cut_w/2, tp_d, tp_switch_cut_z])
      cube([tp_switch_cut_w, frame_y1 - tp_d + 1, tp_h_rear + 2]);
  }
}

module wrist_rest_left() {
  footprint = round_corners(
    [[rest_x_out, frame_y0], [rest_tp_cover, frame_y0],
     [rest_tp_cover, frame_y1 - rest_chamfer_d], [0, frame_y1], [rest_x_out, frame_y1]],
    r = [rest_corner_r, 2, 2, 0, 0]);
  difference() {
    offset_sweep(footprint, height = rest_h, top = os_chamfer(width = rest_top_chamfer));
    // 枠とトラックパッドの上を覆う部分の下側をくり抜く (ダブテール凸は残す)
    intersection() {
      translate([0, 0, -1])
        linear_extrude(rest_h)
          difference() {
            offset(delta = dt_clearance) frame_outer_2d();
            dovetail_left_2d();
          }
      slope_clip(-rest_tp_gap);
    }
  }
}

// side = -1:左, 1:右 (組立位置)
module wrist_rest(side) {
  difference() {
    if (side < 0)
      wrist_rest_left();
    else
      mirror_lr() wrist_rest_left();
    // 電源スイッチ操作用に、枠の切り欠きの上を覆わない
    translate([tp_switch_x - tp_switch_cut_w/2, tp_d, -1])
      cube([tp_switch_cut_w, frame_y1 - tp_d + 1, rest_h + 2]);
  }
}

// 天面をベッドに付ける向き (Y 軸回りに 180° 回転。mirror だと左右が入れ替わるので不可)
// x_max: 組立位置での X 最大値 (反転後に X 最小が 0 になるよう寄せる)
module print_flipped(x_max) {
  translate([x_max, -frame_y0, rest_h]) rotate([0, 180, 0]) children();
}

module trackpad_dummy() {
  intersection() {
    linear_extrude(tp_h_rear)
      offset(r = tp_corner_r) offset(delta = -tp_corner_r)
        square([tp_w, tp_d]);
    slope_clip(0);
  }
}

module model() {
  if (part == 0) {
    trackpad_frame();
    color("lightblue") {
      wrist_rest(-1);
      wrist_rest(1);
    }
    if (show_devices)
      color("white", 0.5) trackpad_dummy();
  } else if (part == 1) {
    trackpad_frame();
  } else if (part == 2) {
    print_flipped(rest_tp_cover) wrist_rest(-1);
  } else if (part == 3) {
    print_flipped(tp_w - rest_x_out) wrist_rest(1);
  }
}

model();
