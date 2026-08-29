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

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [表示・出力] */
// 表示するパーツ: 0=組立プレビュー, 1=ベース板(分割なし), 2=リストレスト左, 3=リストレスト右, 4=傾斜ウェッジ,
// 5=ベース前左, 6=ベース前右, 7=ベース後左, 8=ベース後右 (Bambu Lab A1 mini 用 2x2 グリッド分割)
part = 0; // [0:Assembly, 1:Base, 2:WristRest_L, 3:WristRest_R, 4:TiltWedge, 5:Base_FrontLeft, 6:Base_FrontRight, 7:Base_RearLeft, 8:Base_RearRight]
// デバイスのダミーモデルを表示 (プレビュー用)
show_devices = false;

/* [分割 (Bambu Lab A1 mini: ビルドボリューム 180x180mm 対応)] */
// ベース板の Y 方向分割線位置。トラックパッド開口部内 (材が無い領域) かつ
// リストレスト固定ペグ(y=20,78)・キーボード位置決めリブ・ゴム足凹みのいずれとも重ならない位置を選ぶ
split_y = 90;
// 分割ピース同士の位置合わせピン直径
seam_pin_d = 4;
// ピンの突き出し長さ (相手側のピースにこの半分ずつめり込む)
seam_pin_len = 4;
// 穴側クリアランス (直径に加算)
seam_pin_clearance = 0.3;

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
// リストレスト上面のエッジ加工 (R5的な丸み)。板厚を超える分は自然と全丸(ブルノーズ)になる
rest_edge_r = 5; // [1:10]

/* [ケーブル取り回し] */
// キーボード・トラックパッドとも充電端子は奥辺中央にある実測前提。
// トラックパッド端子を露出させ、そこからキーボード下を通してトレイ背面まで直進させる
cable_channel_w = 16;      // チャンネル幅 (中央配置) [10:30]
cable_groove_d = 2.5;      // 端子露出部から奥へ、キーボード下を通す溝の深さ (板厚を貫通しない) [1:4]

/* [板厚・クリアランス] */
base_t = 6;      // ベース板厚 (実物同等)
rest_t = 4;      // リストレスト板厚 (実物同等)
margin = 0.5;    // デバイス周囲の遊び (片側)
lip_h  = 2.5;    // 位置決めリブの高さ
lip_w  = 3;      // 位置決めリブの幅
corner_r = 4;    // 外形コーナーR
tp_stopper_w = 10; // トラックパッド手前ストッパーの幅 (左右コーナー2箇所、全幅の細長リブは強度不足のため避ける)

/* [キーボードゴム足凹み] */
kb_foot_d   = 9;    // ゴム足直径 (要実測)
kb_foot_dep = 0.8;  // 凹み深さ
kb_foot_inset_x = 15; // 左右端からの距離 (要実測)
kb_foot_inset_y = 8;  // 前後端からの距離 (要実測)

/* [リストレスト位置決めペグ] */
// ベース側凸ペグとリストレスト側穴で前後・左右のズレを止める (楔なし、上下方向は現状の印刷向きのまま)
// リストレストは外側端 (x=0基準) をベースの外側端に揃えて置くため、
// peg_inset_x / peg_ys は「外側端からの距離」で固定し、rest_tp_cover を変えた別サイズのリストレストでも共通で使い回せる
peg_d   = 6;    // ペグ直径
peg_h   = rest_t - 0.3; // ペグ高さ (リストレスト板厚よりわずかに低く抑え、天面から突き出さない)
peg_clearance = 0.3; // リストレスト側の穴クリアランス (直径に加算)
peg_inset_x = 14; // 外側端からのペグ位置 (X)
peg_ys = [20, 78]; // ペグ位置 (Y, 外側端基準・2点で回転もロック)

