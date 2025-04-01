# 🌐 Cloudflare + Traefik: Zero-Exposure Proxy
Secure reverse proxy with no open ports using Cloudflare Tunnels and Traefik. Perfect for self-hosting with enterprise-grade security.

## 🔥 Key Features

- 🚫 No open ports – All traffic flows through Cloudflare’s encrypted tunnels (no inbound firewall rules).
- 🔒 Zero Trust ready – Origin server IP stays hidden; no direct internet exposure.
- 🤖 Fully automated – Wildcard TLS certificates via Cloudflare DNS challenges.
- 🚀 Production-optimized – TLS 1.3, security headers, and health checks.
- 🛠️ How It Works

```mermaid
graph LR  
  A[User] -->|HTTPS| B[Cloudflare Edge]  
  B -->|QUIC Tunnel| C[cloudflared]  
  C -->|Internal HTTPS| D[Traefik]  
  D -->|HTTPS| E[Your Services]  
```

## 🚀 Quick Start

### Prerequisites

Cloudflare account with a domain (example.com)
Docker installed

### Setup
1. Clone the repo:
```bash
git clone https://github.com/your-repo/cloudflare-traefik.git  
cd cloudflare-traefik  
```

2. Configure environment:
```bash
cp .env.example .env  
# Edit .env with your Cloudflare API token, email, and domain  
```

3. Deploy
```bash
./setup
```
