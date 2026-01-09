FROM nginx:latest

# nginx設定ファイルをコピー
COPY nginx.conf /etc/nginx/nginx.conf

# デフォルトの設定をクリア
RUN rm -f /etc/nginx/conf.d/default.conf

# ヘルスチェック用のディレクトリを作成
RUN mkdir -p /usr/share/nginx/html

# ログディレクトリのパーミッション設定
RUN mkdir -p /var/log/nginx && \
    chown -R nginx:nginx /var/log/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
