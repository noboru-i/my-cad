// =====================================================================
// Crispy Backboard PRO 2021 風 キーボードトレイ (パラメトリック版)
// Magic Keyboard (A1644, 2015) + Magic Trackpad 2 用
// 3Dプリント前提: アクリル版と異なり、位置決めリブ・ゴム足凹みを一体成形
//
// 寸法根拠:
//   本体全体 280 x 214 x 16mm / ベース6mm / リストレスト4mm (03enterprise 製品ページ)
//   Magic Keyboard : 279 x 114.9 x 4.1-10.9mm (Apple/Wikipedia)
//   Magic Trackpad 2: 160 x 114.9 x 4.9-10.9mm (Apple/Wikipedia)
// =====================================================================

/* [表示・出力] */
// 表示するパーツ: 0=組立プレビュー, 1=ベース板のみ, 2=リストレスト左, 3=リストレスト右, 4=傾斜ウェッジ
part = 0; // [0:Assembly, 1:Base, 2:WristRest_L, 3:WristRest_R, 4:TiltWedge]
// デバイスのダミーモデルを表示 (プレビュー用)
show_devices = false;
// ベース板を左右2分割して出力 (印刷ベッドが280mmに満たない場合)
split_base = true;

/* [デバイス寸法 (実測で微調整可)] */
kb_w = 279.0;   // Magic Keyboard 幅
kb_d = 114.9;   // Magic Keyboard 奥行
kb_h_front = 4.1;  // Magic Keyboard 手前(薄い側)高さ
kb_h_rear  = 10.9; // Magic Keyboard 奥(厚い側)高さ
tp_w = 160.0;   // Magic Trackpad 2 幅
tp_d = 114.9;   // Magic Trackpad 2 奥行
tp_h_front = 4.9;  // Trackpad 手前高さ
tp_h_rear  = 10.9; // Trackpad 奥高さ

/* [主要調整パラメータ] */
// ★ トラックパッド重なり量: ベース/キーボード側がトラックパッド上端を覆う量 (mm)
tp_overlap = 16;     // [0:40]
// ★ トラックパッド傾斜角 (度)。0で水平。ウェッジパーツで実現
tp_angle = 0;        // [0:15]
// リストレストがトラックパッド左右端を覆う量 (mm)
rest_tp_cover = 20;  // [0:60]
// リストレスト内側上部の斜めカット角 (度) — 2021年モデルの特徴
rest_chamfer_angle = 30; // [0:60]
// リストレスト奥行 (トラックパッド手前端からの張り出し含む)
rest_d = 98;

/* [板厚・クリアランス] */
base_t = 6;      // ベース板厚 (実物同等)
rest_t = 4;      // リストレスト板厚 (実物同等)
margin = 0.5;    // デバイス周囲の遊び (片側)
lip_h  = 2.5;    // 位置決めリブの高さ
lip_w  = 3;      // 位置決めリブの幅
corner_r = 4;    // 外形コーナーR

/* [キーボードゴム足凹み] */
kb_foot_d   = 9;    // ゴム足直径 (要実測)
kb_foot_dep = 0.8;  // 凹み深さ
kb_foot_inset_x = 15; // 左右端からの距離 (要実測)
kb_foot_inset_y = 8;  // 前後端からの距離 (要実測)

// ---------------------------------------------------------------------
// 派生値
// ---------------------------------------------------------------------
board_w = kb_w + 2*margin + 2*lip_w;          // 全幅 (~280mm相当)
tp_slot_w = tp_w + 2*margin;                   // トラックパッド用切り欠き幅
tp_exposed_d = tp_d - tp_overlap;              // トラックパッドの露出奥行
board_d = kb_d + 2*margin + lip_w + tp_exposed_d; // 全奥行
kb_zone_d = kb_d + 2*margin + lip_w;           // キーボード載置部の奥行
$fn = 48;

echo(str("全体寸法: ", board_w, " x ", board_d, " mm (参考: 実物 280 x 214)"));

// ---------------------------------------------------------------------
// 部品モジュール
// ---------------------------------------------------------------------
module rrect(w, d, h, r) { // 角丸板
  linear_extrude(h)
    offset(r) offset(-r)
      square([w, d]);
}

