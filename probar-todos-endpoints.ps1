Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Prueba Completa de Todos los Endpoints" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:8080"
$frontendUrl = "http://localhost:3000"

$testResults = @{
    Total = 0
    Exitosos = 0
    Fallidos = 0
    Detalles = @()
}

function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Url,
        [hashtable]$Headers = $null,
        [object]$Body = $null,
        [int]$ExpectedStatus = 200
    )
    
    $testResults.Total++
    Write-Host "  [$($testResults.Total)] $Name..." -ForegroundColor Yellow -NoNewline
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ErrorAction = "Stop"
        }
        
        if ($Headers) {
            $params.Headers = $Headers
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        $statusCode = 200
        
        Write-Host " OK" -ForegroundColor Green
        $testResults.Exitosos++
        $testResults.Detalles += @{
            Endpoint = $Name
            Status = "OK"
            Method = $Method
            Url = $Url
        }
        return $response
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host " ERROR ($statusCode)" -ForegroundColor Red
        Write-Host "      $($_.Exception.Message)" -ForegroundColor Red
        $testResults.Fallidos++
        $testResults.Detalles += @{
            Endpoint = $Name
            Status = "ERROR"
            Method = $Method
            Url = $Url
            Error = $_.Exception.Message
        }
        return $null
    }
}

# ============================================
# 1. AUTENTICACIÓN
# ============================================
Write-Host "1. AUTENTICACIÓN" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

$loginResponse = Test-Endpoint -Name "POST /api/auth/login" `
    -Method "POST" `
    -Url "$baseUrl/api/auth/login" `
    -Body (@{ username = "admin"; password = "admin123" } | ConvertTo-Json)

if (-not $loginResponse) {
    Write-Host ""
    Write-Host "ERROR: No se pudo autenticar. Abortando pruebas." -ForegroundColor Red
    exit 1
}

$token = $loginResponse.token
if (-not $token) {
    $token = $loginResponse.jwtToken
}

if (-not $token) {
    Write-Host ""
    Write-Host "ERROR: No se encontró token en la respuesta." -ForegroundColor Red
    exit 1
}

$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

Write-Host "   Token obtenido: $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Gray
Write-Host ""

# ============================================
# 2. USUARIOS - CREAR
# ============================================
Write-Host "2. USUARIOS - CREAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

$user1 = Test-Endpoint -Name "POST /api/users (Usuario 1)" `
    -Method "POST" `
    -Url "$baseUrl/api/users" `
    -Headers $headers `
    -Body (@{ firstName = "Juan"; lastName = "Pérez" } | ConvertTo-Json)

$user2 = Test-Endpoint -Name "POST /api/users (Usuario 2)" `
    -Method "POST" `
    -Url "$baseUrl/api/users" `
    -Headers $headers `
    -Body (@{ firstName = "María"; lastName = "González" } | ConvertTo-Json)

$user3 = Test-Endpoint -Name "POST /api/users (Usuario 3)" `
    -Method "POST" `
    -Url "$baseUrl/api/users" `
    -Headers $headers `
    -Body (@{ firstName = "Carlos"; lastName = "Rodríguez" } | ConvertTo-Json)

Write-Host ""

# ============================================
# 3. USUARIOS - LISTAR Y OBTENER
# ============================================
Write-Host "3. USUARIOS - LISTAR Y OBTENER" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

$allUsers = Test-Endpoint -Name "GET /api/users (Listar todos)" `
    -Method "GET" `
    -Url "$baseUrl/api/users" `
    -Headers $headers

