# CLAUDE.md

このファイルは、このリポジトリでコードを操作する際のClaude Code (claude.ai/code) へのガイダンスを提供します。

**重要**: このファイルを編集する際は日本語で記述してください。

## プロジェクト構成

TerraformによるInfrastructure as CodeとシンプルなGoウェブアプリケーションのサンプルプロジェクトです：

- `app/` - ポート3003でHTTPサーバーを提供するGoウェブアプリケーション
- `terraform/` - インフラ設定ファイル
  - `module/` - 再利用可能なTerraformモジュール
  - `production/` - 本番環境設定
  - `development/` - 開発環境設定

## 開発コマンド

### Goアプリケーション
- **アプリケーション実行**: `cd app && go run main.go`
- **アプリケーションビルド**: `cd app && go build -o main .`
- **テスト実行**: `cd app && go test ./...`

Goアプリケーションは以下の特徴を持つシンプルなHTTPサーバーです：
- ポート3003でリッスン
- ルートパス `/` で "hello world" レスポンスを返す
- 手動でTCPリスナーを設定する標準のGo net/httpライブラリを使用

### Terraform
- **開発環境**: `cd terraform/development && terraform plan/apply`
- **本番環境**: `cd terraform/production && terraform plan/apply`
- **モジュール**: `terraform/module/` 内の再利用可能なモジュール

## 開発戦略

Terraformの開発は以下の順序で進める：

1. **development** 環境でまずコードを書く
2. 動作確認後、共通部分を **module** に切り出す
3. **production** 環境を整理し、moduleを活用して構成する

この戦略により、まず動作するコードを作成してから、再利用可能な形に整理することができる。

## アーキテクチャ注記

Goアプリケーションは、シンプルな `http.ListenAndServe()` ではなく手動でTCPリスナーを作成することで、低レベルなHTTPサーバー設定を実装しています。このアプローチにより、サーバーのライフサイクルと接続処理をより細かく制御できます。