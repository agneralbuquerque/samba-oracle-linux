#!/usr/bin/env bash
set -euo pipefail

echo "=== HOSTNAME ==="
hostname

echo "=== RESOLUÇÃO inove ==="
getent ahostsv4 inove | head -3 || true

echo "=== SERVIÇOS ==="
systemctl is-active smb nmb

echo "=== PORTA 445 ==="
ss -lntp | grep ':445' || true

echo "=== SHARES ==="
smbclient -L localhost -U% | sed -n '1,40p'

echo "=== ACESSO SHARE ==="
smbclient //localhost/inove -U% -c 'ls' | sed -n '1,40p'

echo "=== LOG AUDITORIA (últimas 20) ==="
tail -20 /var/log/samba/audit.log || true
