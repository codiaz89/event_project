# Event Platform Workspace

Este repositorio contiene el esqueleto inicial para la prueba tÃ©cnica solicitada por Double V Partners / NYX. Separamos el backend en Spring Boot y el frontend en NestJS, ambos listos para ejecutarse de forma independiente o mediante Docker Compose.

## Estructura
- `backend/`: API REST con Spring Boot 3.3.x, H2 en memoria, validaciones y soporte para OpenAPI.
- `frontend/`: API Gateway / BFF con NestJS 11 listo para conectarse al backend.
- `docker-compose.yml`: OrquestaciÃ³n local de ambos servicios.

## Requisitos previos
- Java 17+
- Maven Wrapper incluido (`./mvnw`)
- Node.js 20+
- Docker y Docker Compose (opcional para la corrida integrada)

## Cómo levantar el proyecto

### Opción 1: Levantar con Docker Compose (Recomendado) 🐳

> 📖 **¿Primera vez usando Docker?** Consulta la [Guía Completa de Docker](GUIA-DOCKER.md) que incluye instrucciones paso a paso desde la instalación.

#### Pasos rápidos:

1. **Asegúrate de tener Docker Desktop instalado y corriendo**
   - Descarga desde: https://www.docker.com/products/docker-desktop/
   - Inicia Docker Desktop y espera a que esté listo (verás el ícono de Docker en la bandeja del sistema)

2. **Verifica la instalación:**
```bash
docker --version
docker compose version
```

3. **Desde la raíz del proyecto, ejecuta:**
```bash
# Opción A: Usar el script automatizado (Windows - Recomendado)
.\levantar-proyecto-docker.ps1

# Opción B: Comando manual
docker compose up --build
```

4. **Espera a que los servicios inicien** (5-10 minutos la primera vez mientras descarga dependencias y construye las imágenes)

5. **Verifica que todo funciona:**
   - **Backend API**: http://localhost:8080
   - **Swagger UI**: http://localhost:8080/swagger-ui.html
   - **API Docs (JSON)**: http://localhost:8080/api/docs
   - **H2 Console**: http://localhost:8080/h2-console
   - **Frontend BFF**: http://localhost:3000

6. **Para detener los servicios:**
```bash
# Presiona Ctrl+C en la terminal donde corre Docker
# O ejecuta en otra terminal:
docker compose down
```

> 💡 **Tip:** Usa el script `.\verificar-proyecto.ps1` para verificar automáticamente que todo esté funcionando correctamente.

### Opción 2: Levantar manualmente (paso a paso)

#### Paso 1: Levantar el Backend (Spring Boot)

1. Abre una terminal y navega al directorio del backend:
```bash
cd backend
```

2. Ejecuta el backend usando Maven Wrapper:
```bash
# En Windows (PowerShell)
.\mvnw.cmd spring-boot:run

# En Linux/Mac
./mvnw spring-boot:run
```

3. Espera a que el backend inicie. Verás un mensaje similar a:
```
Started EventBackendApplication in X.XXX seconds
```

4. El backend estará disponible en:
   - **API**: `http://localhost:8080`
   - **Swagger UI**: `http://localhost:8080/swagger-ui.html`
   - **API Docs**: `http://localhost:8080/api/docs`
   - **H2 Console**: `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:eventdb`)

#### Paso 2: Obtener token JWT

Antes de usar la API, necesitas autenticarte:

1. Abre otra terminal o usa Postman/Thunder Client
2. Realiza una petición POST a `http://localhost:8080/api/auth/login`:
```json
{
  "username": "admin",
  "password": "admin123"
}
```

3. Copia el token que recibes en la respuesta:
```json
{
  "token": "eyJhbGciOiJIUzM4NCJ9...",
  "type": "Bearer"
}
```

4. Usa este token en todas las peticiones posteriores agregando el header:
```
Authorization: Bearer <tu-token-aqui>
```

