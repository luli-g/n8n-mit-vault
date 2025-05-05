<h1>n8n Vault Integration mit AppRole</h1>

<p>Dieses Projekt zeigt, wie du <code>n8n</code> sicher mit <a href="https://www.vaultproject.io/" target="_blank">HashiCorp Vault</a> betreibst – inklusive automatischem Secret-Zugriff per <strong>AppRole</strong>.</p>

<h2>📁 Projektstruktur</h2>

<pre><code>n8n/
├── .env                         # Vault-Zugangsdaten (mit Platzhaltern)
├── docker-compose.yml          # Docker Setup für n8n mit Vault-Integration
├── docker-entrypoint.sh        # Lädt Secrets zur Laufzeit aus Vault
setup-vault-approle-example.sh  # Interaktives Setup-Skript für Vault
</code></pre>

<hr />

<h2>🔐 Voraussetzungen</h2>

<ul>
  <li>Eine laufende Vault-Instanz (z. B. unter <code>https://vault.example.com</code>)</li>
  <li>Vault ist initialisiert & unsealed</li>
  <li>Du hast ein gültiges Root-Token oder ein Token mit Admin-Rechten</li>
</ul>

<h2>⚙️ Schritt-für-Schritt-Anleitung</h2>

<h3>1. Vault vorbereiten</h3>

<pre><code>chmod +x setup-vault-approle-example.sh
./setup-vault-approle-example.sh
</code></pre>

<p>Dieses Skript:</p>
<ul>
  <li>schreibt Secrets in Vault (z. B. Basic Auth)</li>
  <li>erstellt eine Policy</li>
  <li>konfiguriert eine AppRole</li>
  <li>zeigt dir <code>role_id</code> und <code>secret_id</code></li>
</ul>

<h3>2. .env Datei anpassen</h3>

<p>Bearbeite <code>n8n/.env</code> und trage deine Daten ein:</p>

<pre><code>VAULT_ADDR=https://vault.example.com
VAULT_ROLE_ID=xxx-your-role-id
VAULT_SECRET_ID=xxx-your-secret-id
</code></pre>

<h3>3. n8n starten</h3>

<pre><code>cd n8n
docker compose up -d
</code></pre>

<hr />

<h2>🔎 Wie funktioniert das?</h2>

<p>Beim Start ruft <code>docker-entrypoint.sh</code>:</p>

<ol>
  <li>ein Vault-Token per AppRole ab</li>
  <li>liest die Secrets mit <code>curl</code> + <code>jq</code></li>
  <li>setzt alle Secrets als Umgebungsvariablen für <code>n8n</code></li>
</ol>

<h2>✅ Vorteile</h2>

<ul>
  <li>Kein Hardcoded Password mehr im Compose-File</li>
  <li>Tokens rotieren automatisch</li>
  <li>Vault-Policy regelt Zugriff auf genau definierte Secrets</li>
</ul>

<h2>🛡️ Hinweis</h2>

<p>Dieses Projekt ist als <strong>Beispiel</strong> gedacht.<br>
Für Produktion: TLS mit Zertifikat, Vault-Agent oder Kubernetes-Integration nutzen.</p>

<h2>✨ Lizenz</h2>
<p>MIT License</p>
