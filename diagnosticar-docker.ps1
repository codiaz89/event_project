Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Diagnóstico de Docker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Docker está corriendo
Write-Host "1. Verificando estado de Docker..." -ForegroundColor Yellow
docker ps > $null 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Docker está respondiendo" -ForegroundColor Green
} else {
    Write-Host "   ✗ Docker no está respondiendo" -ForegroundColor Red
    Write-Host ""
    Write-Host "   SOLUCIÓN:" -ForegroundColor Yellow
    Write-Host "   1. Abre Docker Desktop" -ForegroundColor White
    Write-Host "   2. Espera a que el ícono en la bandeja muestre 'Docker Desktop is running'" -ForegroundColor White
    Write-Host "   3. Si no inicia, reinicia Docker Desktop" -ForegroundColor White
    Write-Host "   4. Ejecuta este script nuevamente" -ForegroundColor White
    exit 1
}

# Verificar versión de Docker
Write-Host ""
Write-Host "2. Verificando versión de Docker..." -ForegroundColor Yellow
$dockerVersion = docker --version
Write-Host "   $dockerVersion" -ForegroundColor White

# Verificar información del sistema
Write-Host ""
Write-Host "3. Verificando información del sistema Docker..." -ForegroundColor Yellow
docker info > $null 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Docker está funcionando correctamente" -ForegroundColor Green
} else {
    Write-Host "   ✗ Error al obtener información de Docker" -ForegroundColor Red
    Write-Host ""
    Write-Host "   SOLUCIÓN:" -ForegroundColor Yellow
    Write-Host "   - Reinicia Docker Desktop" -ForegroundColor White
    Write-Host "   - Verifica que WSL 2 esté habilitado" -ForegroundColor White
    exit 1
}

# Verificar imágenes existentes
Write-Host ""
Write-Host "4. Verificando imágenes Docker..." -ForegroundColor Yellow
docker images | Select-Object -First 5
Write-Host ""

# Verificar contenedores
Write-Host "5. Verificando contenedores..." -ForegroundColor Yellow
$containers = docker ps -a
if ($containers -match "CONTAINER") {
    Write-Host "   Contenedores encontrados:" -ForegroundColor White
    docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
} else {
    Write-Host "   No hay contenedores" -ForegroundColor White
}

# Limpiar recursos si es necesario
Write-Host ""
Write-Host "6. ¿Deseas limpiar recursos Docker? (S/N)" -ForegroundColor Yellow
$response = Read-Host "   Esto eliminará contenedores, imágenes y volúmenes no utilizados"
if ($response -eq "S" -or $response -eq "s" -or $response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "   Limpiando recursos..." -ForegroundColor Yellow
    docker system prune -a --volumes -f
    Write-Host "   ✓ Limpieza completada" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Diagnóstico completado" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