> 💡 **Tip:** También puedes usar Swagger UI para obtener el token. Ve a http://localhost:8080/swagger-ui.html, prueba el endpoint `/api/auth/login`, copia el token y luego haz clic en "Authorize" (arriba a la derecha) para configurarlo.

#### Paso 3: Levantar el Frontend (NestJS)

1. Abre una **nueva terminal** (deja el backend corriendo) y navega al directorio del frontend:
```bash
cd frontend
```

2. Instala las dependencias (solo la primera vez):
```bash
npm install
```

3. Configura las variables de entorno (opcional, tiene valores por defecto):
```bash
# En Windows (PowerShell)
$env:API_BASE_URL="http://localhost:8080"
$env:API_USERNAME="admin"
$env:API_PASSWORD="admin123"

# En Linux/Mac
export API_BASE_URL=http://localhost:8080
export API_USERNAME=admin
export API_PASSWORD=admin123
```

4. Inicia el frontend en modo desarrollo:
```bash
npm run start:dev
```

5. El frontend estará disponible en:
   - **BFF API**: `http://localhost:3000`
   - **Health Check**: `http://localhost:3000/health`

## ¿Cómo verificar que se levantó correctamente?

### Método 1: Script automatizado (Recomendado)

Ejecuta el script de verificación que comprueba automáticamente todos los servicios:

```powershell
.\verificar-proyecto.ps1
```

Este script verifica:
- ✅ Que los contenedores Docker estén corriendo
- ✅ Que los logs muestren inicio exitoso
- ✅ Que los endpoints estén accesibles
- ✅ Que el login funcione correctamente
- ✅ Que Swagger UI esté disponible

### Método 2: Verificación manual

#### 1. Verificar contenedores
```bash
docker ps
```

Deberías ver dos contenedores corriendo:
- `event-platform-backend-1` en puerto `8080`
- `event-platform-frontend-1` en puerto `3000`

#### 2. Verificar logs
```bash
# Logs del backend
docker logs event-platform-backend-1 --tail 20

# Logs del frontend
docker logs event-platform-frontend-1 --tail 20
```

Busca estos mensajes:
- **Backend**: `Started EventBackendApplication` o `Tomcat started`
- **Frontend**: `Nest application successfully started` o `listening`

#### 3. Verificar endpoints en el navegador

Abre tu navegador y visita:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
  - Deberías ver la documentación interactiva de la API
  
- **API Docs (JSON)**: http://localhost:8080/api/docs
  - Deberías ver el JSON de la especificación OpenAPI

- **Frontend**: http://localhost:3000
  - Deberías ver una respuesta (puede ser un error 404 si no hay ruta raíz, pero el servidor debe responder)

#### 4. Probar el login

Usa PowerShell, Postman, o curl:

```powershell
# PowerShell
$body = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $body -ContentType "application/json"
```

O con curl:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

**Respuesta esperada:**
```json
{
  "jwtToken": "eyJhbGciOiJIUzM4NCJ9..."
}
```

#### 5. Probar un endpoint protegido

Usa el token obtenido en el paso anterior:

```powershell
# PowerShell
$token = "tu-token-aqui"
$headers = @{
    Authorization = "Bearer $token"
}

Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method GET -Headers $headers
```

