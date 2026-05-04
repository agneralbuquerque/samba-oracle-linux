# Samba no Oracle Linux 8.10 — Documentação de Configuração

Repositório para documentar a instalação e configuração do Samba em Oracle Linux 8.10.

## Fases do projeto

| Fase | Status | Descrição |
|------|--------|-----------|
| [Fase 1 — Básico (user/senha + guest)](fase1-basic/README.md) | ✅ Em andamento | Samba standalone com autenticação local e acesso guest |
| [Fase 2 — Integração ao Active Directory](fase2-ads/README.md) | 🕐 Planejado (~1 semana) | Samba integrado ao domínio Windows (ADS) |

## Ambiente

- **SO:** Oracle Linux 8.10
- **Samba:** versão a documentar
- **Kernel:** a documentar (`uname -r`)

## Estrutura do repositório

```
samba-oracle-linux/
├── README.md                  # Este arquivo
├── fase1-basic/
│   ├── README.md              # Visão geral da fase 1
│   ├── instalacao.md          # Passos de instalação
│   ├── smb.conf               # Arquivo de configuração (fase 1)
│   ├── comandos-uteis.md      # Comandos de diagnóstico e teste
│   ├── troubleshooting.md     # Problemas conhecidos e soluções
│   └── windows11-acesso-samba.md # Ajustes e validações no cliente Windows 11
└── fase2-ads/
    ├── README.md              # Visão geral da fase 2
    ├── pre-requisitos.md      # O que preparar antes da migração
    ├── migracao.md            # Passo a passo da migração para ADS
    ├── smb.conf               # Arquivo de configuração (fase 2 - ADS)
    ├── comandos-uteis.md      # Comandos específicos para ADS
    └── troubleshooting.md     # Problemas conhecidos no ambiente ADS

└── scripts/
    ├── linux/
    │   ├── aplicar_samba_inove.sh   # Automatiza setup do Samba no servidor
    │   └── validar_samba_inove.sh   # Validação rápida do servidor Samba
    └── windows11/
        ├── configurar_cliente_samba.ps1 # Ajustes do cliente Windows 11
        └── testar_acesso_samba.ps1      # Testes de conectividade e acesso
```

## Execução rápida (scripts)

- Servidor Linux: `sudo bash scripts/linux/aplicar_samba_inove.sh`
- Validação Linux: `sudo bash scripts/linux/validar_samba_inove.sh`
- Cliente Windows 11 (Admin): `./scripts/windows11/configurar_cliente_samba.ps1`
- Testes Windows 11: `./scripts/windows11/testar_acesso_samba.ps1`

## Referências rápidas

- [Samba Documentation](https://www.samba.org/samba/docs/)
- [Oracle Linux 8 — Firewall & SELinux](https://docs.oracle.com/en/operating-systems/oracle-linux/8/)
- [Red Hat — Configuring Samba as a standalone server](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/assembly_using-samba-as-a-server_deploying-different-types-of-servers)
