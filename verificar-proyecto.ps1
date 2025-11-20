Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verificacion del Proyecto" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar contenedores
Write-Host "1. Verificando contenedores Docker..." -ForegroundColor Yellow
$containers = docker ps --filter "name=event-platform" --format "{{.Names}}\t{{.Status}}\t{{.Ports}}"
if ($containers) {
    Write-Host "   Contenedores activos:" -ForegroundColor Green
    docker ps --filter "name=event-platform" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
} else {
    Write-Host "   ERROR: No se encontraron contenedores activos" -ForegroundColor Red
    Write-Host "   Ejecuta: docker compose up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 2. Verificar logs recientes
Write-Host "2. Verificando logs del backend (ultimas 10 lineas)..." -ForegroundColor Yellow
$backendLogs = docker logs event-platform-backend-1 --tail 10 2>&1
if ($backendLogs -match "Started EventBackendApplication" -or $backendLogs -match "Tomcat started") {
    Write-Host "   OK: Backend iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "   ADVERTENCIA: Backend puede no estar completamente iniciado" -ForegroundColor Yellow
    Write-Host "   Revisa los logs con: docker logs event-platform-backend-1" -ForegroundColor White
}

Write-Host ""

Write-Host "3. Verificando logs del frontend (ultimas 10 lineas)..." -ForegroundColor Yellow
$frontendLogs = docker logs event-platform-frontend-1 --tail 10 2>&1
if ($frontendLogs -match "Nest application successfully started" -or $frontendLogs -match "listening") {
    Write-Host "   OK: Frontend iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "   ADVERTENCIA: Frontend puede no estar completamente iniciado" -ForegroundColor Yellow
    Write-Host "   Revisa los logs con: docker logs event-platform-frontend-1" -ForegroundColor White
}

Write-Host ""

# 3. Verificar endpoints
Write-Host "4. Verificando endpoints..." -ForegroundColor Yellow

# Backend - Swagger
Write-Host "   Probando Swagger UI (backend)..." -ForegroundColor White
try {
    $swaggerResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/swagger" -Method GET -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($swaggerResponse.StatusCode -eq 200) {
        Write-Host "   OK: Swagger UI accesible en http://localhost:8080/api/swagger" -ForegroundColor Green
    }
} catch {
    Write-Host "   ERROR: No se pudo acceder a Swagger UI" -ForegroundColor Red
}

# Backend - API Docs
Write-Host "   Probando API Docs (backend)..." -ForegroundColor White
try {
    $docsResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/docs" -Method GET -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($docsResponse.StatusCode -eq 200) {
        Write-Host "   OK: API Docs accesible en http://localhost:8080/api/docs" -ForegroundColor Green
    }
} catch {
    Write-Host "   ERROR: No se pudo acceder a API Docs" -ForegroundColor Red
}

# Backend - Login
Write-Host "   Probando endpoint de login..." -ForegroundColor White
try {
    $loginBody = @{
        username = "admin"
        password = "admin123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($loginResponse.StatusCode -eq 200) {
        $tokenData = $loginResponse.Content | ConvertFrom-Json
        if ($tokenData.jwtToken) {
            Write-Host "   OK: Login funcionando correctamente" -ForegroundColor Green
            $script:jwtToken = $tokenData.jwtToken
        }
    }
} catch {
    Write-Host "   ERROR: No se pudo realizar login" -ForegroundColor Red
    Write-Host "   Detalles: $($_.Exception.Message)" -ForegroundColor Gray
}

# Frontend
Write-Host "   Probando frontend..." -ForegroundColor White
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 5 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "   OK: Frontend accesible en http://localhost:3000" -ForegroundColor Green
    }
} catch {
    Write-Host "   ERROR: No se pudo acceder al frontend" -ForegroundColor Red
}

Write-Host ""

# 4. Resumen
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Resumen" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "URLs disponibles:" -ForegroundColor Yellow
Write-Host "  - Backend API: http://localhost:8080" -ForegroundColor White
Write-Host "  - Swagger UI: http://localhost:8080/api/swagger" -ForegroundColor White
Write-Host "  - API Docs: http://localhost:8080/api/docs" -ForegroundColor White
Write-Host "  - Frontend: http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Credenciales por defecto:" -ForegroundColor Yellow
Write-Host "  - Usuario: admin" -ForegroundColor White
Write-Host "  - Password: admin123" -ForegroundColor White
Write-Host ""
Write-Host "Comandos utiles:" -ForegroundColor Yellow
Write-Host "  - Ver logs backend: docker logs event-platform-backend-1 -f" -ForegroundColor White
Write-Host "  - Ver logs frontend: docker logs event-platform-frontend-1 -f" -ForegroundColor White
Write-Host "  - Detener servicios: docker compose down" -ForegroundColor White
Write-Host "  - Reiniciar servicios: docker compose restart" -ForegroundColor White
Write-Host ""

if ($jwtToken) {
    Write-Host "Token JWT obtenido (valido por 1 hora):" -ForegroundColor Green
    Write-Host "  $jwtToken" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Puedes usar este token para probar los endpoints:" -ForegroundColor Yellow
    Write-Host "  curl -H 'Authorization: Bearer $jwtToken' http://localhost:8080/api/users" -ForegroundColor White
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Verificacion completada" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

