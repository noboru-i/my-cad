# calendar_holder

卓上カレンダー用ホルダー。

## 現在のファイル

- メインSCAD: `model.scad`
- 生成済みSTL: `model.stl`
- `render_stl.sh`: 未整備
- 組立STL: 不要（単一パーツ）
- BOSL2: 使用していない

## 再生成

```bash
openscad --render -o model.stl model.scad
```

これは旧配置のモデルであり、STLはモデル直下に保持している。`stl/`と生成スクリプトへの移行は標準化タスクで行う。