// ベース板: 奥=キーボード載置部(Y大側), 手前中央=トラックパッド切り欠き
module base_plate() {
  difference() {
    union() {
      // 板本体
      rrect(board_w, board_d, base_t, corner_r);
      // キーボード位置決めリブ (左右+奥)
      translate([0, board_d - kb_zone_d, base_t]) {
        cube([lip_w, kb_zone_d, lip_h]);                       // 左
        translate([board_w - lip_w, 0, 0])
          cube([lip_w, kb_zone_d, lip_h]);                     // 右
        translate([0, kb_zone_d - lip_w, 0])
          cube([board_w, lip_w, lip_h]);                       // 奥
      }
    }
    // トラックパッド用 貫通切り欠き (トラックパッドは机に直置き)
    translate([(board_w - tp_slot_w)/2, -1, -1])
      cube([tp_slot_w, tp_exposed_d + 1 + margin, base_t + 2]);
    // ※ tp_overlap 分はベース板(キーボード載置部)がトラックパッド後端上を覆う
    //   → その領域は板を薄くしてトラックパッド後端(10.9mm)と干渉しないよう逃がす
    translate([(board_w - tp_slot_w)/2, tp_exposed_d - 1, -1])
      cube([tp_slot_w, tp_overlap + margin + 1, 1 + base_t - overhang_t()]);
    // キーボードゴム足凹み (4箇所)
    for (fx = [kb_foot_inset_x, kb_w - kb_foot_inset_x])
      for (fy = [kb_foot_inset_y, kb_d - kb_foot_inset_y])
        translate([lip_w + margin + fx,
                   board_d - lip_w - margin - kb_d + fy,
                   base_t - kb_foot_dep])
          cylinder(d = kb_foot_d, h = kb_foot_dep + 1);
    // 分割線 (オプション)
    if (split_base && part != 0)
      split_cut();
  }
}

// トラックパッド上に張り出す部分の残し厚
// トラックパッド後端高さ(角度考慮) + 逃げ1mm を差し引く
function overhang_t() =
  max(1.2, base_t - 0); // 張り出し部は上面フラット維持のため薄板化はリストレスト側で処理

// リストレスト (左右対称・非対称カット付き)
// side = -1:左, 1:右
module wrist_rest(side = -1) {
  w = (board_w - tp_slot_w)/2 + rest_tp_cover; // 板幅: ベース手前 + トラックパッド覆い
  cut = rest_tp_cover * tan(rest_chamfer_angle) + 8; // 斜めカットの奥行成分
  mirror([side > 0 ? 1 : 0, 0, 0])
    difference() {
      rrect(w, rest_d, rest_t, corner_r);
      // 内側上部(トラックパッド側の奥)を斜めにカット → トラックパッド操作域を拡大
      translate([w - rest_tp_cover, rest_d, -1])
        linear_extrude(rest_t + 2)
          polygon([[ -1, 1], [rest_tp_cover + 1, 1],
                   [rest_tp_cover + 1, -cut], [-1, -0.01]]);
    }
}

// 傾斜ウェッジ: トラックパッドの下に敷き tp_angle を付ける
module tilt_wedge() {
  if (tp_angle > 0) {
    difference() {
      rotate([tp_angle, 0, 0])
        cube([tp_slot_w - 2, tp_d, tp_d * tan(tp_angle) + 2]);
      translate([-1, -1, -tp_d]) cube([tp_slot_w + 2, tp_d + 2, tp_d]); // 底面カット
      translate([-1, -1, tp_d * tan(tp_angle)])
        cube([tp_slot_w + 2, tp_d + 2, tp_d]); // 上面カット(平面化は簡略)
    }
  }
}

// ベッドに乗らない場合の中央分割 (簡易ダボ付き)
module split_cut() {
  translate([board_w/2 - 0.2, -1, -1])
    cube([0.4, board_d + 2, base_t + lip_h + 2]);
}

// デバイスダミー (プレビュー)
module device_dummies() {
  color("silver", 0.5)
    translate([lip_w + margin, board_d - lip_w - margin - kb_d, base_t])
      cube([kb_w, kb_d, kb_h_rear]); // キーボード簡略
  color("white", 0.5)
    translate([(board_w - tp_w)/2, 0, 0])
      rotate([tp_angle, 0, 0])
        cube([tp_w, tp_d, tp_h_rear]); // トラックパッド簡略
}

// ---------------------------------------------------------------------
// 出力
// ---------------------------------------------------------------------
if (part == 0) {
  base_plate();
  color("lightblue", 0.8) translate([0, 0, base_t + 0.01]) {
    wrist_rest(-1);
    translate([board_w, 0, 0]) wrist_rest(1);
  }
  if (tp_angle > 0)
    color("orange") translate([(board_w - tp_slot_w)/2 + 1, 0, 0]) tilt_wedge();
  if (show_devices) device_dummies();
} else if (part == 1) {
  base_plate();
} else if (part == 2) {
  wrist_rest(-1);
} else if (part == 3) {
  wrist_rest(1);
} else if (part == 4) {
  tilt_wedge();
}
