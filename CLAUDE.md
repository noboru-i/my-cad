# My CAD — CLAUDE.md

## プロジェクト概要

OpenSCADで3Dプリンター用モデルを設計するリポジトリ。`my-cad` はモデル情報の唯一の正本であり、`my-cad-app` はここからモデル一覧と詳細を表示する。BOSL2は `lib/BOSL2/` のgit submoduleとして配置する。

## 標準ディレクトリ構成

各モデルは `YYYYMMDD_<name>/` 形式のディレクトリに格納する。

```text
YYYYMMDD_<name>/
  <name>.scad        # 必ず1つだけ置くメイン設計ファイル
  README.md          # 目的、パーツ構成、出力、組立・印刷上の注意
  render_stl.sh      # stl/へ出力する再現可能なOpenSCADコマンド
  stl/
    <part>.stl       # 印刷する個別パーツ
    assembled.stl    # 分割モデルの組立確認用（印刷用ではない）
  BOSL2 -> ../lib/BOSL2  # BOSL2使用時のみ
```

- 単一パーツモデルでは `assembled.stl` は不要。READMEに単一パーツであることを記載する。
- 分割モデルでは、個別STLと組立確認用 `stl/assembled.stl` を分ける。組立STLを印刷用途として扱わない。
- 生成済みSTLは `stl/` に置く。旧モデルの直下STL・3MFは移行完了まで保持し、削除・移動は個別に確認する。
- `render_stl.sh` は `set -eu`、モデルディレクトリへの `cd`、`mkdir -p stl` を使い、出力対象の `part` を明示する。
- READMEには、メインSCAD名、生成コマンド、生成済みの個別STL、組立STLの有無、BOSL2の要否を事実として記載する。

標準化の進捗は `docs/model-standardization-tasks.md` で管理する。作業時は完了項目を更新してからコミットする。

## .scad ファイルの作成ルール

```openscad
// パラメータ定義（調整しやすい変数として先頭に集める）
width = 100;
height = 50;
thickness = 2;

module model() {
  // モデル本体
}

model();
```

- ファイル末尾で必ず `model()` を呼び出す。
- パラメータはモジュールの外側でまとめる。
- インデントは2スペース、ブレースはK&Rスタイルで統一する。
- 単位はmm。一般的なクリアランスは0.2〜0.5mmを目安にする。
- `$fn` はプレビュー32、最終出力64〜128を目安にする。

## BOSL2

BOSL2を使う場合はSCAD先頭でincludeする。

```openscad
include <BOSL2/std.scad>
```

モデルディレクトリにシンボリックリンクを作る。

```bash
cd YYYYMMDD_<name>
ln -s ../lib/BOSL2 ./BOSL2
```

`my-cad-app` でリポジトリSCADをレンダリングする場合、リポジトリの `lib/` がread-onlyのOpenSCAD include pathとして渡される。

## 印刷可能性の確認

- 各印刷ピースは連結した1つの領域にする。継手ソケットと外形の間には1mm以上の肉を残すか、外形まで完全に切り抜く。
- 0.4mm未満の細い残り身や一点接続の破片を作らない。
- エクスポート前に、各STLの連結成分数が意図した数であることを確認する。
- 分割モデルは個別STLに加え、組立位置の `assembled.stl` を確認する。

## AIへの設計依頼

- 収納物・寸法・材質・印刷条件が不足している場合は、設計前に確認する。
- 既存モデルの変更では、対象SCADと出力対象STLを明示し、生成物を無確認で上書きしない。
- STL/3MFの生成は、OpenSCAD GUIまたはCLIで実行・確認する。
