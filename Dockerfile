# /radius-server/Dockerfile
FROM freeradius/freeradius:latest

# Install Certbot
RUN apt-get update && apt-get install -y certbot

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create directory for Let's Encrypt
RUN mkdir -p /etc/letsencrypt

# Expose RadSec port
EXPOSE 2083

ENTRYPOINT ["/entrypoint.sh"]
