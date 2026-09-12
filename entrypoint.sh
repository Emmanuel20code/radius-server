#!/bin/bash
# /radius-server/entrypoint.sh

# 1. Obtain/Renew certificate
# Ensure your DOMAIN is set via environment variable in Railway
if [ ! -f /etc/letsencrypt/live/${RADIUS_DOMAIN}/fullchain.pem ]; then
    certbot certonly --standalone \
      --non-interactive \
      --agree-tos \
      --email ${ADMIN_EMAIL} \
      -d ${RADIUS_DOMAIN} \
      --http-01-port 8080
fi

# 2. Start FreeRADIUS in foreground
radiusd -f -X
