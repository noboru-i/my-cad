// =====================================================================
// keyboard_trackpad_tray v5
// パーツごとに分けて設計する構成: トラックパッド外枠 → 左右リストレスト → キーボード土台 (左右分割)
//
// 座標系: トラックパッド底面の手前左角を原点とし、X=幅方向, Y=奥行方向 (奥が +Y)
// 寸法根拠:
//   Magic Trackpad 2: 160 x 114.9 x 4.9-10.9mm (Apple / Wikipedia)
//   Magic Keyboard  : 279 x 114.9 x 4.1-10.9mm (Apple / Wikipedia)
// =====================================================================

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [表示・出力] */
// 2, 3 は上下反転した印刷向きで出力する。6 は組立状態の確認用 (ダミーなし、印刷用ではない)
// 7 は A1 mini の 1 プレートに全パーツを並べた印刷用 (--enable=lazy-union で 3MF に出すとパーツごとに別オブジェクトになる)
part = 0; // [0:Assembly, 1:TrackpadFrame, 2:WristRest_L, 3:WristRest_R, 4:KeyboardBase_L, 5:KeyboardBase_R, 6:AssembledSTL, 7:PrintPlate]
show_devices = true;

/* [デバイス寸法 (実測で微調整可)] */
// 外形 (幅・奥行・高さ) は Lightning 版 (2015/2021) と USB-C 版 (2024) で共通
tp_w = 160.0;
tp_d = 114.2; // 公称 114.9 だが実機では前後に遊びが出るため 0.7mm 短くする
tp_h_front = 4.9;
tp_h_rear = 10.9;
// 天面視のコーナーR (要実測)。2015年 Lightning 版は小さく、2021年以降 (Lightning/USB-C) は大きい。
// ポケットは小さい方に合わせておけば、R の大きい世代も角に隙間ができるだけで収まる
tp_corner_r = 3;
kb_w = 279.0;
kb_d = 114.2; // 公称 114.9 だが実機では前後に遊びが出るため 0.7mm 短くする
kb_h_front = 4.1;
kb_h_rear = 10.9;

/* [背面の電源スイッチ・充電ポート (要実測)] */
// X はトラックパッド手前から見た左端基準
tp_port_x = tp_w / 2;     // 充電ポート (Lightning / USB-C) は背面中央。ケーブルを挿したまま枠を上から被せられるよう下から切り抜く
tp_port_cut_w = 14;       // ケーブルのプラグ根元が通る幅 (USB-C はプラグが太めなので余裕を持たせる)
tp_switch_x = tp_w - 11;  // 電源スイッチは手前から見て右奥
tp_switch_cut_w = 12;     // 指でスイッチを操作できる幅
tp_switch_cut_z = 2;      // スイッチ用切り欠きの下に残す壁の高さ (ポート切り欠きとの間の奥壁を分離させないため)
tp_port_bridge_t = 2;     // ポート切り欠きの上に残すブリッジの厚さ (枠をリング状につなげる)。切り欠きの高さは奥壁の天面からこの分を引いた値
// X はキーボード手前から見た左端基準。奥壁をこの範囲だけ載置面まで切り欠く
kb_port_x = kb_w / 2;     // 充電ポート (Lightning / USB-C) は背面中央
kb_port_cut_w = 24;
kb_switch_x = kb_w - 15;  // 電源スイッチは手前から見て右奥 (右端からの距離は要実測)
kb_switch_cut_w = 20;

/* [トラックパッド外枠] */
margin = 0.5;        // デバイス周囲の遊び (片側)
frame_wall = 7;      // 枠の壁厚 (ダブテール溝を切っても内側に 2mm 以上残す)
frame_top_offset = 0; // 枠天面をトラックパッド天面からどれだけ下げるか (0 で面一)

/* [リストレスト] */
tray_w = 286;          // トレイ全幅 (Magic Keyboard 279mm + 遊び + 左右リブ)
rest_h = 15;           // 奥端の天面高さ (天面はトラックパッドと同じ傾斜で手前が下がる)
rest_tp_cover = 20;    // トラックパッド左右端を覆う量
rest_tp_gap = 1;       // 覆い部分の下面とトラックパッド天面の隙間
rest_chamfer_d = 20;   // 内側奥の斜めカットの Y 方向長さ (奥端で覆い量 0 になる)
rest_top_chamfer = 1.5; // 天面エッジの面取り (反転印刷でベッド側になるので R ではなく 45°)
rest_corner_r = 4;     // 手前外側コーナーR

