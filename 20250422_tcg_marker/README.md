# tcg_marker

トレーディングカードゲーム用マーカー。

## 構成

- メインSCAD: `tcg_marker.scad`
- 出力STL: `stl/tcg_marker.stl`
- `render_stl.sh`: 上記STLを再生成する
- 組立STL: 不要（単一パーツ）
- BOSL2: `BOSL2` シンボリックリンクを使用

既存の直下STLは移動・削除せず保持する。

## 再生成

```bash
./render_stl.sh
```
