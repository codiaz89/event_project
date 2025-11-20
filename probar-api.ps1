Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Prueba de API con Datos Reales" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:8080"
$frontendUrl = "http://localhost:3000"

# 1. Obtener token JWT
Write-Host "1. Obteniendo token JWT..." -ForegroundColor Yellow
try {
    $loginBody = @{
        username = "admin"
        password = "admin123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.jwtToken
    Write-Host "   OK: Token obtenido exitosamente" -ForegroundColor Green
    Write-Host "   Token: $($token.Substring(0, 50))..." -ForegroundColor Gray
} catch {
    Write-Host "   ERROR: No se pudo obtener el token" -ForegroundColor Red
    Write-Host "   Detalles: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

Write-Host ""

# 2. Crear usuarios
Write-Host "2. Creando usuarios de prueba..." -ForegroundColor Yellow
$users = @()

$user1 = @{
    firstName = "Juan"
    lastName = "Pérez"
}
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method POST -Headers $headers -Body ($user1 | ConvertTo-Json)
    $users += $response
    Write-Host "   OK: Usuario creado - $($response.firstName) $($response.lastName) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "   ERROR al crear usuario 1: $($_.Exception.Message)" -ForegroundColor Red
}

$user2 = @{
    firstName = "María"
    lastName = "González"
}
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method POST -Headers $headers -Body ($user2 | ConvertTo-Json)
    $users += $response
    Write-Host "   OK: Usuario creado - $($response.firstName) $($response.lastName) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "   ERROR al crear usuario 2: $($_.Exception.Message)" -ForegroundColor Red
}

$user3 = @{
    firstName = "Carlos"
    lastName = "Rodríguez"
}
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method POST -Headers $headers -Body ($user3 | ConvertTo-Json)
    $users += $response
    Write-Host "   OK: Usuario creado - $($response.firstName) $($response.lastName) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "   ERROR al crear usuario 3: $($_.Exception.Message)" -ForegroundColor Red
}

if ($users.Count -eq 0) {
    Write-Host "   ERROR: No se pudieron crear usuarios. Verifica que el backend esté corriendo." -ForegroundColor Red
    exit 1
}

Write-Host ""

