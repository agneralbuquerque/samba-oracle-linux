# Instalação do Samba — Oracle Linux 8.10

## 1. Atualizar o sistema

```bash
dnf update -y
```

## 2. Instalar os pacotes do Samba

```bash
dnf install -y samba samba-common samba-client
```

Verificar a versão instalada:

```bash
samba --version
```

## 3. Habilitar e iniciar os serviços

```bash
systemctl enable --now smb nmb
systemctl status smb nmb
```

## 4. Criar diretório de compartilhamento

```bash
# Exemplo: compartilhamento geral com guest
mkdir -p /srv/samba/publico
chmod 0777 /srv/samba/publico
chown nobody:nobody /srv/samba/publico

# Exemplo: compartilhamento privado por usuário
mkdir -p /srv/samba/privado
chmod 0750 /srv/samba/privado
```

## 5. Configurar o smb.conf

Faça backup do arquivo original e aplique a configuração da fase 1:

```bash
cp /etc/samba/smb.conf /etc/samba/smb.conf.orig
```

Conteúdo do novo `smb.conf` está documentado em [smb.conf](smb.conf).

## 6. Criar usuários Samba

O Samba mantém sua própria base de senhas. O usuário precisa existir no sistema antes:

```bash
# Criar usuário do sistema (sem shell de login)
useradd -M -s /sbin/nologin nome_usuario

# Adicionar o usuário ao Samba e definir senha
smbpasswd -a nome_usuario

# Habilitar o usuário no Samba
smbpasswd -e nome_usuario
```

Listar usuários Samba cadastrados:

```bash
pdbedit -L -v
```

## 7. Configurar SELinux

```bash
# Permitir que o Samba leia/escreva nos diretórios compartilhados
setsebool -P samba_enable_home_dirs on    # se compartilhar home
setsebool -P samba_export_all_rw on      # para diretórios customizados

# Marcar o diretório com o contexto correto
semanage fcontext -a -t samba_share_t "/srv/samba(/.*)?"
restorecon -Rv /srv/samba
```

Verificar contexto:

```bash
ls -lZ /srv/samba
```

## 8. Configurar o Firewall

```bash
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
firewall-cmd --list-services
```

## 9. Validar configuração e reiniciar

```bash
# Testar o smb.conf
testparm

# Reiniciar os serviços
systemctl restart smb nmb
systemctl status smb nmb
```

## 10. Testar acesso

Do próprio servidor:

```bash
smbclient -L localhost -U%          # listar compartilhamentos como guest
smbclient //localhost/publico -U%   # acessar compartilhamento guest
smbclient //localhost/privado -U nome_usuario
```

De um cliente Windows:

```
\\inova\publico
\\inova\privado
```
