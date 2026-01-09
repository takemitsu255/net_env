FROM nginx:latest

# nginx設定ファイルをコピー
COPY nginx.conf /etc/nginx/nginx.conf

# デフォルトの設定をクリア
RUN rm -f /etc/nginx/conf.d/default.conf

# ヘルスチェック用のディレクトリを作成
RUN mkdir -p /usr/share/nginx/html

# SSL証明書ディレクトリを作成
RUN mkdir -p /etc/nginx/ssl

# ログディレクトリのパーミッション設定
RUN mkdir -p /var/log/nginx && \
    chown -R nginx:nginx /var/log/nginx

# 自己署名SSL証明書を生成（開発用）
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=JP/ST=Tokyo/L=Tokyo/O=Org/CN=localhost"

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
