# tcg_marker

トレーディングカードゲーム用マーカー。

## 現在のファイル

- メインSCAD: `tcg_marker.scad`
- 生成済みSTL: `tcg_marker.stl`
- `render_stl.sh`: 未整備
- 組立STL: 不要（単一パーツ）
- BOSL2: `BOSL2` シンボリックリンクあり

## 再生成

```bash
openscad --render -o tcg_marker.stl tcg_marker.scad
```

これは旧配置のモデルであり、STLはモデル直下に保持している。