/* [キーボード土台] */
// キーボード手前端がトラックパッド奥端に重なる量。
// 枠↔リストレストの奥側ダブテール (y≒96) をリストレストに残すため、約 11mm が上限
kb_tp_overlap = 11;
kb_front_stop_h = 2.5; // リストレスト奥面が載置面から立ち上がる高さ (キーボード手前のストッパー)
kb_corner_r = 4;       // 奥側外側コーナーR
kb_split_x = tp_port_x + 25; // 左右分割位置 (ケーブル溝を避ける)
kb_cable_w = 16;       // トラックパッドのケーブルを背面へ通す溝 (底面側) の天井の幅
kb_cable_h = 8;        // 同 高さ (側面は 45° で底面に向かって広がるので、立てて印刷してもサポート不要)

/* [ダブテール] */
// 枠↔リストレスト: リストレスト側が凸、枠の外側面が溝 (上から差し込む)
// リストレスト↔土台: 土台側が凸、リストレスト側が下から開いた止まり溝
// 土台 左↔右: 右側が凸、左側が溝
// 枠↔土台: 枠の奥面が凸、土台側が全高の溝 (枠の奥壁を溝で細くしないため)
dt_root_w = 8;       // 付け根の幅
dt_tip_w = 11;       // 先端の幅
dt_depth = 4.5;      // 食い込み量
dt_clearance = 0.2;  // 溝側のクリアランス (片側)
dt_y_ratios = [0.45, 0.8]; // 枠↔リストレストの位置 (枠奥行比)。手前は枠が低いので避ける
dt_rest_x_ratios = [0.3, 0.75]; // リストレスト↔土台の位置 (枠より外側のリストレスト幅比)
dt_seam_y_ratios = [0.3, 0.7];  // 土台 左↔右の位置 (継ぎ目の長さ比)

/* [印刷プレート (part=7)] */
plate_size = 180;  // A1 mini のビルドプレート
plate_margin = 2.5; // 枠とプレート端の距離

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
tray_x1 = rest_x_out + tray_w;        // 右リストレスト外側端
dt_ys = [for (r = dt_y_ratios) frame_y0 + frame_d * r];

kb_front_y = tp_d - kb_tp_overlap;    // キーボード手前端
rest_y1 = kb_front_y - margin;        // リストレスト奥端
kb_lip_w = (tray_w - kb_w) / 2 - margin;
kb_base_h = rest_h - kb_front_stop_h;        // キーボード載置面の高さ
kb_base_y0 = rest_y1 + dt_clearance;  // 土台手前端 (リストレストの奥)
kb_base_y1 = kb_front_y + kb_d + margin + kb_lip_w;
kb_seam_y0 = frame_y1 + dt_clearance; // 継ぎ目の手前端 (枠の奥)
kb_x0 = tp_w/2 - kb_w/2;              // キーボード左端
kb_total_h = kb_base_h + kb_h_rear;   // 土台の奥の壁の天面高さ
dt_rest_xs = [for (r = dt_rest_x_ratios) rest_x_out + rest_side_w * r];
dt_seam_ys = [for (r = dt_seam_y_ratios) kb_seam_y0 + (kb_base_y1 - kb_seam_y0) * r];
// 枠↔土台の位置: 左は枠奥辺の直線部左端〜ポート切り欠き、右は継ぎ目〜スイッチ切り欠きの中央
dt_frame_base_xs = [(frame_x0 + frame_r + tp_port_x - tp_port_cut_w/2) / 2,
                    (kb_split_x + tp_switch_x - tp_switch_cut_w/2) / 2];

// トラックパッド天面の高さ (Y 位置の関数、手前→奥へ直線的に高くなる)
tp_slope = (tp_h_rear - tp_h_front) / tp_d;
function tp_top_z(y) = tp_h_front + tp_slope * y;
// リストレスト天面の高さ (トラックパッド天面と平行)
function rest_top_z(y) = rest_h + tp_slope * (y - rest_y1);
// キーボード天面の高さ (キーボード奥端より奥は最大高さで一定)
function kb_top_z(y) = kb_base_h + min(kb_h_rear, kb_h_front + (kb_h_rear - kb_h_front) * (y - kb_front_y) / kb_d);

