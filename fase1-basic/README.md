# Fase 1 — Samba Standalone (autenticação local + guest)

Configuração inicial do Samba em modo **standalone** com:
- Acesso por **usuário e senha** local (contas do sistema)
- Acesso **guest** (sem senha) para compartilhamentos públicos

## Ambiente

| Item | Valor |
|------|-------|
| Hostname | `inova` |
| FQDN | `fileserver-inova-2cri-mcp.7locacoes.vpn` |
| SO | Oracle Linux Server 8.10 |
| Kernel | `5.15.0-206.153.7.1.el8uek.x86_64` |
| Disco `/` | 40 GB (6% usado) |
| RAM | 7.5 GiB |
| CPUs | 4 |
| SELinux | enabled / enforcing |
| Firewall | firewalld (running) |
| Samba | standalone (sem domínio) |

## Documentos desta fase

1. [Instalação](instalacao.md) — instalar e habilitar o Samba
2. [smb.conf](smb.conf) — arquivo de configuração completo comentado
3. [Comandos úteis](comandos-uteis.md) — testes, diagnóstico e gerenciamento
4. [Troubleshooting](troubleshooting.md) — problemas comuns e soluções
