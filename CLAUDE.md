# My CAD — CLAUDE.md

## プロジェクト概要

OpenSCAD で 3D プリンター用モデルを設計するリポジトリ。
ライブラリとして [BOSL2](https://github.com/BelfrySCAD/BOSL2) を使用する。
`lib/BOSL2/` が git submodule として配置されている。

## ディレクトリ構成

各モデルは `YYYYMMDD_<name>/` 形式のディレクトリに格納する。

```
YYYYMMDD_<name>/
  <name>.scad      # メインの設計ファイル
  BOSL2 -> ../lib/BOSL2  # シンボリックリンク（BOSL2 使用時のみ）
  <name>.stl       # エクスポートされた STL（コミット任意）
  <name>.3mf       # スライサー用ファイル（コミット任意）
```

## .scad ファイルの作成ルール

### 基本構造

```openscad
// パラメータ定義（調整しやすい変数として先頭に集める）
width = 100;
height = 50;
thickness = 2;

module model()
{
    // モデル本体
}

model();
```

- ファイル末尾で必ず `model()` を呼び出す
- パラメータはモジュールの外側でまとめて定義する
- ブレースのスタイルは K&R（開き括弧は同じ行）ではなく Allman スタイル（開き括弧は次の行）で統一する

### BOSL2 の使い方

BOSL2 を使う場合はファイル先頭で `include` する。

```openscad
include <BOSL2/std.scad>
```

その後、ディレクトリに `BOSL2` シンボリックリンクが必要：

```bash
cd YYYYMMDD_<name>
ln -s ../lib/BOSL2 ./BOSL2
```

モデルに応じて必要な BOSL2 モジュールを積極的に活用する（`cuboid`、`cyl`、`tube`、`rounding` など）。

### 単位・精度

- 単位は mm
- 3D プリンターの一般的な精度を考慮し、クリアランスは 0.2〜0.5 mm 程度を目安にする
- `$fn` で円の分割数を指定するときは、プレビュー用 32、最終出力用 64〜128 を目安にする

### コメント

パラメータの意味が自明でない場合のみ行末コメントで補足する。モジュールには原則コメント不要。

## 新しいモデルを作成するとき

1. `YYYYMMDD_<name>/` ディレクトリを作成する
2. `<name>.scad` を作成する
3. BOSL2 を使う場合はシンボリックリンクを作成する
4. OpenSCAD でプレビュー確認後、STL をエクスポートする

## ツール・環境

- OpenSCAD: `brew install --cask openscad@snapshot`
- VS Code 拡張: `Antyos.openscad`
- プレビュー: エディタ右上の "Preview in OpenSCAD" ボタン
- STL エクスポート: エディタ右上の "Export Model" ボタン

## Claude Code への依頼例

- 「○○を収納するホルダーを作って」→ 寸法を確認してから設計
- 「このパラメータを変えて」→ .scad の変数を編集
- 「フィレットを追加して」→ BOSL2 の `rounding` オプションや `mask3d` を活用
- STL/3MF ファイルの生成は Claude Code では行わない（OpenSCAD の GUI または CLI で行う）