rest_lip_t = rest_top_z(rest_y1) - (tp_top_z(rest_y1) + rest_tp_gap); // 覆い部分の厚さ (天面と平行なので一定)
kb_frame_gap = kb_base_h - tp_top_z(frame_y1); // キーボード底面と枠奥端天面の隙間
tp_port_cut_h = tp_top_z(tp_d) - frame_top_offset - tp_port_bridge_t; // 枠のポート切り欠きの高さ (床から)

echo(str("トラックパッド外枠: ", frame_w, " x ", frame_d, " mm / ポート切り欠き ", tp_port_cut_w, " x 高さ ", tp_port_cut_h, " mm"));
echo(str("リストレスト (片側): ", rest_side_w + frame_wall + margin + rest_tp_cover, " x ", rest_y1 - frame_y0,
         " x ", rest_top_z(frame_y0), "-", rest_h, " mm / 覆い部分の厚さ ", rest_lip_t, " mm"));
echo(str("キーボード土台: 左 ", kb_split_x - rest_x_out, " / 右 ", tray_x1 - kb_split_x,
         " x ", kb_base_y1 - kb_base_y0, " x ", kb_base_h, " mm / キーボード底面と枠の隙間 ", kb_frame_gap, " mm"));
echo(str("トレイ全体: ", tray_w, " x ", kb_base_y1 - frame_y0, " mm"));
assert(frame_w <= 180, "外枠が A1 mini のベッド (180mm) に収まらない");
assert(rest_lip_t >= 1.5, "覆い部分が薄すぎる。rest_h を上げること");
assert(frame_wall - dt_depth - dt_clearance >= 1, "ダブテール溝と枠内側の間の肉が 1mm 未満");
assert(rest_y1 >= dt_ys[len(dt_ys) - 1] + dt_tip_w/2 + 1, "リストレスト奥端が枠↔リストレストのダブテールにかかる。kb_tp_overlap を減らすこと");
assert(kb_frame_gap >= 1, "キーボード底面が枠に近すぎる。rest_h を上げるか kb_front_stop_h を下げること");
assert(max(kb_split_x - rest_x_out, tray_x1 - kb_split_x + dt_depth) <= 180, "キーボード土台の片側が 180mm を超える");
assert(abs(kb_split_x - tp_port_x) - (kb_cable_w/2 + kb_cable_h) - dt_depth - dt_clearance >= 1, "継ぎ目がケーブル溝に近すぎる");
dt_half_gap = dt_tip_w/2 + dt_clearance + 1; // 枠↔土台ダブテールの中心から周囲に確保する幅
assert(dt_frame_base_xs[0] - dt_half_gap >= frame_x0 + frame_r
       && dt_frame_base_xs[0] + dt_half_gap <= tp_port_x - tp_port_cut_w/2, "枠↔土台 (左) のダブテールが枠の角かポート切り欠きにかかる");
assert(dt_frame_base_xs[1] - dt_half_gap >= kb_split_x
       && dt_frame_base_xs[1] + dt_half_gap <= tp_switch_x - tp_switch_cut_w/2, "枠↔土台 (右) のダブテールが継ぎ目かスイッチ切り欠きにかかる");

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

// ダブテール凸: 付け根 p から angle 方向へ dt_depth 食い込む
module dovetail_2d(p, angle) {
  translate(p) rotate(angle)
    polygon([[-1, -dt_root_w/2], [0, -dt_root_w/2],
             [dt_depth, -dt_tip_w/2], [dt_depth, dt_tip_w/2],
             [0, dt_root_w/2], [-1, dt_root_w/2]]);
}

// 枠↔左リストレスト (枠外側面 x=frame_x0 から枠内へ)
module dovetail_left_2d() {
  for (y = dt_ys) dovetail_2d([frame_x0, y], 0);
}

// 左リストレスト↔土台 (土台手前面 y=kb_base_y0 からリストレストへ)
module dovetail_rest_base_left_2d() {
  for (x = dt_rest_xs) dovetail_2d([x, kb_base_y0], -90);
}

// 土台 左↔右 (継ぎ目 x=kb_split_x から左土台へ)
module dovetail_seam_2d() {
  for (y = dt_seam_ys) dovetail_2d([kb_split_x, y], 180);
}

