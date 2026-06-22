# keyboard_trackpad_tray

PLA 3Dプリント向けの Magic Keyboard + Magic Trackpad トレイです。Crispy Backboard PRO 風の配置で、Bambu Lab A1 mini の 180 x 180 x 180 mm に収まるよう、4分割+接続プレートにしています。

## 寸法ソース

2026-06-22 に Apple Store の Tech Specs から取得。

- Magic Keyboard (USB-C): Height 0.16–0.43 inch (0.41–1.09 cm), Width 10.98 inches (27.89 cm), Depth 4.52 inches (11.49 cm)
- Magic Trackpad (USB-C): Height 0.19–0.43 inch (0.49–1.09 cm), Width 6.30 inches (16.0 cm), Depth 4.52 inches (11.49 cm)

## 出力パーツ

メイン本体:

- `back_left.stl`
- `back_right.stl`
- `front_left.stl`
- `front_right.stl`

裏側接続プレート:

- `connector_x_back.stl`
- `connector_x_front.stl`
- `connector_y_left.stl`
- `connector_y_right.stl`

## STL生成

```bash
cd /home/arduino/ghq/github.com/noboru-i/my-cad/20260622_keyboard_trackpad_tray
mkdir -p stl
for p in back_left back_right front_left front_right connector_x_back connector_x_front connector_y_left connector_y_right; do
  openscad -D "part=\"$p\"" -o "stl/$p.stl" keyboard_trackpad_tray.scad
done
```

## 組み立て

- 本体4分割を合わせる
- 裏面に接続プレート4枚を当てる
- M3ねじ・ナットで固定する想定
- キーボード/トラックパッドの実測に合わせ、必要なら `fit_clearance` を増減する

## PLA向けメモ

- 推奨: 0.2mm layer, 3 walls, infill 15-25%
- 反り防止のため、ベッド接地面をきれいにし、必要なら brim を使用
- Trackpad ポケットは浅めの 1.0mm なので、実機のガタつきに応じて調整する
