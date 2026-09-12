FROM alpine:3.18

# Install dependencies, FreeRADIUS, and Tailscale
RUN apk add --no-cache \
    freeradius \
    freeradius-utils \
    curl \
    ca-certificates \
    bash \
    && curl -fsSL https://tailscale.com/install.sh | sh \
    || (echo "Note: Tailscale install.sh may not work on Alpine, installing from apk..." \
        && apk add --no-cache tailscale)

# Copy configuration and entrypoint
COPY radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose standard RADIUS ports (UDP)
EXPOSE 1812/udp 1813/udp

ENTRYPOINT ["/entrypoint.sh"]
# ... (Keep existing FROM and apt-get update)
RUN apt-get update && apt-get install -y \
    freeradius \
    freeradius-postgresql \
    freeradius-utils \
    curl \
    ca-certificates \
    && curl -fsSL https://tailscale.com/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

# ... (Keep existing COPY lines)
COPY radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY sql.conf /etc/freeradius/3.0/mods-enabled/sql
# ...

