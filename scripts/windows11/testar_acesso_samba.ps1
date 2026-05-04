param(
    [string]$ServerName = 'inove',
    [string]$ServerIp = '192.168.1.16',
    [string]$ShareName = 'inove'
)

$ErrorActionPreference = 'Continue'

Write-Host '=== DNS ===' -ForegroundColor Cyan
Resolve-DnsName $ServerName -ErrorAction SilentlyContinue | Select-Object Name,Type,IPAddress

Write-Host '=== PING ===' -ForegroundColor Cyan
Test-Connection -ComputerName $ServerIp -Count 2 -ErrorAction SilentlyContinue | Select-Object Address,IPv4Address,Status,ResponseTime

Write-Host '=== PORTA 445 ===' -ForegroundColor Cyan
Test-NetConnection -ComputerName $ServerIp -Port 445 | Select-Object ComputerName,RemoteAddress,RemotePort,TcpTestSucceeded

Write-Host '=== LISTAR SHARES ===' -ForegroundColor Cyan
cmd /c "net view \\$ServerIp"

Write-Host '=== TESTE DE MAPEAMENTO (GUEST) ===' -ForegroundColor Cyan
cmd /c "net use \\$ServerIp\$ShareName /user:guest \"\""

Write-Host '=== ABRIR EXPLORER ===' -ForegroundColor Cyan
Start-Process "\\$ServerIp\$ShareName"

Write-Host '=== STATUS FINAL DE SESSÕES SMB ===' -ForegroundColor Cyan
Get-SmbConnection | Select-Object ServerName,ShareName,UserName,Dialect,NumOpens
