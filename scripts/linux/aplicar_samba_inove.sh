#!/usr/bin/env bash
set -euo pipefail

SERVER_HOSTNAME="inove"
SERVER_IP="192.168.1.16"
SHARE_NAME="inove"
SHARE_PATH="/work0/inove"
SMB_CONF="/etc/samba/smb.conf"

if [[ $EUID -ne 0 ]]; then
  echo "Execute como root."
  exit 1
fi

echo "[1/8] Instalando pacotes necessários..."
dnf install -y samba samba-common samba-client policycoreutils-python-utils

echo "[2/8] Ajustando hostname..."
hostnamectl set-hostname "$SERVER_HOSTNAME"

echo "[3/8] Ajustando /etc/hosts..."
grep -q "^${SERVER_IP}[[:space:]]\+${SERVER_HOSTNAME}$" /etc/hosts || echo "${SERVER_IP} ${SERVER_HOSTNAME}" >> /etc/hosts
sed -i "/^127\.0\.1\.1[[:space:]]\+${SERVER_HOSTNAME}$/d" /etc/hosts

echo "[4/8] Criando diretório do compartilhamento..."
mkdir -p "$SHARE_PATH"
chown nobody:nobody "$SHARE_PATH"
chmod 0777 "$SHARE_PATH"

echo "[5/8] Gravando smb.conf..."
cp -a "$SMB_CONF" "${SMB_CONF}.bak.$(date +%Y%m%d_%H%M%S)"
cat > "$SMB_CONF" <<EOF
[global]
   workgroup = WORKGROUP
   server string = Fileserver Inove
   netbios name = inove
   security = user
   map to guest = bad user
   dns proxy = no
   passdb backend = tdbsam

   log file = /var/log/samba/samba.log
   max log size = 50

[inove]
   comment = Compartilhamento Inove
   path = /work0/inove
   browsable = yes
   writable = yes
   guest ok = yes
   guest only = yes
   create mask = 0666
   directory mask = 0777

   vfs objects = recycle full_audit
   recycle:repository = .lixeira
   recycle:keeptree = yes
   recycle:versions = yes
   recycle:touch = yes
   recycle:touch_mtime = yes
   recycle:maxsize = 0
   recycle:exclude = *.tmp *.temp ~$* .DS_Store Thumbs.db

   full_audit:prefix = %u|%I|%m|%S
   full_audit:success = create_file renameat unlinkat mkdirat
   full_audit:failure = connect
   full_audit:facility = LOCAL5
   full_audit:priority = NOTICE
EOF

echo "[6/8] SELinux + firewall..."
setsebool -P samba_export_all_rw on
semanage fcontext -a -t samba_share_t "/work0(/.*)?" || true
restorecon -Rv /work0
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload

echo "[7/8] Configurando auditoria no rsyslog..."
cat > /etc/rsyslog.d/samba_audit.conf <<EOF
local5.notice  /var/log/samba/audit.log
EOF
systemctl restart rsyslog

echo "[8/8] Reiniciando serviços e validando..."
testparm
systemctl enable --now smb nmb
systemctl restart smb nmb
systemctl is-active smb nmb
smbclient -L localhost -U% || true

echo "Concluído. Acesse: \\\\inove\\inove ou \\\\${SERVER_IP}\\inove"
