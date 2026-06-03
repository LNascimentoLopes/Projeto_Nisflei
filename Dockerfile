
FROM nginx:1.27-alpine


LABEL maintainer="Lucas Nascimento Lopes <lucas@flowlog.com.br>" \
      version="1.0.0" \
      description="FlowLog One-Page – Case 4 Logistica E-commerce"

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/index.html

RUN printf 'server {\n\
    listen 80;\n\
    server_name _;\n\
\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
\n\
    gzip on;\n\
    gzip_types text/html text/css application/javascript;\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
        add_header Cache-Control "no-cache";\n\
    }\n\
\n\
    # Health-check endpoint (usado pelo pipeline e pelo CloudWatch)\n\
    location /health {\n\
        return 200 '"'"'{"status":"ok","service":"flowlog-onepage"}'"'"';\n\
        add_header Content-Type application/json;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
