#!/bin/bash
set -e

echo "=== Configurando SELinux context para /work0 ==="
semanage fcontext -a -t samba_share_t "/work0(/.*)?"
restorecon -Rv /work0
echo "SELinux context OK"

echo "=== Configurando Firewall ==="
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
echo "Firewall OK"

echo "=== Ativando servicos smb e nmb ==="
systemctl enable --now smb nmb
systemctl is-active smb nmb

echo "=== Testando acesso guest local ==="
smbclient -L localhost -U% 2>&1 | head -20

echo "=== Configuracao fase1 concluida ==="
