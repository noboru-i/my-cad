# laptop_tablet_stand

ノートPCまたはタブレット用スタンド。

## 現在のファイル

- メインSCAD: `laptop_tablet_stand.scad`
- 生成済みSTL: `laptop_tablet_stand.stl`
- `render_stl.sh`: 未整備
- 組立STL: 不要（単一パーツ）
- BOSL2: `BOSL2` シンボリックリンクあり

## 再生成

```bash
openscad --render -o laptop_tablet_stand.stl laptop_tablet_stand.scad
```

これは旧配置のモデルであり、STLはモデル直下に保持している。
