# keyboard_trackpad_tray

PLA 3Dプリント向けの Magic Keyboard + Magic Trackpad トレイです。Crispy Backboard PRO 風の配置で、Bambu Lab A1 mini の 180 x 180 x 180 mm に収まるよう、4分割の差し込み式にしています。

## 寸法ソース

2026-06-22 に Apple Store の Tech Specs から取得。

- Magic Keyboard (USB-C): Height 0.16–0.43 inch (0.41–1.09 cm), Width 10.98 inches (27.89 cm), Depth 4.52 inches (11.49 cm)
- Magic Trackpad (USB-C): Height 0.19–0.43 inch (0.49–1.09 cm), Width 6.30 inches (16.0 cm), Depth 4.52 inches (11.49 cm)

## 出力パーツ

本体4分割のみです。机に接する裏面を完全にフラットにするため、裏面リブや裏面に出る差し込みタブ/受け穴は標準では無効にしています。必要に応じて少量の両面テープや接着剤で固定してください。

- `back_left.stl`
- `back_right.stl`
- `front_left.stl`
- `front_right.stl`

## STL生成

```bash
cd /home/arduino/ghq/github.com/noboru-i/my-cad/20260622_keyboard_trackpad_tray
./render_stl.sh
```

個別に生成する場合:

```bash
mkdir -p stl
for p in back_left back_right front_left front_right; do
  openscad -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray.scad
done
```

## 組み立て

- 4分割パーツを突き合わせて配置する
- 必要に応じて、裏面ではなく側面や上面側から目立たない位置に少量の両面テープ/接着剤を併用する
- 差し込みタブが必要な場合のみ、SCAD の `use_integral_join_tabs = true` に変更して再生成する。ただしこの場合は裏面側にもタブ/受け穴の形状が出る

## PLA向けメモ

- 推奨: 0.2mm layer, 3 walls, infill 15-25%
- 反り防止のため、ベッド接地面をきれいにし、必要なら brim を使用
- Trackpad ポケットは浅めの 1.0mm なので、実機のガタつきに応じて調整する
- Magic Keyboard / Magic Trackpad ともに充電端子は背面中央にある前提で、上側へ抜けるケーブル用スリットと Trackpad 用コネクタ逃げを入れている
- Trackpad 側のケーブル経路は中央の差し込みタブを避けるため少し右へ逃がしている。USB-C コネクタやケーブルが太い場合は `keyboard_cable_gap` / `trackpad_cable_gap` / `trackpad_connector_pocket_width` を大きくする
- 裏面を完全にフラットにするため、標準では `use_integral_join_tabs = false` にしている
