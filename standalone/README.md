# DocuSeal Standalone Stack

This directory contains a standalone Docker stack for running DocuSeal on a NAS or offline environment.

## Prerequisites

1.  **Docker** and **Docker Compose** installed.
2.  The **DocuSeal source code** (this directory should be inside the DocuSeal repository root).
3.  **Internet access** (initial setup only) to download artifacts (fonts, ONNX model, PDFium).

## Setup

1.  Run the setup script:
    ```bash
    chmod +x scripts/setup.sh
    ./scripts/setup.sh
    ```
    This will:
    - Download necessary artifacts to `artifacts/` if missing.
    - Build the DocuSeal Docker image using local artifacts.
    - Start the stack (App + Postgres + Caddy).

2.  Access the application at `https://localhost` (or your NAS IP).
    - Caddy is configured to use internal self-signed certificates. You may need to accept the security warning in your browser.

## Directory Structure

- `artifacts/`: Stores downloaded dependencies (fonts, ONNX, PDFium).
- `config/`: Configuration files (e.g., Caddyfile).
- `scripts/`: Helper scripts for setup and maintenance.
- `Dockerfile`: Custom Dockerfile for standalone build.
- `docker-compose.yml`: Docker Compose definition.

## Customization

- **Domain**: Edit `docker-compose.yml` environment variable `DOMAIN_NAME` and `config/Caddyfile` if you have a real domain.
- **Ports**: Edit `docker-compose.yml` to change exposed ports.

## Bootstrap admin user (optional)

Create/update an admin user for test environments:

```bash
docker cp ./standalone/scripts/bootstrap_admin.rb standalone-app-1:/tmp/bootstrap_admin.rb && \
docker exec -e BOOTSTRAP_ADMIN_EMAIL="rimedinaz@gmail.com" \
  -e BOOTSTRAP_ADMIN_PASSWORD="Secret123!" \
  -e BOOTSTRAP_ADMIN_NAME="Richard Medina" \
  standalone-app-1 sh -lc "cd /app && bundle exec rails runner /tmp/bootstrap_admin.rb"
```
