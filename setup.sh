#!/bin/bash

source .env

# 1. Create directories
mkdir -p cloudflared traefik letsencrypt



# 2. Generate cloudflared credentials
echo '{
  "AccountTag": "'${CF_ACCOUNT_ID}'",
  "TunnelSecret": "'$(openssl rand -hex 32)'",
  "TunnelID": "'$(uuidgen | tr -d '-')'",
  "TunnelName": "'${CF_TUNNEL_NAME}'"
}' > cloudflared/credentials.json


# Update DNS email
sed -i 's/^\([[:space:]]*email:\)[[:space:]]*.*$/\1 "'$LE_EMAIL'"/' traefik/traefik.yml

# config clouflare tunnel
cat <<EOF > ./cloudflared/config.yml
tunnel: ${CF_TUNNEL_NAME}
credentials-file: /etc/cloudflared/credentials.json
no-autoupdate: true

transport:
  proxy:
    url: http://localhost:8080  # Add proxy if behind firewall
  connectTimeout: 30s
  tcpKeepAlive: 30s
  quic:
    maxIdleTimeout: 30s

ingress:
  - hostname: "*.${CF_ZONE_NAME}"
    service: https://traefik:443
    originRequest:
      connectTimeout: 30s
      originServerName: "${CF_ZONE_NAME}"
      noTLSVerify: false
  - service: http_status:404
EOF

# 3. Start services
docker compose up -d

# 4. Verify certificate issuance (wait 2-3 minutes)
docker logs traefik | grep "certificate obtained"
