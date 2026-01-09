# Nginx Docker環境セットアップガイド

## ディレクトリ構成
```
net_env/
├── Dockerfile              # Nginxコンテナイメージの定義
├── docker-compose.yml      # コンテナ実行設定
├── nginx.conf             # Nginx基本設定
├── conf.d/
│   └── default.conf       # サイト設定
├── logs/                  # ログディレクトリ（自動作成）
└── README.md
```

## セットアップ手順

### 1. メインアプリケーションの準備
別のリポジトリから取得したアプリケーションを以下の場所に配置してください：
```bash
cd ../
git clone <別リポジトリURL> main_app
cd net_env
```

### 2. Dockerイメージのビルドと起動
```bash
# イメージのビルド
docker-compose build

# コンテナの起動
docker-compose up -d

# ログの確認
docker-compose logs -f nginx
```

### 3. 停止と削除
```bash
# コンテナの停止
docker-compose stop

# コンテナの削除
docker-compose down

# ボリュームも削除
docker-compose down -v
```

## ボリュームマウント設定

`docker-compose.yml`では以下の設定でメインアプリケーションをマウントしています：

```yaml
volumes:
  - ../main_app:/usr/share/nginx/html:ro
```

- `../main_app`: 別リポジトリから取得したディレクトリのパス
- `/usr/share/nginx/html`: コンテナ内でのマウントパス
- `ro`: 読み取り専用モード

必要に応じてパスを調整してください。

## Nginx設定のカスタマイズ

### サイト固有の設定
`conf.d/default.conf`でサーバーブロックを定義できます。

### 複数サイトの運用
複数のドメイン/サイトを運用する場合は、`conf.d/`に別の設定ファイルを追加してください：
```bash
conf.d/
├── default.conf
├── site1.conf
└── site2.conf
```

## アクセステスト

```bash
# Webサーバーへのアクセス
curl http://localhost/

# ヘルスチェック
curl http://localhost/health
```

## ログ確認

```bash
# リアルタイムログ
docker-compose logs -f nginx

# ホスト側のログディレクトリ
cat logs/access.log
cat logs/error.log
```

## トラブルシューティング

### ポート80が既に使用されている場合
`docker-compose.yml`の`ports`セクションを変更：
```yaml
ports:
  - "8080:80"  # ホスト側のポート:コンテナ側のポート
```

### マウントがうまくいかない場合
パスが正しいか確認：
```bash
# 親ディレクトリの構造確認
ls -la ../
```

### Nginxが起動しない場合
設定ファイルの文法をチェック：
```bash
docker-compose exec nginx nginx -t
```
