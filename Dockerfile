# Use a reliable base image
FROM debian:bookworm-slim

# Install FreeRADIUS and Certbot
RUN apt-get update && apt-get install -y \
    freeradius \
    freeradius-utils \
    certbot \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration and entrypoint
COPY radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create directory for Let's Encrypt
RUN mkdir -p /etc/letsencrypt

# Expose RadSec port
EXPOSE 2083

ENTRYPOINT ["/entrypoint.sh"]
