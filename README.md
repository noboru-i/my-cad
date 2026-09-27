# my-cad

OpenSCADで設計した3Dプリント用モデルの正本リポジトリです。各日付付きディレクトリが1つのモデルを表します。`my-cad-app` はこのリポジトリを直接読み込み、モデル一覧・SCAD・生成スクリプト・STL・README・AI向け設計規約を表示します。

## モデル構成

```text
YYYYMMDD_<name>/
  <name>.scad        # 単一のメインSCAD
  README.md          # 用途、パーツ、再生成・印刷手順
  render_stl.sh      # STL生成コマンド（ある場合）
  stl/               # 生成済みSTL（ある場合）
    <part>.stl       # 印刷用パーツ
    assembled.stl    # 組立確認用。分割モデルで必要な場合のみ
  BOSL2 -> ../lib/BOSL2  # BOSL2使用時のみ
```

旧モデルには、移行前の直下STL・3MF配置が残っている場合があります。構成標準化の進捗は [docs/model-standardization-tasks.md](docs/model-standardization-tasks.md) を参照してください。

## モデルの確認とSTL生成

モデルディレクトリで、READMEに記載されたスクリプトを実行します。

```bash
cd YYYYMMDD_<name>
./render_stl.sh
```

スクリプトがない旧モデルは、対応するSCADをOpenSCADで開くか、README記載の出力先へ明示的にエクスポートします。

## BOSL2

BOSL2は `lib/BOSL2/` のsubmoduleです。SCADで `include <BOSL2/...>` を使うモデルは、モデルディレクトリに `BOSL2 -> ../lib/BOSL2` のシンボリックリンクを置きます。

```bash
git submodule update --init --recursive
cd YYYYMMDD_<name>
ln -s ../lib/BOSL2 ./BOSL2
```

## 開発環境

- OpenSCAD: `brew install --cask openscad@snapshot`
- VS Code拡張: `Antyos.openscad`
- プレビュー: SCADを開き「Preview in OpenSCAD」
- STLエクスポート: 「Export Model」または各モデルの `render_stl.sh`
