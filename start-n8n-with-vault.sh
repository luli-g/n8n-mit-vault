#!/bin/sh

# ================================
# Vault Login per AppRole
# ================================
VAULT_TOKEN=$(curl -s --request POST \
  --data "{\"role_id\": \"${VAULT_ROLE_ID}\", \"secret_id\": \"${VAULT_SECRET_ID}\"}" \
  "${VAULT_ADDR}/v1/auth/approle/login" | jq -r '.auth.client_token')

# ================================
# Secrets aus Vault lesen und exportieren
# ================================
eval $(curl -s \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  "${VAULT_ADDR}/v1/secret/data/n8n" | jq -r '.data.data | to_entries | map("export \(.key)=\(.value)") | .[]')

# ================================
# n8n starten
# ================================
exec n8n

# ================================
# Hinweis: Beispiel docker-compose.yml
# ================================
: <<'DOCKER_COMPOSE_EXAMPLE'
services:
  n8n:
    image: n8nio/n8n
    container_name: n8n
    ports:
      - "5678:5678"
    restart: unless-stopped
    env_file:
      - .env
    volumes:
      - ./start-n8n-with-vault.sh:/docker-entrypoint.sh
    entrypoint: ["/docker-entrypoint.sh"]
DOCKER_COMPOSE_EXAMPLE
