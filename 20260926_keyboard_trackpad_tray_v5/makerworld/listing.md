# MakerWorld 掲載情報（案）

カバー画像（`cover_4x3.jpg` / `cover_3x4.jpg`）に合わせて、掲載文は英語にしている。末尾に確認用の日本語訳を付けた。

## モデル名（50 文字以内）

| 案 | 文字数 |
|---|---|
| **Magic Keyboard & Trackpad Tray with Wrist Rests**（推奨） | 47 |
| Keyboard + Trackpad Tray for Apple Magic Keyboard | 49 |
| Magic Keyboard + Magic Trackpad Desk Tray | 41 |

推奨案は、検索されやすい「Magic Keyboard」「Trackpad」と、他のトレイとの違いになる「Wrist Rests」を両方含む。

## カテゴリ

- **Household > Office**（推奨）: キーボード・デスク周りの小物が集まるカテゴリ
- 次点: Hobby & DIY > Electronics

## タグ

```text
magic keyboard
magic trackpad
apple
mac
keyboard tray
trackpad holder
wrist rest
palm rest
desk setup
desk organizer
office
keyboard stand
a1 mini
dovetail
no glue
no screws
openscad
```

ドロップダウンに同じ意味の既存タグが出たら、そちらを選ぶ。

## 詳細（英語・投稿用）

```markdown
A tray that holds an Apple Magic Keyboard and Magic Trackpad together, with the trackpad centered in front of the keyboard and wrist rests on both sides.

## Features

- The trackpad sits in front of the keyboard, and the wrist rests cover both side edges of the trackpad (20 mm each)
- The wrist rests slope at the same angle as the trackpad
- The keyboard overlaps the back edge of the trackpad by 11 mm to keep the overall depth short
- 5 parts joined with dovetails. No glue or screws needed
- Every part fits a 180 × 180 mm build plate (Bambu Lab A1 mini). All 5 parts fit on one A1 mini plate
- You can charge both devices while they sit in the tray:
  - The trackpad frame has a cutout for the charging port, so you can plug in the cable and then lower the frame over the trackpad
  - A channel under the keyboard base routes the trackpad cable to the back
  - The rear wall of the keyboard base has cutouts for the keyboard's charging port and power switch

## Compatibility

- Apple Magic Keyboard, compact layout without numeric keypad (279 × 114.9 mm)
- Apple Magic Trackpad (160 × 114.9 mm). The outer size is the same for the 2015, 2021 and 2024 (USB-C) models
- Tested with: Magic Keyboard with Touch ID (Japanese layout) and Magic Trackpad (Lightning)

Assembled size: 286 × 229.8 × 23.4 mm

## Parts

| Part | Qty |
|---|---|
| Trackpad frame | 1 |
| Wrist rest (left / right) | 1 each |
| Keyboard base (left / right) | 1 each |

## Print settings

- Printer: Bambu Lab A1 mini (0.4 mm nozzle). Larger printers work too
- Profile: 0.20mm Standard
- Material: PLA (printed in Bambu PLA Basic)
- Infill: 15% grid, 2 walls
- Brim: recommended. The keyboard bases and wrist rests are printed standing up (80 to 123 mm tall)
- Supports: required. The provided 3MF uses normal (auto) supports with a 30° threshold angle

The keyboard bases and wrist rests are solid shapes, so most of the weight comes from infill.

## Assembly

All dovetails slide in from above.

1. Place the trackpad frame (with the trackpad inside)
2. Slide the left keyboard base down onto the back of the frame
3. Slide the right keyboard base down. It joins both the left base and the frame
4. Lower the left and right wrist rests. Each one joins the frame and a keyboard base at the same time

## Notes

- The trackpad's power switch is hidden under the keyboard. Slide the keyboard aside to reach it
- Designed in OpenSCAD with BOSL2
```

## 詳細（日本語訳・確認用）

Magic Keyboard と Magic Trackpad をまとめて置くトレイ。トラックパッドをキーボード手前の中央に置き、左右にリストレストを付けた。

### 特徴

- トラックパッドはキーボードの手前に置き、左右のリストレストがトラックパッドの両端を 20mm ずつ覆う
- リストレストの天面は、トラックパッドと同じ角度で傾斜している
- キーボードはトラックパッドの奥端に 11mm 重なり、全体の奥行を詰めている
- 5 パーツをダブテールで結合する。接着剤やネジは不要
- 全パーツが 180 × 180mm のビルドプレート（Bambu Lab A1 mini）に収まる。5 パーツすべてを A1 mini の 1 プレートに並べられる
- トレイに置いたまま両方を充電できる
  - トラックパッド外枠にポートの切り欠きがあるので、ケーブルを挿したトラックパッドに枠を上から被せられる
  - キーボード土台の下の溝で、トラックパッドのケーブルを背面へ通す
  - キーボード土台の奥の壁に、キーボードの充電ポートと電源スイッチの切り欠きがある

### 対応機種

- Apple Magic Keyboard（テンキーなしのコンパクト版、279 × 114.9mm）
- Apple Magic Trackpad（160 × 114.9mm）。外形は 2015 年版・2021 年版・2024 年版（USB-C）で共通
- 動作確認: Magic Keyboard（Touch ID 付き、日本語配列）と Magic Trackpad（Lightning）

組立後の大きさ: 286 × 229.8 × 23.4mm

### パーツ

| パーツ | 個数 |
|---|---|
| トラックパッド外枠 | 1 |
| リストレスト（左 / 右） | 各 1 |
| キーボード土台（左 / 右） | 各 1 |

### 印刷設定

- プリンター: Bambu Lab A1 mini（0.4mm ノズル）。より大きいプリンターでも可
- プロファイル: 0.20mm Standard
- 材質: PLA（Bambu PLA Basic で印刷）
- インフィル: 15% グリッド、壁 2 層
- ブリム: 推奨。キーボード土台とリストレストは立てて印刷する（高さ 80〜123mm）
- サポート: 必要。同梱の 3MF は normal(auto)、しきい角 30° に設定している

キーボード土台とリストレストは中身の詰まった形なので、重さはほぼインフィルで決まる。

### 組み立て

ダブテールはどれも上から差し込む。

1. トラックパッド外枠を置く（中にトラックパッドを入れる）
2. キーボード土台 左を、枠の奥に上から差し込む
3. キーボード土台 右を上から差し込む。左の土台と枠の両方に同時に入る
4. 左右のリストレストを上から下ろす。それぞれ枠とキーボード土台に同時に入る

### 補足

- トラックパッドの電源スイッチはキーボードの下に隠れる。操作するときはキーボードをずらす
- OpenSCAD と BOSL2 で設計した
