# Fase 2 — Samba integrado ao Active Directory (ADS)

> **Status:** Planejado — migração prevista em ~1 semana a partir de 03/05/2026

## Objetivo

Migrar o Samba do modo standalone (fase 1) para membro de domínio Windows (**domain member**), autenticando usuários pelo Active Directory.

## Ambiente alvo

| Item | Valor |
|------|-------|
| Modo Samba | Domain Member (`security = ADS`) |
| Domínio | a definir |
| DC (Domain Controller) | a definir |
| Realm | a definir |
| Autenticação | Kerberos + NTLM |
| ID Mapping | `winbind` |

## Documentos desta fase

1. [Pré-requisitos](pre-requisitos.md) — o que preparar antes da migração
2. [Migração passo a passo](migracao.md) — executar a integração ao domínio
3. [smb.conf](smb.conf) — configuração para modo ADS
4. [Comandos úteis](comandos-uteis.md) — winbind, wbinfo, net ads
5. [Troubleshooting](troubleshooting.md) — problemas comuns no ambiente ADS
