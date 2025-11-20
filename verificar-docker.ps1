Write-Host "=== Verificando instalación de Docker ===" -ForegroundColor Cyan
Write-Host ""

# Verificar Docker
Write-Host "1. Verificando Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "   ✓ Docker instalado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker no está instalado o no está en el PATH" -ForegroundColor Red
    Write-Host "   Por favor, instala Docker Desktop y reinicia la terminal" -ForegroundColor Yellow
    exit 1
}

# Verificar Docker Compose
Write-Host ""
Write-Host "2. Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker compose version
    Write-Host "   ✓ Docker Compose instalado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker Compose no está disponible" -ForegroundColor Red
    exit 1
}

# Verificar que Docker está corriendo
Write-Host ""
Write-Host "3. Verificando que Docker está corriendo..." -ForegroundColor Yellow
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker está corriendo correctamente" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker no está corriendo" -ForegroundColor Red
        Write-Host "   Por favor, inicia Docker Desktop" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "   ✗ No se pudo conectar a Docker" -ForegroundColor Red
    Write-Host "   Por favor, inicia Docker Desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=== ¡Todo listo! Puedes continuar con el siguiente paso ===" -ForegroundColor Green