// ---------------------------------------------------------------------
// 派生値
// ---------------------------------------------------------------------
board_w = kb_w + 2*margin + 2*lip_w;          // 全幅 (~280mm相当)
tp_slot_w = tp_w + 2*margin;                   // トラックパッド用切り欠き幅
tp_exposed_d = tp_d - tp_overlap;              // トラックパッドの露出奥行
board_d = kb_d + 2*margin + lip_w + tp_exposed_d; // 全奥行
kb_zone_d = kb_d + 2*margin + lip_w;           // キーボード載置部の奥行
$fn = 48;

// ケーブルチャンネル (X中央 = トラックパッド端子・キーボード端子とも中央想定)
cable_channel_x0 = board_w/2 - cable_channel_w/2;
// トラックパッド用切り欠き (Y ~ tp_exposed_d+margin で終わる) の終端に直結させ、
// 開口部との間に壁を残さないようにする
cable_port_y0 = tp_exposed_d;                  // 完全貫通の開始 (トラックパッド開口部の終端と重ねる)
cable_port_y1 = tp_d + margin;                 // トラックパッド端子奥 (オーバーラップ終端に一致)

echo(str("全体寸法: ", board_w, " x ", board_d, " mm (参考: 実物 280 x 214)"));

// 分割ピース境界ボックス用の張り出し余白 (外形・突起物を確実に包含)
split_pad = 10;
// Y方向継ぎ目(前後)のピン位置: 左右の無垢な側桁部分 (トラックパッド開口の外側)
seam_y_pin_xs = [30, board_w - 30];
// X方向継ぎ目(左右)のピン位置: キーボード載置部の無垢な領域 (前後リブ・ゴム足凹みを避ける)
seam_x_pin_ys = [130, 190];
// ピンの高さ (ベース板底面=印刷ベッド面に接するようにし、突き出し部が宙に浮かないようにする)
seam_pin_z = seam_pin_d / 2;

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
      difference() {
        union() {
          // 板本体
          rrect(board_w, board_d, base_t, corner_r);
          // キーボード位置決めリブ (左右+手前+奥)
          translate([0, board_d - kb_zone_d, base_t]) {
            cube([lip_w, kb_zone_d, lip_h]);                       // 左
            translate([board_w - lip_w, 0, 0])
              cube([lip_w, kb_zone_d, lip_h]);                     // 右
            translate([0, kb_zone_d - lip_w, 0])
              cube([board_w, lip_w, lip_h]);                       // 奥
            cube([board_w, lip_w, lip_h]);                         // 手前 (キーボードの手前ズレ防止)
          }
          // リストレスト位置決めペグ (左右)
          for (y = peg_ys) {
            translate([peg_inset_x, y, base_t])
              cylinder(d = peg_d, h = peg_h);
            translate([board_w - peg_inset_x, y, base_t])
              cylinder(d = peg_d, h = peg_h);
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
        // トラックパッド充電端子の露出 (端子は背面中央、完全貫通させて指/コネクタが入るようにする)
        translate([cable_channel_x0, cable_port_y0, -1])
          cube([cable_channel_w, cable_port_y1 - cable_port_y0, base_t + 2]);
        // ケーブル溝: 端子露出部からキーボード下を通りトレイ背面まで直進 (浅く彫るだけで板厚は貫通しない)
        translate([cable_channel_x0, cable_port_y1, base_t - cable_groove_d])
          cube([cable_channel_w, board_d - cable_port_y1, cable_groove_d + lip_h + 1]);
      }
      // トラックパッド手前ストッパー (左右コーナー2箇所。土台の厚み部分に直結させ、無支持の細長リブによる折れを防ぐ)
      for (x = [(board_w - tp_slot_w)/2, (board_w + tp_slot_w)/2 - tp_stopper_w])
        translate([x, 0, 0])
          cube([tp_stopper_w, lip_w, lip_h]);
    }
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
  footprint = round_corners([[0, 0], [w, 0], [w, rest_d], [0, rest_d]], r = corner_r);
  edge_r = min(rest_edge_r, rest_t - 0.1); // 板厚を超えるRは指定できないため丸める
  mirror([side > 0 ? 1 : 0, 0, 0])
    difference() {
      offset_sweep(footprint, height = rest_t, top = os_circle(r = edge_r));
      // 内側上部(トラックパッド側の奥)を斜めにカット → トラックパッド操作域を拡大
      translate([w - rest_tp_cover, rest_d, -1])
        linear_extrude(rest_t + 2)
          polygon([[ -1, 1], [rest_tp_cover + 1, 1],
                   [rest_tp_cover + 1, -cut], [-1, -0.01]]);
      // ベース側位置決めペグ用の貫通穴 (外側端 x=0 基準、mirror() で左右とも揃う)
      for (y = peg_ys)
        translate([peg_inset_x, y, -1])
          cylinder(d = peg_d + peg_clearance, h = rest_t + 2);
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

// ---------------------------------------------------------------------
// ベース板 2x2 グリッド分割 (Bambu Lab A1 mini のビルドボリューム 180x180mm 対応)
// 継ぎ目には位置合わせ用の丸ピンを設け、接着時のズレを防ぐ
// ---------------------------------------------------------------------

// Y方向(前後)継ぎ目のピン: 軸はY方向。中心を split_y に置き、前後ピースへ半分ずつ食い込ませる
module seam_pin_y(x, y, len = seam_pin_len, d = seam_pin_d) {
  translate([x, y, seam_pin_z])
    rotate([-90, 0, 0])
      cylinder(d = d, h = len, center = true);
}

// X方向(左右)継ぎ目のピン: 軸はX方向
module seam_pin_x(x, y, len = seam_pin_len, d = seam_pin_d) {
  translate([x, y, seam_pin_z])
    rotate([0, 90, 0])
      cylinder(d = d, h = len, center = true);
}

// 分割ピースの外形を切り出すバウンディングボックス
// qx = -1:左, 1:右 / qy = -1:前(トラックパッド側), 1:後(キーボード側)
module quadrant_box(qx, qy) {
  x0 = qx < 0 ? -split_pad : board_w/2;
  x1 = qx < 0 ? board_w/2 : board_w + split_pad;
  y0 = qy < 0 ? -split_pad : split_y;
  y1 = qy < 0 ? split_y : board_d + split_pad;
  translate([x0, y0, -split_pad])
    cube([x1 - x0, y1 - y0, base_t + lip_h + 2*split_pad]);
}

module base_plate_quadrant(qx, qy) {
  // Y継ぎ目ピンは自ピースの左右側 (qx) に対応する1本だけを使う
  seam_y_pin_x = qx < 0 ? seam_y_pin_xs[0] : seam_y_pin_xs[1];
  difference() {
    union() {
      intersection() {
        base_plate();
        quadrant_box(qx, qy);
      }
      // 突起ピン (オス側): 前ピースがY継ぎ目のオス、左後ピースがX継ぎ目のオス
      if (qy < 0)
        seam_pin_y(seam_y_pin_x, split_y);
      if (qx < 0 && qy > 0)
        for (y = seam_x_pin_ys) seam_pin_x(board_w/2, y);
    }
    // 穴 (メス側): 後ピースがY継ぎ目のメス、右後ピースがX継ぎ目のメス
    if (qy > 0)
      seam_pin_y(seam_y_pin_x, split_y, len = seam_pin_len + 2, d = seam_pin_d + seam_pin_clearance);
    if (qx > 0 && qy > 0)
      for (y = seam_x_pin_ys)
        seam_pin_x(board_w/2, y, len = seam_pin_len + 2, d = seam_pin_d + seam_pin_clearance);
  }
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
} else if (part == 5) {
  base_plate_quadrant(-1, -1); // 前左
} else if (part == 6) {
  base_plate_quadrant(1, -1);  // 前右
} else if (part == 7) {
  base_plate_quadrant(-1, 1);  // 後左
} else if (part == 8) {
  base_plate_quadrant(1, 1);   // 後右
}
