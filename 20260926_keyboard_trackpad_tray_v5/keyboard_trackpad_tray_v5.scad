// =====================================================================
// keyboard_trackpad_tray v5
// パーツごとに分けて設計する構成。まずは Magic Trackpad 2 の外枠から。
//
// 座標系: トラックパッド底面の手前左角を原点とし、X=幅方向, Y=奥行方向 (奥が +Y)
// 寸法根拠: Magic Trackpad 2: 160 x 114.9 x 4.9-10.9mm (Apple / Wikipedia)
// =====================================================================

/* [表示・出力] */
part = 0; // [0:Assembly, 1:TrackpadFrame]
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
frame_wall = 6;      // 枠の壁厚
frame_top_offset = 0; // 枠天面をトラックパッド天面からどれだけ下げるか (0 で面一)

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

echo(str("トラックパッド外枠: ", frame_w, " x ", frame_d, " mm"));

// トラックパッド天面の高さ (Y 位置の関数、手前→奥へ直線的に高くなる)
function tp_top_z(y) = tp_h_front + (tp_h_rear - tp_h_front) * y / tp_d;

// ---------------------------------------------------------------------
// 部品モジュール
// ---------------------------------------------------------------------

module rrect_2d(x0, y0, w, d, r) {
  translate([x0, y0])
    offset(r = r) offset(delta = -r)
      square([w, d]);
}

module frame_2d() {
  difference() {
    rrect_2d(frame_x0, frame_y0, frame_w, frame_d, frame_r);
    rrect_2d(-margin, -margin, pocket_w, pocket_d, pocket_r);
    translate([tp_port_x - tp_port_cut_w/2, tp_d])
      square([tp_port_cut_w, frame_y1 - tp_d + 1]);
  }
}

// トラックパッド天面の傾きに沿った高さ制限 (X 方向に押し出した側面プロファイル)
module slope_clip(offset_z) {
  y0 = frame_y0 - 1;
  y1 = frame_y1 + 1;
  translate([frame_x0 - 1, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(frame_w + 2)
        polygon([[y0, 0], [y1, 0],
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
    if (show_devices)
      color("white", 0.5) trackpad_dummy();
  } else if (part == 1) {
    trackpad_frame();
  }
}

model();
