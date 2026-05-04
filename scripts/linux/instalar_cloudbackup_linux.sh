#!/usr/bin/env bash
set -euo pipefail

# Uso:
#   sudo bash instalar_cloudbackup_linux.sh "https://.../pro-nix.tar.gz"
# ou definir por variável de ambiente:
#   CLOUDBACKUP_URL="https://.../pro-nix.tar.gz" sudo bash instalar_cloudbackup_linux.sh

URL="${1:-${CLOUDBACKUP_URL:-}}"
WORKDIR="/tmp/cloudbackup_install"
ARCHIVE="$WORKDIR/pro-nix.tar.gz"

if [[ -z "$URL" ]]; then
  echo "ERRO: informe a URL do instalador."
  echo "Exemplo: sudo bash instalar_cloudbackup_linux.sh 'https://panel.mspclouds.com/.../pro-nix.tar.gz'"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "ERRO: execute como root (sudo)."
  exit 1
fi

mkdir -p "$WORKDIR"

echo "[1/5] Validando URL..."
HTTP_CODE=$(curl -k -L -s -o /dev/null -w "%{http_code}" "$URL" || true)
if [[ "$HTTP_CODE" != "200" ]]; then
  echo "ERRO: URL inválida ou expirada (HTTP $HTTP_CODE)."
  echo "Dica: gere um novo link no painel MSP/Cloud Backup."
  exit 1
fi

echo "[2/5] Baixando instalador..."
curl -k -L "$URL" -o "$ARCHIVE"

echo "[3/5] Extraindo pacote..."
rm -rf "$WORKDIR/extracted"
mkdir -p "$WORKDIR/extracted"
tar -xzf "$ARCHIVE" -C "$WORKDIR/extracted"

echo "[4/5] Procurando instalador..."
INSTALLER=""
if [[ -f "$WORKDIR/extracted/install.sh" ]]; then
  INSTALLER="$WORKDIR/extracted/install.sh"
else
  INSTALLER=$(find "$WORKDIR/extracted" -maxdepth 4 -type f \( -name "install.sh" -o -name "installer.sh" -o -name "setup.sh" \) | head -1 || true)
fi

if [[ -z "$INSTALLER" ]]; then
  echo "ERRO: não encontrei script de instalação no pacote."
  echo "Conteúdo extraído em: $WORKDIR/extracted"
  find "$WORKDIR/extracted" -maxdepth 3 -type f | head -50
  exit 1
fi

chmod +x "$INSTALLER"

echo "[5/5] Executando instalador: $INSTALLER"
"$INSTALLER"

echo "Concluído."
