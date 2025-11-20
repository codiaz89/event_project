Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Guía: Levantar Proyecto con Docker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Verificar Docker
Write-Host "PASO 1: Verificando Docker..." -ForegroundColor Yellow
Write-Host ""

try {
    $dockerVersion = docker --version 2>&1
    Write-Host "   ✓ Docker encontrado: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Por favor:" -ForegroundColor Yellow
    Write-Host "   1. Descarga Docker Desktop desde: https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    Write-Host "   2. Instala Docker Desktop" -ForegroundColor White
    Write-Host "   3. Inicia Docker Desktop y espera a que esté corriendo" -ForegroundColor White
    Write-Host "   4. Ejecuta este script nuevamente" -ForegroundColor White
    exit 1
}

# Verificar que Docker está corriendo
Write-Host ""
Write-Host "   Verificando que Docker está corriendo..." -ForegroundColor Yellow
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Docker está corriendo" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Docker no está corriendo" -ForegroundColor Red
        Write-Host "   Por favor, inicia Docker Desktop y espera a que esté listo" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "   ✗ No se pudo conectar a Docker" -ForegroundColor Red
    Write-Host "   Por favor, inicia Docker Desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar Docker Compose
Write-Host ""
Write-Host "PASO 2: Verificando Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker compose version 2>&1
    Write-Host "   ✓ Docker Compose encontrado: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Docker Compose no está disponible" -ForegroundColor Red
    Write-Host "   Docker Compose viene incluido con Docker Desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar que estamos en el directorio correcto
Write-Host ""
Write-Host "PASO 3: Verificando estructura del proyecto..." -ForegroundColor Yellow
if (Test-Path "docker-compose.yml") {
    Write-Host "   ✓ docker-compose.yml encontrado" -ForegroundColor Green
} else {
    Write-Host "   ✗ docker-compose.yml no encontrado" -ForegroundColor Red
    Write-Host "   Por favor, ejecuta este script desde la raíz del proyecto" -ForegroundColor Yellow
    exit 1
}

if (Test-Path "backend") {
    Write-Host "   ✓ Directorio backend encontrado" -ForegroundColor Green
} else {
    Write-Host "   ✗ Directorio backend no encontrado" -ForegroundColor Red
    exit 1
}

if (Test-Path "frontend") {
    Write-Host "   ✓ Directorio frontend encontrado" -ForegroundColor Green
} else {
    Write-Host "   ✗ Directorio frontend no encontrado" -ForegroundColor Red
    exit 1
}

# Construir y levantar los servicios
Write-Host ""
Write-Host "PASO 4: Construyendo y levantando los servicios..." -ForegroundColor Yellow
Write-Host "   Esto puede tomar varios minutos la primera vez..." -ForegroundColor White
Write-Host ""

$response = Read-Host "   ¿Deseas continuar? (S/N)"
if ($response -ne "S" -and $response -ne "s" -and $response -ne "Y" -and $response -ne "y") {
    Write-Host "   Operación cancelada" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "   Ejecutando: docker compose up --build" -ForegroundColor Cyan
Write-Host "   (Presiona Ctrl+C para detener los servicios)" -ForegroundColor White
Write-Host ""

# Ejecutar docker compose
docker compose up --build

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ¡Proyecto levantado exitosamente!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Servicios disponibles:" -ForegroundColor Cyan
    Write-Host "  - Backend:  http://localhost:8080" -ForegroundColor White
    Write-Host "  - Swagger:  http://localhost:8080/api/swagger" -ForegroundColor White
    Write-Host "  - Frontend: http://localhost:3000" -ForegroundColor White
    Write-Host ""
    Write-Host "Para detener los servicios, presiona Ctrl+C" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "   ✗ Error al levantar los servicios" -ForegroundColor Red
    Write-Host "   Revisa los mensajes de error arriba" -ForegroundColor Yellow
}

