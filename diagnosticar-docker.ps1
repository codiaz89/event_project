Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Diagnostico de Docker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Docker esta corriendo
Write-Host "1. Verificando estado de Docker..." -ForegroundColor Yellow
docker ps > $null 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   OK Docker esta respondiendo" -ForegroundColor Green
} else {
    Write-Host "   ERROR Docker no esta respondiendo" -ForegroundColor Red
    Write-Host ""
    Write-Host "   SOLUCION:" -ForegroundColor Yellow
    Write-Host "   1. Abre Docker Desktop" -ForegroundColor White
    Write-Host "   2. Espera a que el icono en la bandeja muestre 'Docker Desktop is running'" -ForegroundColor White
    Write-Host "   3. Si no inicia, reinicia Docker Desktop" -ForegroundColor White
    Write-Host "   4. Ejecuta este script nuevamente" -ForegroundColor White
    exit 1
}

# Verificar version de Docker
Write-Host ""
Write-Host "2. Verificando version de Docker..." -ForegroundColor Yellow
$dockerVersion = docker --version
Write-Host "   $dockerVersion" -ForegroundColor White

# Verificar informacion del sistema
Write-Host ""
Write-Host "3. Verificando informacion del sistema Docker..." -ForegroundColor Yellow
docker info > $null 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   OK Docker esta funcionando correctamente" -ForegroundColor Green
} else {
    Write-Host "   ERROR al obtener informacion de Docker" -ForegroundColor Red
    Write-Host ""
    Write-Host "   SOLUCION:" -ForegroundColor Yellow
    Write-Host "   - Reinicia Docker Desktop" -ForegroundColor White
    Write-Host "   - Verifica que WSL 2 este habilitado" -ForegroundColor White
    exit 1
}

# Verificar imagenes existentes
Write-Host ""
Write-Host "4. Verificando imagenes Docker..." -ForegroundColor Yellow
docker images | Select-Object -First 5
Write-Host ""

# Verificar contenedores
Write-Host "5. Verificando contenedores..." -ForegroundColor Yellow
$containers = docker ps -a
if ($containers -match "CONTAINER") {
    Write-Host "   Contenedores encontrados:" -ForegroundColor White
    docker ps -a --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}"
} else {
    Write-Host "   No hay contenedores" -ForegroundColor White
}

# Limpiar recursos si es necesario
Write-Host ""
Write-Host "6. Deseas limpiar recursos Docker? (S/N)" -ForegroundColor Yellow
$response = Read-Host "   Esto eliminara contenedores, imagenes y volumenes no utilizados"
if ($response -eq "S" -or $response -eq "s" -or $response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "   Limpiando recursos..." -ForegroundColor Yellow
    docker system prune -a --volumes -f
    Write-Host "   OK Limpieza completada" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Diagnostico completado" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
