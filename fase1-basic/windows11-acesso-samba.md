# Windows 11 — Ajustes para acesso ao Samba `\\inove\inove`

Este documento centraliza os ajustes feitos no cliente Windows 11 para permitir acesso ao compartilhamento guest do Samba.

## Cenário validado

- Servidor Samba: `inove`
- IP do servidor: `192.168.1.16`
- Share único: `inove`
- Caminho SMB: `\\inove\inove` ou `\\192.168.1.16\inove`

## Pré-requisitos

- Executar PowerShell **como Administrador**.
- Confirmar conectividade de rede com o servidor.

## 1) Validar rede e porta SMB

```powershell
$server='inove'
$ip='192.168.1.16'

Resolve-DnsName $server -ErrorAction SilentlyContinue
Test-Connection -ComputerName $ip -Count 2
Test-NetConnection -ComputerName $ip -Port 445
```

Critérios esperados:
- DNS resolve `inove` para `192.168.1.16`
- Ping com resposta
- `TcpTestSucceeded : True`

## 2) Ajustes do cliente SMB no Windows 11

```powershell
Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force
Set-SmbClientConfiguration -RequireSecuritySignature $false -Force

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "AllowInsecureGuestAuth" -Type DWord -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "RequireSecureNegotiate" -Type DWord -Value 0 -Force

Restart-Service LanmanWorkstation -Force
```

## 3) Limpar sessões e credenciais antigas

```powershell
net use * /delete /y
cmdkey /delete:192.168.1.16
cmdkey /delete:inove
```

## 4) Testar acesso ao compartilhamento

```powershell
net use \\192.168.1.16\inove /user:guest ""
start \\192.168.1.16\inove
```

Alternativa por nome:

```powershell
net use \\inove\inove /user:guest ""
start \\inove\inove
```

## 5) (Opcional) Mapear unidade de rede

```powershell
net use Z: \\inove\inove /persistent:yes
```

## 6) Troubleshooting rápido

### Erro 53 (caminho de rede não encontrado)
- Verificar DNS e `hosts`
- Testar `\\192.168.1.16\inove`

### Erro 67 (nome de rede não encontrado)
- Validar nome do share (`inove`)
- Rodar `net view \\192.168.1.16`

### Erro 1219 (múltiplas credenciais)
- `net use * /delete /y`
- Remover entradas no `cmdkey`

### Erro 86 (senha incorreta)
- No modo guest usar: `/user:guest ""`
- Limpar credenciais salvas e reconectar

## Observações de segurança

- Para este cenário de laboratório, guest foi habilitado no cliente.
- Em produção, preferir autenticação por usuário/senha e, na fase seguinte, integração ADS.
- SMB1 não é necessário para este cenário; preferir SMB2/SMB3.