// 枠↔土台 (枠奥面 y=frame_y1 から土台へ)
module dovetail_frame_base_2d() {
  for (x = dt_frame_base_xs) dovetail_2d([x, frame_y1], 90);
}

module mirror_lr() {
  translate([tp_w, 0]) mirror([1, 0]) children();
}

module frame_2d() {
  difference() {
    frame_outer_2d();
    rrect_2d(-margin, -margin, pocket_w, pocket_d, pocket_r);
    offset(delta = dt_clearance) {
      dovetail_left_2d();
      mirror_lr() dovetail_left_2d();
    }
  }
  dovetail_frame_base_2d();
}

// YZ 平面の側面プロファイルをトレイ全幅にわたって X 方向に押し出す
module x_extrude_profile(points) {
  translate([rest_x_out - 1, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(tray_w + 2)
        polygon(points);
}

// トラックパッド天面の傾きに沿った高さ制限 (枠↔土台ダブテールの凸まで含める)
module slope_clip(offset_z) {
  y0 = frame_y0 - 1;
  y1 = frame_y1 + dt_depth + 1;
  x_extrude_profile([[y0, -1], [y1, -1],
                     [y1, tp_top_z(y1) - offset_z], [y0, tp_top_z(y0) - offset_z]]);
}

// キーボード天面に沿った高さ制限
module kb_slope_clip() {
  y0 = kb_base_y0 - 1;
  y_rear = kb_front_y + kb_d;
  y1 = kb_base_y1 + 1;
  x_extrude_profile([[y0, -1], [y1, -1],
                     [y1, kb_top_z(y1)], [y_rear, kb_top_z(y_rear)], [y0, kb_top_z(y0)]]);
}

module trackpad_frame() {
  difference() {
    intersection() {
      linear_extrude(tp_h_rear + 1) frame_2d();
      slope_clip(frame_top_offset);
    }
    translate([tp_port_x - tp_port_cut_w/2, tp_d, -1])
      cube([tp_port_cut_w, frame_y1 - tp_d + 1, tp_port_cut_h + 1]);
    translate([tp_switch_x - tp_switch_cut_w/2, tp_d, tp_switch_cut_z])
      cube([tp_switch_cut_w, frame_y1 - tp_d + 1, tp_h_rear + 2]);
  }
}

module wrist_rest_left() {
  // 奥端はキーボードのストッパーになるので面取りしない (奥へ延ばして掃引し、rest_y1 で平らに切る)
  ext = rest_top_chamfer + 1;
  footprint = round_corners(
    [[rest_x_out, frame_y0], [rest_tp_cover, frame_y0],
     [rest_tp_cover, rest_y1 - rest_chamfer_d], [0, rest_y1], [0, rest_y1 + ext], [rest_x_out, rest_y1 + ext]],
    r = [rest_corner_r, 2, 2, 0, 0, 0]);
  rest_w = rest_side_w + frame_wall + margin + rest_tp_cover;
  // 天面を傾けるため Z 方向にせん断する (側面は垂直のまま、天面の面取りも残る)。底面は z=0 で平らに切る
  shear = [[1, 0, 0, 0], [0, 1, 0, 0], [0, tp_slope, 1, -tp_slope * rest_y1], [0, 0, 0, 1]];
  difference() {
    intersection() {
      multmatrix(shear) down(1)
        vnf_polyhedron(vnf_triangulate(
          offset_sweep(footprint, height = rest_h + 1,
                       top = os_chamfer(width = rest_top_chamfer))
        ));
      translate([rest_x_out - 1, frame_y0 - 1, 0])
        cube([rest_w + 2, rest_y1 - frame_y0 + ext + 2, rest_h + 2]);
    }
    translate([rest_x_out - 1, rest_y1, -1])
      cube([rest_w + 2, ext + 1, rest_h + 3]);
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
    // 土台側ダブテールの止まり溝 (下から差し込む)
    translate([0, 0, -1])
      linear_extrude(kb_base_h + dt_clearance + 1)
        offset(delta = dt_clearance) dovetail_rest_base_left_2d();
  }
}

// side = -1:左, 1:右 (組立位置)
module wrist_rest(side) {
  if (side < 0)
    wrist_rest_left();
  else
    mirror_lr() wrist_rest_left();
}

// 天面をベッドに付ける向き: 奥端の天面エッジを軸に傾きを戻して天面を水平にし、Y 軸回りに 180° 回転する
// (mirror だと左右が入れ替わるので不可)
// x_max: 組立位置での X 最大値 (反転後に X 最小が 0 になるよう寄せる)
module print_flipped(x_max) {
  a = atan(tp_slope);
  translate([x_max, rest_y1 - frame_y0 + rest_h * sin(a), 0])
    rotate([0, 180, 0]) rotate([-a, 0, 0])
      translate([0, -rest_y1, -rest_h]) children();
}

module keyboard_base_2d() {
  difference() {
    union() {
      difference() {
        translate([rest_x_out, kb_base_y0])
          square([tray_w, kb_base_y1 - kb_base_y0]);
        offset(delta = dt_clearance) frame_outer_2d();
      }
      dovetail_rest_base_left_2d();
      mirror_lr() dovetail_rest_base_left_2d();
    }
    offset(delta = dt_clearance) dovetail_frame_base_2d();
    // 奥側外側コーナーR
    for (x = [rest_x_out, tray_x1])
      translate([x, kb_base_y1])
        difference() {
          square(2 * kb_corner_r, center = true);
          translate([x < tp_port_x ? kb_corner_r : -kb_corner_r, -kb_corner_r]) circle(r = kb_corner_r);
        }
  }
}

// キーボード周囲の壁 (左右は全長、奥は充電ポートと電源スイッチ以外)
module keyboard_walls_2d() {
  intersection() {
    difference() {
      union() {
        for (x = [rest_x_out, tray_x1 - kb_lip_w])
          translate([x, kb_base_y0])
            square([kb_lip_w, kb_base_y1 - kb_base_y0]);
        translate([rest_x_out, kb_base_y1 - kb_lip_w])
          square([tray_w, kb_lip_w]);
      }
      for (c = [[kb_port_x, kb_port_cut_w], [kb_switch_x, kb_switch_cut_w]])
        translate([kb_x0 + c[0] - c[1]/2, kb_base_y1 - kb_lip_w - 1])
          square([c[1], kb_lip_w + 2]);
    }
    keyboard_base_2d();
  }
}

module keyboard_base() {
  difference() {
    union() {
      linear_extrude(kb_base_h) keyboard_base_2d();
      intersection() {
        translate([0, 0, kb_base_h - 0.01])
          linear_extrude(kb_h_rear + 0.01) keyboard_walls_2d();
        kb_slope_clip();
      }
    }
    // トラックパッドのケーブルを背面へ通す溝 (枠のポート切り欠きの奥)
    translate([tp_port_x, kb_base_y1 + 1, 0])
      rotate([90, 0, 0])
        linear_extrude(kb_base_y1 - kb_base_y0 + 2)
          polygon([[-(kb_cable_w/2 + kb_cable_h + 1), -1], [kb_cable_w/2 + kb_cable_h + 1, -1],
                   [kb_cable_w/2, kb_cable_h], [-kb_cable_w/2, kb_cable_h]]);
  }
}

// side = -1:左, 1:右 (組立位置)
module keyboard_base_half(side) {
  big = 1000;
  if (side < 0) {
    difference() {
      intersection() {
        keyboard_base();
        translate([-big, -big, -1]) cube([big + kb_split_x, 2 * big, big]);
      }
      translate([0, 0, -1])
        linear_extrude(kb_base_h + kb_h_rear + 2)
          offset(delta = dt_clearance) dovetail_seam_2d();
    }
  } else {
    intersection() {
      keyboard_base();
      translate([kb_split_x, -big, -1]) cube([big, 2 * big, big]);
    }
    linear_extrude(kb_base_h) dovetail_seam_2d();
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

module keyboard_dummy() {
  translate([kb_x0, 0, kb_base_h])
    rotate([90, 0, 90])
      linear_extrude(kb_w)
        polygon([[kb_front_y, 0], [kb_front_y + kb_d, 0],
                 [kb_front_y + kb_d, kb_h_rear], [kb_front_y, kb_h_front]]);
}

module assembled_parts() {
  trackpad_frame();
  color("lightblue") {
    wrist_rest(-1);
    wrist_rest(1);
  }
  color("khaki") {
    keyboard_base_half(-1);
    keyboard_base_half(1);
  }
}

module model() {
  if (part == 0) {
    assembled_parts();
    if (show_devices) {
      color("white", 0.5) trackpad_dummy();
      color("silver", 0.5) keyboard_dummy();
    }
  } else if (part == 1) {
    trackpad_frame();
  } else if (part == 2) {
    print_flipped(rest_tp_cover) wrist_rest(-1);
  } else if (part == 3) {
    print_flipped(tp_w - rest_x_out) wrist_rest(1);
  } else if (part == 4) {
    translate([-rest_x_out, -(kb_base_y0 - dt_depth), 0]) keyboard_base_half(-1);
  } else if (part == 5) {
    translate([-(kb_split_x - dt_depth), -(kb_base_y0 - dt_depth), 0]) keyboard_base_half(1);
  } else if (part == 6) {
    assembled_parts();
  }
}

// ---------------------------------------------------------------------
// 印刷プレート (part=7)
// 枠は平置き、ほかは立てる。枠のポケットの中に土台 右とリストレストを、枠の奥に土台 左を並べる
// 各 lay_* はパーツの外接箱の最小角を原点に置く
// ---------------------------------------------------------------------

module lay_frame() {
  translate([-frame_x0, -frame_y0, 0]) trackpad_frame();
}

// 奥面を下にして立てる (継ぎ目の溝以外のダブテールが縦向きになる)
module lay_base_left() {
  translate([-rest_x_out, 0, kb_base_y1]) rotate([-90, 0, 0]) keyboard_base_half(-1);
}

// 右端面を下にして立て、長手を X に向ける (継ぎ目の凸が上を向く)
module lay_base_right() {
  translate([-(kb_base_y0 - dt_depth), kb_total_h, tray_x1])
    rotate([0, 0, -90]) rotate([0, 90, 0]) keyboard_base_half(1);
}

// 外側面を下にして立て、長手を X に向ける (枠↔リストレストのダブテールが縦向きになる)
module lay_wrist_rest(side) {
  if (side < 0)
    translate([rest_y1, rest_h, -rest_x_out]) rotate([0, 0, 90]) rotate([0, -90, 0]) wrist_rest(-1);
  else
    translate([rest_y1, 0, tp_w - rest_x_out]) rotate([0, 0, 90]) rotate([0, 90, 0]) wrist_rest(1);
}

plate_frame_d = frame_d + dt_depth;        // 奥面のダブテール凸を含む
plate_pocket_x0 = plate_margin + frame_wall;
plate_pocket_y0 = plate_margin + frame_wall;
plate_in_gap = (pocket_d - (kb_total_h + 2 * rest_h)) / 4; // ポケット内に立てるパーツの間隔
plate_kb_l_y0 = plate_margin + plate_frame_d + (plate_size - plate_margin - plate_frame_d - kb_total_h) / 2;
assert(plate_margin + frame_w <= plate_size && plate_kb_l_y0 + kb_total_h <= plate_size, "印刷プレートに収まらない");
assert(kb_split_x - rest_x_out <= plate_size - 2 * plate_margin, "土台 左がプレート幅に収まらない");
assert(max(kb_base_y1 - kb_base_y0, rest_y1 - frame_y0) + dt_depth <= pocket_w - 8, "立てるパーツが枠のポケットに収まらない");

// lazy-union でパーツごとに別オブジェクトとして出力するため、トップレベルに並べる
if (part == 7) {
  translate([plate_margin, plate_margin, 0]) lay_frame();
  translate([plate_size/2 - (kb_split_x - rest_x_out)/2, plate_kb_l_y0, 0]) lay_base_left();
  translate([plate_size/2 - (kb_base_y1 - kb_base_y0 + dt_depth)/2, plate_pocket_y0 + plate_in_gap, 0]) lay_base_right();
  translate([plate_size/2 - (rest_y1 - frame_y0)/2, plate_pocket_y0 + 2 * plate_in_gap + kb_total_h, 0]) lay_wrist_rest(-1);
  translate([plate_size/2 - (rest_y1 - frame_y0)/2, plate_pocket_y0 + 3 * plate_in_gap + kb_total_h + rest_h, 0]) lay_wrist_rest(1);
}

model();
