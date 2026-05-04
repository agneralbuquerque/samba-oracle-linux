# Comandos Úteis — Samba fase1

## Status dos serviços

```bash
systemctl status smb nmb
systemctl is-active smb nmb
```

## Testar configuração

```bash
testparm            # valida o smb.conf
testparm -s         # exibe configuração efetiva (sem comentários)
```

## Listar compartilhamentos

```bash
# Do próprio servidor (guest)
smbclient -L localhost -U%

# De outro Linux na rede
smbclient -L //inove -U%
```

## Acessar compartilhamento via terminal

```bash
# Guest
smbclient //inove/inove -U%
```

## Gerenciar usuários Samba

```bash
# Criar usuário do sistema (sem shell)
useradd -M -s /sbin/nologin nome_usuario

# Adicionar ao grupo samba_users
usermod -aG samba_users nome_usuario

# Definir senha Samba
smbpasswd -a nome_usuario

# Habilitar usuário
smbpasswd -e nome_usuario

# Desabilitar usuário
smbpasswd -d nome_usuario

# Excluir usuário do Samba
smbpasswd -x nome_usuario

# Listar todos os usuários Samba
pdbedit -L
pdbedit -L -v   # detalhado
```

## Monitoramento e logs

```bash
# Conexões ativas
smbstatus

# Usuários conectados
smbstatus -S

# Logs
tail -f /var/log/samba/samba.log

# Processos Samba
ps aux | grep -E 'smbd|nmbd'
```

## SELinux

```bash
# Verificar contexto dos diretórios
ls -lZ /work0

# Verificar booleans ativos
getsebool -a | grep samba

# Reaplicar contexto (após mover arquivos)
restorecon -Rv /work0
```

## Firewall

```bash
# Verificar regras Samba
firewall-cmd --list-services

# Adicionar regra (se necessário)
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
```

## Reiniciar / recarregar

```bash
# Recarregar configuração sem derrubar conexões
smbcontrol all reload-config

# Reiniciar serviços
systemctl restart smb nmb
```

## Disco /work0

```bash
df -h /work0
du -sh /work0/*
lsblk /dev/sdb
```
