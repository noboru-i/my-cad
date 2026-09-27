# my-cad モデル構成標準化タスク

## 目的

`my-cad` をモデル情報の唯一の正本として、各モデルを同じ構成で閲覧・再生成できるようにする。標準構成は、単一のメインSCAD、`render_stl.sh`、`stl/` 内の印刷用STL、必要に応じた `stl/assembled.stl`、モデルREADME、リポジトリ直下のAI向け設計規約 `CLAUDE.md` とする。

## フェーズ2: ドキュメント整備（既存STLの配置は維持）

- [x] リポジトリ直下の `README.md` を日本語化し、一覧画面が参照する正本構成を記載する。
- [x] `CLAUDE.md` に標準構成、組立STL、`render_stl.sh`、README、AI向け設計規約の運用を記載する。
- [x] READMEのない既存モデルへ、用途・メインSCAD・現存するSTL/3MF・再生成方法を記載したREADMEを追加する。
- [x] 既存READMEへ、現状の生成物配置と組立STLの有無を追記する。
- [x] 全READMEとルート文書を確認し、記載内容と追跡済みファイルが一致することを検証する。

## フェーズ1: 全モデルのファイル構成標準化

- [x] 各モデルを「単一のメインSCAD + `render_stl.sh` + `stl/`」へ移行する。`20241205_simple_box` は大小バリアントを1つの `simple_box.scad` へ統合し、旧小型SCADは `legacy/` に保管した。
- [x] 分割モデルには、組立確認用の `stl/assembled.stl` を追加する。v1〜v5の5モデルで再生成した。
- [x] 単一パーツモデルの組立STL方針を明確化し、不要である理由を各READMEへ記載する。
- [x] 各 `render_stl.sh` を実行し、出力STLを実ファイルとして検証する。v5ではBOSL2 `offset_sweep` の面取り面を `vnf_triangulate` してからCGAL Booleanへ渡すことで、OpenSCAD 2021.01のCGAL assertionを解消した。
- [x] リポジトリ一覧APIで全モデルのメタデータと生成物を確認する。アプリが参照するチェックアウトを更新・再起動後、13モデルすべてで生成スクリプトと1件以上のSTL、分割5モデルで組立STLを確認した。
- [x] 最終構成と未解決事項をREADME・CLAUDE.md・本タスクに反映する。

## 記録

- フェーズ2完了。13モデルすべてにREADMEがあり、12モデルは単一のトップレベルSCAD、`20241205_simple_box` のみ旧来の大小2SCAD構成であることを確認した。
- フェーズ1を実施。既存の直下STL・3MFは移動・削除せず維持している。BOSL2 submoduleを初期化後、全13モデルの標準出力STLを再生成した。
- v5のリストレストは、面取り付き `offset_sweep` を明示的に三角形化してからCGAL処理へ渡す。寸法・面取り・クリアランスは維持し、OpenSCAD 2021.01で全6 STLの再生成を確認した。
