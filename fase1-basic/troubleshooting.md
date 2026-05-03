# Troubleshooting — Samba fase1

## full_audit: Invalid success operations list

**Erro no log:**
```
init_bitmap: Could not find opname rename
smb_full_audit_connect: Invalid success operations list. Failing connect
```

**Causa:** No Samba 4.19+ os nomes das operações VFS mudaram para o padrão `*at()`.

**Solução:** Usar os novos nomes:

| Antigo | Novo (4.19+) |
|--------|-------------|
| `rename` | `renameat` |
| `unlink` | `unlinkat` |
| `mkdir` | `mkdirat` |
| `rmdir` | (removido — coberto por `unlinkat`) |

Configuração correta:
```ini
full_audit:success = create_file renameat unlinkat mkdirat
```

---

## NT_STATUS_UNSUCCESSFUL ao conectar no share

**Causa mais comum:** `full_audit` com operações inválidas bloqueia o `tree connect`.

**Diagnóstico:**
```bash
tail -30 /var/log/samba/samba.log
```

**Solução:** Corrigir as operações no `smb.conf` e reiniciar:
```bash
testparm    # validar antes de reiniciar
systemctl restart smb nmb
```

---

## SELinux bloqueando acesso

**Sintoma:** `NT_STATUS_ACCESS_DENIED` sem erros no smb.log.

**Diagnóstico:**
```bash
ausearch -m avc -ts recent
```

**Solução:**
```bash
setsebool -P samba_export_all_rw on
semanage fcontext -a -t samba_share_t "/work0(/.*)?"
restorecon -Rv /work0
```

---

## Lixeira não criada automaticamente

**Causa:** O diretório `.lixeira` é criado pelo Samba na primeira deleção. Se não aparecer, verificar:

1. `vfs objects = recycle full_audit` está definido no share
2. O usuário (ou `nobody`) tem permissão de escrita no diretório pai
3. SELinux: contexto `samba_share_t` aplicado

---

## Serviço smbd não inicia

```bash
# Ver erro detalhado
systemctl status smb -l

# Testar config antes de reiniciar
testparm

# Ver log completo
tail -50 /var/log/samba/samba.log
```

---

## Auditoria não aparece no log

**Verificar:**
```bash
# Arquivo de configuração rsyslog
cat /etc/rsyslog.d/samba_audit.conf
# Deve conter: local5.notice  /var/log/samba/audit.log

# Verificar se rsyslog está ativo
systemctl is-active rsyslog

# Testar manualmente
logger -p local5.notice "teste auditoria samba"
tail -5 /var/log/samba/audit.log
```