if ($user1 -and $user1.id) {
    Test-Endpoint -Name "GET /api/users/{id} (Obtener por ID)" `
        -Method "GET" `
        -Url "$baseUrl/api/users/$($user1.id)" `
        -Headers $headers | Out-Null
}

Write-Host ""

# ============================================
# 4. USUARIOS - ACTUALIZAR
# ============================================
Write-Host "4. USUARIOS - ACTUALIZAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

if ($user1 -and $user1.id) {
    Test-Endpoint -Name "PUT /api/users/{id} (Actualizar usuario)" `
        -Method "PUT" `
        -Url "$baseUrl/api/users/$($user1.id)" `
        -Headers $headers `
        -Body (@{ firstName = "Juan Carlos"; lastName = "Pérez" } | ConvertTo-Json) | Out-Null
}

Write-Host ""

# ============================================
# 5. TICKETS - CREAR
# ============================================
Write-Host "5. TICKETS - CREAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

$ticket1 = $null
$ticket2 = $null
$ticket3 = $null

if ($user1 -and $user1.id) {
    $ticket1 = Test-Endpoint -Name "POST /api/tickets (Ticket 1 - ABIERTO)" `
        -Method "POST" `
        -Url "$baseUrl/api/tickets" `
        -Headers $headers `
        -Body (@{ 
            description = "Problema con acceso al sistema de eventos"
            userId = $user1.id
            status = "ABIERTO"
        } | ConvertTo-Json)
    
    $ticket2 = Test-Endpoint -Name "POST /api/tickets (Ticket 2 - ABIERTO)" `
        -Method "POST" `
        -Url "$baseUrl/api/tickets" `
        -Headers $headers `
        -Body (@{ 
            description = "Solicitud de cambio de fecha del evento"
            userId = $user1.id
            status = "ABIERTO"
        } | ConvertTo-Json)
}

if ($user2 -and $user2.id) {
    $ticket3 = Test-Endpoint -Name "POST /api/tickets (Ticket 3 - CERRADO)" `
        -Method "POST" `
        -Url "$baseUrl/api/tickets" `
        -Headers $headers `
        -Body (@{ 
            description = "Consulta sobre disponibilidad de asientos"
            userId = $user2.id
            status = "CERRADO"
        } | ConvertTo-Json)
}

Write-Host ""

# ============================================
# 6. TICKETS - LISTAR Y FILTRAR
# ============================================
Write-Host "6. TICKETS - LISTAR Y FILTRAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

Test-Endpoint -Name "GET /api/tickets (Listar todos)" `
    -Method "GET" `
    -Url "$baseUrl/api/tickets" `
    -Headers $headers | Out-Null

Test-Endpoint -Name "GET /api/tickets?status=ABIERTO (Filtrar por estado)" `
    -Method "GET" `
    -Url "$baseUrl/api/tickets?status=ABIERTO" `
    -Headers $headers | Out-Null

Test-Endpoint -Name "GET /api/tickets?status=CERRADO (Filtrar por estado)" `
    -Method "GET" `
    -Url "$baseUrl/api/tickets?status=CERRADO" `
    -Headers $headers | Out-Null

if ($user1 -and $user1.id) {
    Test-Endpoint -Name "GET /api/tickets?userId={id} (Filtrar por usuario)" `
        -Method "GET" `
        -Url "$baseUrl/api/tickets?userId=$($user1.id)" `
        -Headers $headers | Out-Null
    
    $urlCombinado = "$baseUrl/api/tickets?status=ABIERTO&userId=$($user1.id)"
    Test-Endpoint -Name "GET /api/tickets?status=ABIERTO&userId={id} (Filtrar por estado y usuario)" `
        -Method "GET" `
        -Url $urlCombinado `
        -Headers $headers | Out-Null
}

$urlPaginacion = "$baseUrl/api/tickets?page=0&size=5"
Test-Endpoint -Name "GET /api/tickets?page=0&size=5 (Paginación)" `
    -Method "GET" `
    -Url $urlPaginacion `
    -Headers $headers | Out-Null

Write-Host ""

# ============================================
# 7. TICKETS - OBTENER POR ID Y POR USUARIO
# ============================================
Write-Host "7. TICKETS - OBTENER POR ID Y POR USUARIO" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

if ($ticket1 -and $ticket1.id) {
    Test-Endpoint -Name "GET /api/tickets/{id} (Obtener por ID)" `
        -Method "GET" `
        -Url "$baseUrl/api/tickets/$($ticket1.id)" `
        -Headers $headers | Out-Null
}

