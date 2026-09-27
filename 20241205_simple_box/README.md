# simple_box

単純な箱のモデルと小型版。

## 現在のファイル

- SCAD: `simple_box.scad`、`simple_box_small.scad`
- 生成済みSTL: `simple_box.stl`、`simple_box_small.stl`
- スライサー用3MF: `simple_box.3mf`、`simple_box_small.3mf`
- `render_stl.sh`: 未整備
- 組立STL: 不要（各SCADは単一パーツ）
- BOSL2: 使用していない

## 再生成

```bash
openscad --render -o simple_box.stl simple_box.scad
openscad --render -o simple_box_small.stl simple_box_small.scad
```

このディレクトリには旧来の2種類のSCADがある。標準化では単一モデルへの分割またはディレクトリ構成を別途判断する。
