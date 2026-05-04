#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'

$ServerName = 'inove'
$ServerIp = '192.168.1.16'
$ShareName = 'inove'

Write-Host '== Ajustando cliente SMB (Windows 11) ==' -ForegroundColor Cyan
Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force
Set-SmbClientConfiguration -RequireSecuritySignature $false -Force

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'AllowInsecureGuestAuth' -Type DWord -Value 1 -Force
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'RequireSecureNegotiate' -Type DWord -Value 0 -Force

Write-Host '== Limpando sessões/credenciais antigas ==' -ForegroundColor Cyan
cmd /c 'net use * /delete /y' | Out-Null
cmdkey /delete:$ServerIp 2>$null | Out-Null
cmdkey /delete:$ServerName 2>$null | Out-Null

Write-Host '== Reiniciando serviço LanmanWorkstation ==' -ForegroundColor Cyan
Restart-Service LanmanWorkstation -Force

Write-Host '== Validando conectividade ==' -ForegroundColor Cyan
Resolve-DnsName $ServerName -ErrorAction SilentlyContinue | Select-Object Name,Type,IPAddress
Test-Connection -ComputerName $ServerIp -Count 2 | Select-Object Address,IPv4Address,ResponseTime
Test-NetConnection -ComputerName $ServerIp -Port 445 | Select-Object ComputerName,RemoteAddress,RemotePort,TcpTestSucceeded

Write-Host 'Concluído. Teste agora:' -ForegroundColor Green
Write-Host "  \\$ServerName\$ShareName"
Write-Host "  \\$ServerIp\$ShareName"