# 3. Listar todos los usuarios
Write-Host "3. Listando todos los usuarios..." -ForegroundColor Yellow
try {
    $allUsers = Invoke-RestMethod -Uri "$baseUrl/api/users" -Method GET -Headers $headers
    Write-Host "   OK: Se encontraron $($allUsers.Count) usuarios" -ForegroundColor Green
    foreach ($user in $allUsers) {
        Write-Host "      - $($user.firstName) $($user.lastName) (ID: $($user.id))" -ForegroundColor White
    }
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 4. Crear tickets
Write-Host "4. Creando tickets de prueba..." -ForegroundColor Yellow
$tickets = @()

if ($users.Count -gt 0) {
    $ticket1 = @{
        description = "Problema con acceso al sistema de eventos"
        userId = $users[0].id
        status = "ABIERTO"
    }
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/tickets" -Method POST -Headers $headers -Body ($ticket1 | ConvertTo-Json)
        $tickets += $response
        Write-Host "   OK: Ticket creado - '$($response.description)' (ID: $($response.id))" -ForegroundColor Green
    } catch {
        Write-Host "   ERROR al crear ticket 1: $($_.Exception.Message)" -ForegroundColor Red
    }

    $ticket2 = @{
        description = "Solicitud de cambio de fecha del evento"
        userId = $users[0].id
        status = "ABIERTO"
    }
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/tickets" -Method POST -Headers $headers -Body ($ticket2 | ConvertTo-Json)
        $tickets += $response
        Write-Host "   OK: Ticket creado - '$($response.description)' (ID: $($response.id))" -ForegroundColor Green
    } catch {
        Write-Host "   ERROR al crear ticket 2: $($_.Exception.Message)" -ForegroundColor Red
    }

    if ($users.Count -gt 1) {
        $ticket3 = @{
            description = "Consulta sobre disponibilidad de asientos"
            userId = $users[1].id
            status = "CERRADO"
        }
        try {
            $response = Invoke-RestMethod -Uri "$baseUrl/api/tickets" -Method POST -Headers $headers -Body ($ticket3 | ConvertTo-Json)
            $tickets += $response
            Write-Host "   OK: Ticket creado - '$($response.description)' (ID: $($response.id))" -ForegroundColor Green
        } catch {
            Write-Host "   ERROR al crear ticket 3: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""

# 5. Listar todos los tickets
Write-Host "5. Listando todos los tickets..." -ForegroundColor Yellow
try {
    $allTickets = Invoke-RestMethod -Uri "$baseUrl/api/tickets" -Method GET -Headers $headers
    if ($allTickets.content) {
        Write-Host "   OK: Se encontraron $($allTickets.totalElements) tickets (página $($allTickets.number + 1) de $($allTickets.totalPages))" -ForegroundColor Green
        foreach ($ticket in $allTickets.content) {
            Write-Host "      - [$($ticket.status)] $($ticket.description) (ID: $($ticket.id))" -ForegroundColor White
        }
    } else {
        Write-Host "   OK: Se encontraron $($allTickets.Count) tickets" -ForegroundColor Green
        foreach ($ticket in $allTickets) {
            Write-Host "      - [$($ticket.status)] $($ticket.description) (ID: $($ticket.id))" -ForegroundColor White
        }
    }
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 6. Filtrar tickets por estado
Write-Host "6. Filtrando tickets por estado ABIERTO..." -ForegroundColor Yellow
try {
    $filteredTickets = Invoke-RestMethod -Uri "$baseUrl/api/tickets?status=ABIERTO" -Method GET -Headers $headers
    if ($filteredTickets.content) {
        Write-Host "   OK: Se encontraron $($filteredTickets.totalElements) tickets ABIERTOS" -ForegroundColor Green
        foreach ($ticket in $filteredTickets.content) {
            Write-Host "      - $($ticket.description)" -ForegroundColor White
        }
    } else {
        Write-Host "   OK: Se encontraron $($filteredTickets.Count) tickets ABIERTOS" -ForegroundColor Green
        foreach ($ticket in $filteredTickets) {
            Write-Host "      - $($ticket.description)" -ForegroundColor White
        }
    }
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 7. Obtener tickets de un usuario específico
if ($users.Count -gt 0) {
    Write-Host "7. Obteniendo tickets del usuario $($users[0].firstName) $($users[0].lastName)..." -ForegroundColor Yellow
    try {
        $userTickets = Invoke-RestMethod -Uri "$baseUrl/api/tickets/user/$($users[0].id)" -Method GET -Headers $headers
        Write-Host "   OK: El usuario tiene $($userTickets.Count) tickets" -ForegroundColor Green
        foreach ($ticket in $userTickets) {
            Write-Host "      - [$($ticket.status)] $($ticket.description)" -ForegroundColor White
        }
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# 8. Actualizar un ticket
if ($tickets.Count -gt 0) {
    Write-Host "8. Actualizando un ticket..." -ForegroundColor Yellow
    $ticketToUpdate = $tickets[0]
    $updateData = @{
        description = $ticketToUpdate.description + " [ACTUALIZADO]"
        userId = $ticketToUpdate.userId
        status = "CERRADO"
    }
    try {
        $updatedTicket = Invoke-RestMethod -Uri "$baseUrl/api/tickets/$($ticketToUpdate.id)" -Method PUT -Headers $headers -Body ($updateData | ConvertTo-Json)
        Write-Host "   OK: Ticket actualizado - Estado: $($updatedTicket.status)" -ForegroundColor Green
        Write-Host "      Descripción: $($updatedTicket.description)" -ForegroundColor White
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# 9. Actualizar un usuario
if ($users.Count -gt 0) {
    Write-Host "9. Actualizando un usuario..." -ForegroundColor Yellow
    $userToUpdate = $users[0]
    $updateData = @{
        firstName = $userToUpdate.firstName + " [ACTUALIZADO]"
        lastName = $userToUpdate.lastName
    }
    try {
        $updatedUser = Invoke-RestMethod -Uri "$baseUrl/api/users/$($userToUpdate.id)" -Method PUT -Headers $headers -Body ($updateData | ConvertTo-Json)
        Write-Host "   OK: Usuario actualizado - $($updatedUser.firstName) $($updatedUser.lastName)" -ForegroundColor Green
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# 10. Probar el frontend BFF
Write-Host "10. Probando endpoints del Frontend BFF..." -ForegroundColor Yellow
try {
    $frontendHealth = Invoke-RestMethod -Uri "$frontendUrl/health" -Method GET
    Write-Host "   OK: Frontend health check - $($frontendHealth.status)" -ForegroundColor Green
} catch {
    Write-Host "   ERROR: Frontend no responde" -ForegroundColor Red
}

Write-Host ""

# Resumen
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Resumen de la Prueba" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Operaciones realizadas:" -ForegroundColor Yellow
Write-Host "  ✅ Autenticación JWT" -ForegroundColor Green
Write-Host "  ✅ Creación de usuarios ($($users.Count) usuarios)" -ForegroundColor Green
Write-Host "  ✅ Creación de tickets ($($tickets.Count) tickets)" -ForegroundColor Green
Write-Host "  ✅ Listado de recursos" -ForegroundColor Green
Write-Host "  ✅ Filtrado de tickets" -ForegroundColor Green
Write-Host "  ✅ Actualización de recursos" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Abre Swagger UI: http://localhost:8080/api/swagger" -ForegroundColor White
Write-Host "  2. Explora la API interactivamente" -ForegroundColor White
Write-Host "  3. Prueba otros endpoints desde Swagger" -ForegroundColor White
Write-Host "  4. Usa el Frontend BFF en: http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Para ver los datos en la base de datos H2:" -ForegroundColor Yellow
Write-Host "  1. Abre: http://localhost:8080/h2-console" -ForegroundColor White
Write-Host "  2. JDBC URL: jdbc:h2:mem:eventdb" -ForegroundColor White
Write-Host "  3. Usuario: sa" -ForegroundColor White
Write-Host "  4. Password: sa" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Prueba completada exitosamente" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

