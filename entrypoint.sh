#!/bin/sh

cat > /etc/nginx/conf.d/vps.conf << EOF
  server {
  listen 80;
  server_name ${NGX_DOMAIN};
  #
  location / {
          proxy_pass http://127.0.0.1:8000;
          proxy_set_header   Host             \$host;
          proxy_set_header   Referer          \$http_referer;
          proxy_set_header   Cookie           \$http_cookie;
          proxy_set_header   X-Real-IP        \$remote_addr;
          proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
          proxy_redirect off;
      }
  }
EOF

nginx -c /etc/nginx/nginx.conf

exec "$@"