if ($user1 -and $user1.id) {
    Test-Endpoint -Name "GET /api/tickets/user/{userId} (Tickets por usuario)" `
        -Method "GET" `
        -Url "$baseUrl/api/tickets/user/$($user1.id)" `
        -Headers $headers | Out-Null
}

Write-Host ""

# ============================================
# 8. TICKETS - ACTUALIZAR
# ============================================
Write-Host "8. TICKETS - ACTUALIZAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

if ($ticket1 -and $ticket1.id -and $user1 -and $user1.id) {
    Test-Endpoint -Name "PUT /api/tickets/{id} (Actualizar ticket)" `
        -Method "PUT" `
        -Url "$baseUrl/api/tickets/$($ticket1.id)" `
        -Headers $headers `
        -Body (@{ 
            description = "Problema con acceso al sistema [RESUELTO]"
            userId = $user1.id
            status = "CERRADO"
        } | ConvertTo-Json) | Out-Null
}

Write-Host ""

# ============================================
# 9. TICKETS - ELIMINAR
# ============================================
Write-Host "9. TICKETS - ELIMINAR" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

if ($ticket2 -and $ticket2.id) {
    Test-Endpoint -Name "DELETE /api/tickets/{id} (Eliminar ticket)" `
        -Method "DELETE" `
        -Url "$baseUrl/api/tickets/$($ticket2.id)" `
        -Headers $headers `
        -ExpectedStatus 204 | Out-Null
}

Write-Host ""

# ============================================
# 10. FRONTEND BFF
# ============================================
Write-Host "10. FRONTEND BFF" -ForegroundColor Magenta
Write-Host "----------------------------------------" -ForegroundColor Magenta

Test-Endpoint -Name "GET /health (Health check)" `
    -Method "GET" `
    -Url "$frontendUrl/health" | Out-Null

Test-Endpoint -Name "GET /users (BFF - Listar usuarios)" `
    -Method "GET" `
    -Url "$frontendUrl/users" `
    -Headers $headers | Out-Null

Test-Endpoint -Name "GET /tickets (BFF - Listar tickets)" `
    -Method "GET" `
    -Url "$frontendUrl/tickets" `
    -Headers $headers | Out-Null

Write-Host ""

# ============================================
# RESUMEN FINAL
# ============================================
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE PRUEBAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total de pruebas: $($testResults.Total)" -ForegroundColor White
Write-Host "  Exitosas: " -NoNewline -ForegroundColor White
Write-Host "$($testResults.Exitosos)" -ForegroundColor Green
Write-Host "  Fallidas: " -NoNewline -ForegroundColor White
Write-Host "$($testResults.Fallidos)" -ForegroundColor Red
Write-Host ""

$porcentaje = if ($testResults.Total -gt 0) { 
    [math]::Round(($testResults.Exitosos / $testResults.Total) * 100, 2) 
} else { 
    0 
}

Write-Host "Tasa de éxito: $porcentaje%" -ForegroundColor $(if ($porcentaje -eq 100) { "Green" } elseif ($porcentaje -ge 80) { "Yellow" } else { "Red" })
Write-Host ""

if ($testResults.Fallidos -gt 0) {
    Write-Host "Endpoints con errores:" -ForegroundColor Red
    foreach ($detalle in $testResults.Detalles) {
        if ($detalle.Status -eq "ERROR") {
            Write-Host "  - $($detalle.Method) $($detalle.Url)" -ForegroundColor Red
            Write-Host "    Error: $($detalle.Error)" -ForegroundColor Gray
        }
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
if ($testResults.Fallidos -eq 0) {
    Write-Host "  TODAS LAS PRUEBAS PASARON EXITOSAMENTE" -ForegroundColor Green
} else {
    Write-Host "  PRUEBAS COMPLETADAS CON ERRORES" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

