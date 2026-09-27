# simple_box

標準サイズと小型サイズを選択できる単純な箱。

## 構成

- メインSCAD: `simple_box.scad`
- 出力STL: `stl/simple_box.stl`、`stl/simple_box_small.stl`
- `render_stl.sh`: 2種類のサイズを再生成する
- 組立STL: 不要（各出力は単一パーツ）
- BOSL2: 使用していない

旧来の `simple_box_small.scad` は、単一SCAD構成への移行に伴い `legacy/` に保管する。既存の直下STL・3MFは移動・削除せず保持する。

## 再生成

```bash
./render_stl.sh
```

個別に出力する場合:

```bash
openscad --render -D 'variant="standard"' -o stl/simple_box.stl simple_box.scad
openscad --render -D 'variant="small"' -o stl/simple_box_small.stl simple_box.scad
```
