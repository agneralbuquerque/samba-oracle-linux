# Fase 1 — Samba Standalone (acesso guest)

Configuração inicial do Samba em modo **standalone** com **compartilhamento único guest**.

## Ambiente

| Item | Valor |
|------|-------|
| Hostname | `inove` |
| FQDN | `inove` |
| SO | Oracle Linux Server 8.10 |
| Kernel | `5.15.0-206.153.7.1.el8uek.x86_64` |
| Disco `/` | 40 GB (6% usado) |
| RAM | 7.5 GiB |
| CPUs | 4 |
| SELinux | enabled / enforcing |
| Firewall | firewalld (running) |
| Samba | standalone (sem domínio) |

Compartilhamento atual publicado: `inove` em `/work0/inove`.

## Cliente Windows 11

- Ajustes e validações do cliente em [windows11-acesso-samba.md](windows11-acesso-samba.md)

## Documentos desta fase

1. [Instalação](instalacao.md) — instalar e habilitar o Samba
2. [smb.conf](smb.conf) — arquivo de configuração completo comentado
3. [Comandos úteis](comandos-uteis.md) — testes, diagnóstico e gerenciamento
4. [Troubleshooting](troubleshooting.md) — problemas comuns e soluções