O con curl:
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer tu-token-aqui"
```

**Respuesta esperada:** Una lista de usuarios (puede estar vacía inicialmente)

### Indicadores de éxito ✅

- ✅ Los contenedores aparecen en `docker ps` con estado "Up"
- ✅ Los logs muestran mensajes de inicio exitoso
- ✅ Swagger UI se carga en el navegador
- ✅ El login devuelve un token JWT
- ✅ Los endpoints protegidos responden con el token

### Indicadores de problemas ❌

- ❌ Los contenedores no aparecen o están en estado "Exited"
- ❌ Los logs muestran errores de conexión o compilación
- ❌ No puedes acceder a las URLs en el navegador
- ❌ El login devuelve error 401 o 500
- ❌ Los endpoints protegidos devuelven 401/403 incluso con token

**Solución:** Revisa la sección [Solución de problemas comunes](#solución-de-problemas-comunes) más abajo.

### Endpoints BFF disponibles
- `GET /health` - Health check del servicio
- `GET /users` - Listar todos los usuarios
- `GET /users/:id` - Obtener usuario por ID
- `POST /users` - Crear nuevo usuario
- `PUT /users/:id` - Actualizar usuario
- `GET /tickets` - Listar tickets (con filtros opcionales: `?status=ABIERTO&userId=<uuid>`)
- `GET /tickets/:id` - Obtener ticket por ID
- `POST /tickets` - Crear nuevo ticket
- `PUT /tickets/:id` - Actualizar ticket
- `GET /tickets/user/:userId` - Obtener tickets de un usuario específico

## Cómo usar el proyecto con datos reales

### Opción 1: Script automatizado de pruebas (Recomendado)

Ejecuta el script que crea usuarios y tickets de ejemplo, y prueba todas las funcionalidades:

```powershell
.\probar-api.ps1
```

Este script realiza automáticamente:
- ✅ Autenticación y obtención de token JWT
- ✅ Creación de 3 usuarios de ejemplo
- ✅ Creación de tickets de prueba
- ✅ Listado de todos los recursos
- ✅ Filtrado de tickets por estado
- ✅ Búsqueda de tickets por usuario
- ✅ Actualización de usuarios y tickets
- ✅ Prueba del frontend BFF

### Opción 2: Prueba manual paso a paso

#### Paso 1: Obtener token JWT

```powershell
# PowerShell
$body = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $body -ContentType "application/json"
$token = $response.jwtToken
Write-Host "Token: $token"
```

O con curl:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

**Respuesta:**
```json
{
  "jwtToken": "eyJhbGciOiJIUzM4NCJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9BRE1JTiJ9XSwic3ViIjoiYWRtaW4iLCJpYXQiOjE3NjM2NjM1NjAsImV4cCI6MTc2Mzc0OTk2MH0..."
}
```

#### Paso 2: Crear usuarios

```powershell
# PowerShell
$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

$user1 = @{
    firstName = "Juan"
    lastName = "Pérez"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method POST -Headers $headers -Body $user1
$userId1 = $response.id
Write-Host "Usuario creado: $($response.firstName) $($response.lastName) - ID: $userId1"
```

O con curl:
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Juan","lastName":"Pérez"}'
```

**Respuesta:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "firstName": "Juan",
  "lastName": "Pérez",
  "createdAt": "2025-11-20T18:30:00.000Z",
  "updatedAt": "2025-11-20T18:30:00.000Z"
}
```

#### Paso 3: Crear tickets

```powershell
# PowerShell
$ticket = @{
    description = "Problema con acceso al sistema de eventos"
    userId = $userId1
    status = "ABIERTO"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets" -Method POST -Headers $headers -Body $ticket
$ticketId = $response.id
Write-Host "Ticket creado: $($response.description) - ID: $ticketId"
```

O con curl:
```bash
curl -X POST http://localhost:8080/api/tickets \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Problema con acceso al sistema de eventos",
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "status": "ABIERTO"
  }'
```

**Respuesta:**
```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "description": "Problema con acceso al sistema de eventos",
  "status": "ABIERTO",
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "createdAt": "2025-11-20T18:30:00.000Z",
  "updatedAt": "2025-11-20T18:30:00.000Z"
}
```

#### Paso 4: Listar usuarios

```powershell
# PowerShell
$users = Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method GET -Headers $headers
$users | ForEach-Object { Write-Host "$($_.firstName) $($_.lastName) - $($_.id)" }
```

O con curl:
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer $token"
```

#### Paso 5: Listar tickets con filtros

