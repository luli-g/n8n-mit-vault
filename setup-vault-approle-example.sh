#!/bin/bash

echo "🔐 Vault AppRole Setup für n8n (mit Beispielwerten)"
read -p "Vault-Adresse (z. B. https://vault.example.com): " VAULT_ADDR
read -p "Name des Secrets (z. B. n8n): " SECRET_PATH
read -p "Basic Auth Benutzername: " BASIC_USER
read -p "Basic Auth Passwort: " BASIC_PASS
read -p "Webhook-URL (z. B. https://n8n.example.com): " WEBHOOK_URL
read -p "AppRole-Name (z. B. n8n): " ROLE_NAME
read -p "Policy-Name (z. B. n8n-policy): " POLICY_NAME

echo "📦 Schreibe Secret nach Vault..."
vault kv put secret/${SECRET_PATH} \
  basic_auth_user="${BASIC_USER}" \
  basic_auth_password="${BASIC_PASS}" \
  webhook_url="${WEBHOOK_URL}"

echo "🛡️ Erstelle Policy-Datei..."
cat <<EOF > ${POLICY_NAME}.hcl
path "secret/data/${SECRET_PATH}" {
  capabilities = ["read"]
}
EOF

echo "✅ Lade Policy hoch..."
vault policy write ${POLICY_NAME} ${POLICY_NAME}.hcl

echo "🔐 Aktiviere AppRole falls nötig..."
vault auth enable approle 2>/dev/null || echo "AppRole war bereits aktiv."

echo "🔑 Erstelle AppRole..."
vault write auth/approle/role/${ROLE_NAME} \
  token_policies="${POLICY_NAME}" \
  token_ttl="1h" \
  token_max_ttl="24h" \
  secret_id_ttl="24h" \
  secret_id_num_uses=10

echo "🆔 AppRole-Zugangsdaten:"
vault read auth/approle/role/${ROLE_NAME}/role-id
vault write -f auth/approle/role/${ROLE_NAME}/secret-id

echo "✅ Fertig. Nutze diese Daten in deiner .env-Datei oder im Deployment."
