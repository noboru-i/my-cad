# keyboard_trackpad_tray

PLA 3Dプリント向けの Magic Keyboard + Magic Trackpad トレイです。Crispy Backboard PRO 風の配置で、Bambu Lab A1 mini の 180 x 180 x 180 mm に収まるよう、4分割の差し込み式にしています。

## 寸法ソース

2026-06-22 に Apple Store の Tech Specs から取得。

- Magic Keyboard (USB-C): Height 0.16–0.43 inch (0.41–1.09 cm), Width 10.98 inches (27.89 cm), Depth 4.52 inches (11.49 cm)
- Magic Trackpad (USB-C): Height 0.19–0.43 inch (0.49–1.09 cm), Width 6.30 inches (16.0 cm), Depth 4.52 inches (11.49 cm)

## 出力パーツ

本体4分割のみです。ネジや別体接続プレートは使わず、板厚内の一体成形タブを差し込んで組みます。机に接する裏面はフラットになるようにしています。

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

- `front_left` と `front_right` を左右方向に差し込む
- `back_left` と `back_right` を左右方向に差し込む
- 前後列を合わせ、前側パーツの板厚内タブを後ろ側パーツの受け穴へ差し込む
- きつい場合は `join_clearance` を大きくする
- ゆるい場合は `join_clearance` を小さくするか、少量の両面テープ/接着剤を併用する

## PLA向けメモ

- 推奨: 0.2mm layer, 3 walls, infill 15-25%
- 反り防止のため、ベッド接地面をきれいにし、必要なら brim を使用
- Trackpad ポケットは浅めの 1.0mm なので、実機のガタつきに応じて調整する
- 差し込み部はプリンタの寸法精度に左右されるため、まず `join_clearance = 0.45` で試す