```powershell
# PowerShell - Filtrar por estado
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?status=ABIERTO" -Method GET -Headers $headers
Write-Host "Tickets abiertos: $($tickets.totalElements)"

# Filtrar por usuario y estado
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?status=ABIERTO&userId=$userId1" -Method GET -Headers $headers
Write-Host "Tickets del usuario: $($tickets.totalElements)"

# Con paginación
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?page=0&size=10" -Method GET -Headers $headers
Write-Host "Página 1: $($tickets.content.Count) tickets de $($tickets.totalElements) totales"
```

O con curl:
```bash
# Filtrar por estado
curl -X GET "http://localhost:8080/api/tickets?status=ABIERTO" \
  -H "Authorization: Bearer $token"

# Filtrar por usuario y estado
curl -X GET "http://localhost:8080/api/tickets?status=ABIERTO&userId=550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer $token"

# Con paginación
curl -X GET "http://localhost:8080/api/tickets?page=0&size=10" \
  -H "Authorization: Bearer $token"
```

#### Paso 6: Obtener tickets de un usuario específico

```powershell
# PowerShell
$userTickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets/user/$userId1" -Method GET -Headers $headers
Write-Host "El usuario tiene $($userTickets.Count) tickets"
$userTickets | ForEach-Object { Write-Host "  - [$($_.status)] $($_.description)" }
```

O con curl:
```bash
curl -X GET "http://localhost:8080/api/tickets/user/550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer $token"
```

#### Paso 7: Actualizar un ticket

```powershell
# PowerShell
$updateData = @{
    description = "Problema con acceso al sistema [RESUELTO]"
    userId = $userId1
    status = "CERRADO"
} | ConvertTo-Json

$updatedTicket = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets/$ticketId" -Method PUT -Headers $headers -Body $updateData
Write-Host "Ticket actualizado: Estado = $($updatedTicket.status)"
```

O con curl:
```bash
curl -X PUT "http://localhost:8080/api/tickets/660e8400-e29b-41d4-a716-446655440001" \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Problema con acceso al sistema [RESUELTO]",
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "status": "CERRADO"
  }'
```

#### Paso 8: Actualizar un usuario

```powershell
# PowerShell
$updateData = @{
    firstName = "Juan Carlos"
    lastName = "Pérez"
} | ConvertTo-Json

$updatedUser = Invoke-RestMethod -Uri "http://localhost:8080/api/users/$userId1" -Method PUT -Headers $headers -Body $updateData
Write-Host "Usuario actualizado: $($updatedUser.firstName) $($updatedUser.lastName)"
```

O con curl:
```bash
curl -X PUT "http://localhost:8080/api/users/550e8400-e29b-41d4-a716-446655440000" \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Juan Carlos","lastName":"Pérez"}'
```

#### Paso 9: Eliminar un ticket

```powershell
# PowerShell
Invoke-RestMethod -Uri "http://localhost:8080/api/tickets/$ticketId" -Method DELETE -Headers $headers
Write-Host "Ticket eliminado"
```

O con curl:
```bash
curl -X DELETE "http://localhost:8080/api/tickets/660e8400-e29b-41d4-a716-446655440001" \
  -H "Authorization: Bearer $token"
```

### Opción 3: Usar Swagger UI (Interfaz gráfica)

1. Abre tu navegador en: http://localhost:8080/swagger-ui.html
2. Haz clic en el endpoint `/api/auth/login` y luego en "Try it out"
3. Ingresa las credenciales:
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
4. Haz clic en "Execute" y copia el token JWT de la respuesta
5. Haz clic en el botón "Authorize" (arriba a la derecha)
6. Ingresa: `Bearer <tu-token-aqui>` y haz clic en "Authorize"
7. Ahora puedes probar todos los endpoints directamente desde Swagger

### Opción 4: Usar el Frontend BFF

El frontend actúa como un BFF (Backend for Frontend) y expone los mismos endpoints:

