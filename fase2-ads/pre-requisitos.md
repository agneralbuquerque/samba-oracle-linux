# Pré-requisitos — Integração Samba ao Active Directory

## 1. Informações necessárias antes de começar

Coletar e anotar antes da migração:

| Informação | Valor | Onde obter |
|-----------|-------|-----------|
| Nome do domínio (NetBIOS) | ex: `EMPRESA` | Administrador AD |
| Realm (FQDN do domínio) | ex: `empresa.local` | Administrador AD |
| IP do Domain Controller | ex: `192.168.1.1` | Administrador AD |
| Hostname do DC | ex: `dc01.empresa.local` | Administrador AD |
| Conta com permissão para join | ex: `Administrator` | Administrador AD |
| OU para os computadores | ex: `CN=Computers,DC=empresa,DC=local` | Administrador AD |

## 2. Pacotes a instalar

```bash
dnf install -y samba-winbind samba-winbind-clients \
               krb5-workstation samba-common-tools \
               oddjob-mkhomedir
```

## 3. DNS — apontar para o DC

O servidor precisa resolver o domínio AD. Editar `/etc/resolv.conf` ou configurar via NetworkManager:

```bash
# Verificar resolução do domínio
nslookup empresa.local
nslookup _ldap._tcp.empresa.local

# Verificar SRV records do AD
host -t SRV _kerberos._tcp.empresa.local
host -t SRV _ldap._tcp.empresa.local
```

## 4. Sincronização de horário (NTP)

**Crítico:** diferença de mais de 5 minutos em relação ao DC causa falha de autenticação Kerberos.

```bash
dnf install -y chrony
systemctl enable --now chronyd

# Apontar para o DC como servidor NTP (ou servidor NTP da rede)
# Editar /etc/chrony.conf:
# server dc01.empresa.local iburst

chronyc tracking  # verificar sincronização
timedatectl       # verificar status do NTP
```

## 5. Hostname — verificar nome do servidor

```bash
hostnamectl set-hostname fileserver-inova-2cri-mcp.7locacoes.vpn
hostname -f   # deve retornar o FQDN completo
```

## 6. Firewall — portas adicionais

Para ingressar no domínio, as seguintes portas devem estar liberadas em direção ao DC:

| Porta | Protocolo | Serviço |
|-------|-----------|---------|
| 88 | TCP/UDP | Kerberos |
| 389 | TCP/UDP | LDAP |
| 445 | TCP | SMB |
| 636 | TCP | LDAPS |
| 3268-3269 | TCP | Global Catalog |

```bash
firewall-cmd --permanent --add-service=samba --add-service=kerberos
firewall-cmd --permanent --add-port=3268-3269/tcp
firewall-cmd --reload
```

## 7. Backup da fase 1

Antes de migrar, fazer backup completo da configuração atual:

```bash
cp /etc/samba/smb.conf /etc/samba/smb.conf.fase1.bak
cp /etc/krb5.conf /etc/krb5.conf.bak 2>/dev/null || true
pdbedit -e samba_backup_fase1.tar  # exportar base de usuários locais
```

## 8. Checklist pré-migração

- [ ] Informações do AD coletadas (domínio, realm, IP do DC)
- [ ] DNS apontando para o DC
- [ ] NTP sincronizado com o DC (diferença < 5 min)
- [ ] Hostname FQDN configurado corretamente
- [ ] Pacotes `samba-winbind` e `krb5-workstation` instalados
- [ ] Backup da fase 1 realizado
- [ ] Janela de manutenção agendada (serviço ficará indisponível durante o join)
