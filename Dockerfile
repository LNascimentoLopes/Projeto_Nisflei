
FROM nginx:1.27-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/index.html

RUN cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    gzip on;
    gzip_types text/html text/css application/javascript;

    location / {
        try_files \$uri \$uri/ /index.html;
        add_header Cache-Control "no-cache";
    }

    location /health {
        return 200 '{"status":"ok","service":"flowlog-onepage"}';
        add_header Content-Type application/json;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