```powershell
# Health check
Invoke-RestMethod -Uri "http://localhost:3000/health"

# Listar usuarios (requiere autenticación en el backend)
Invoke-RestMethod -Uri "http://localhost:3000/users" -Headers $headers

# Listar tickets
Invoke-RestMethod -Uri "http://localhost:3000/tickets" -Headers $headers
```

### Ver los datos en la base de datos H2

1. Abre tu navegador en: http://localhost:8080/h2-console
2. Ingresa los siguientes datos:
   - **JDBC URL**: `jdbc:h2:mem:eventdb`
   - **Usuario**: `sa`
   - **Password**: `sa`
3. Haz clic en "Connect"
4. Ejecuta consultas SQL:
   ```sql
   -- Ver todos los usuarios
   SELECT * FROM users;
   
   -- Ver todos los tickets
   SELECT * FROM tickets;
   
   -- Ver tickets con información del usuario
   SELECT t.*, u.first_name, u.last_name 
   FROM tickets t 
   JOIN users u ON t.user_id = u.id;
   ```

## Ejemplos de uso (Referencia rápida)

### Crear un usuario
```bash
POST http://localhost:8080/api/users
Authorization: Bearer <tu-token>
Content-Type: application/json

{
  "firstName": "Juan",
  "lastName": "Pérez"
}
```

### Crear un ticket
```bash
POST http://localhost:8080/api/tickets
Authorization: Bearer <tu-token>
Content-Type: application/json

{
  "description": "Problema con acceso al sistema",
  "userId": "<uuid-del-usuario>",
  "status": "ABIERTO"
}
```

### Filtrar tickets por estatus
```bash
GET http://localhost:8080/api/tickets?status=ABIERTO&page=0&size=10
Authorization: Bearer <tu-token>
```

### Obtener tickets de un usuario
```bash
GET http://localhost:8080/api/tickets/user/<uuid-del-usuario>
Authorization: Bearer <tu-token>
```

## Ejecutar con Docker Compose
```
docker compose up --build
```
Esto levanta ambos servicios y abre los mismos puertos (`8080` backend, `3000` frontend) dentro de la misma red para facilitar las llamadas internas.

## Solución de problemas comunes

### El backend no inicia
- Verifica que tengas Java 17+ instalado: `java -version`
- Asegúrate de estar en el directorio `backend/`
- Si hay errores de puerto, verifica que el puerto 8080 no esté en uso

### El frontend no se conecta al backend
- Verifica que el backend esté corriendo en `http://localhost:8080`
- Revisa las variables de entorno `API_BASE_URL`, `API_USERNAME`, `API_PASSWORD`
- Asegúrate de que ambos servicios estén en la misma red (si usas Docker)

### Error 401/403 en las peticiones
- Asegúrate de haber obtenido un token JWT válido desde `/api/auth/login`
- Verifica que el header `Authorization: Bearer <token>` esté presente
- El token expira después de 24 horas, obtén uno nuevo si es necesario

### Error al ejecutar Maven Wrapper
- En Windows, usa `.\mvnw.cmd` en lugar de `./mvnw`
- Asegúrate de tener permisos de ejecución en el archivo `mvnw` (Linux/Mac): `chmod +x mvnw`

## Seguridad
El backend utiliza autenticaciÃ³n JWT (JSON Web Tokens) con usuarios en memoria:

| Usuario | Rol  | ContraseÃ±a |
|---------|------|-------------|
| admin   | ADMIN| `admin123`  |
| analyst | USER | `analyst123`|

### AutenticaciÃ³n
1. Obtener token JWT: `POST /api/auth/login` con `{"username": "admin", "password": "admin123"}`
2. Usar el token: Incluir en el header `Authorization: Bearer <token>`

`USER` puede consumir endpoints GET, mientras que `ADMIN` puede crear, actualizar o eliminar recursos. Los recursos de Swagger y H2 permanecen pÃºblicos para facilitar las pruebas locales.