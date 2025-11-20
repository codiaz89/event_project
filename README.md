# Event Platform Workspace

Este repositorio contiene el esqueleto inicial para la prueba técnica solicitada por Double V Partners / NYX. Separamos el backend en Spring Boot y el frontend en NestJS, ambos listos para ejecutarse de forma independiente o mediante Docker Compose.

## Estructura
- `backend/`: API REST con Spring Boot 3.3.x, H2 en memoria, validaciones y soporte para OpenAPI.
- `frontend/`: API Gateway / BFF con NestJS 11 listo para conectarse al backend.
- `docker-compose.yml`: Orquestación local de ambos servicios.

## Requisitos previos
- Java 17+
- Maven Wrapper incluido (`./mvnw`)
- Node.js 20+
- Docker y Docker Compose (opcional para la corrida integrada)

---

## Cómo levantar el proyecto

### Opción 1: Levantar con Docker Compose
Esta es la forma más sencilla de levantar todo el proyecto. Docker Compose se encarga de construir las imágenes, levantar los contenedores y configurar la red entre servicios.

#### Requisitos previos

1. **Docker Desktop instalado y corriendo**
   - Se descarga desde: https://www.docker.com/products/docker-desktop/
   - Se instala Docker Desktop siguiendo las instrucciones del instalador
   - Se inicia Docker Desktop y se espera a que esté completamente listo (el ícono de Docker en la bandeja del sistema debe estar estable)

2. **Verificar la instalación:**
```bash
docker --version
docker compose version
```

Se debería ver algo como:
```
Docker version 24.0.x, build xxxxx
Docker Compose version v2.x.x
```

#### Pasos para levantar el proyecto

1. **Navegar a la raíz del proyecto:**
```bash
cd "E:\Pruebas Tecnicas\Double V\event_project"
```

2. **Levantar los servicios:**
```bash
# Opción A: Usar el script automatizado (Windows - Recomendado)
.\levantar-proyecto-docker.ps1

# Opción B: Comando manual
docker compose up --build
```

> **Nota:** La primera vez puede tomar 5-10 minutos mientras:
> - Se descargan las imágenes base (Java, Node.js)
> - Se compila el backend (Maven)
> - Se instalan las dependencias del frontend (npm)
> - Se construyen las imágenes finales

3. **Verificar que los servicios están corriendo:**

Se abren dos terminales y se ejecuta:
```bash
# Ver contenedores activos
docker ps
```

Se deberían ver dos contenedores:
- `event-platform-backend-1` en puerto `8080`
- `event-platform-frontend-1` en puerto `3000`

4. **Verificar que los servicios responden:**

Se abren en el navegador:
- **Backend API**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **API Docs (JSON)**: http://localhost:8080/api/docs
- **H2 Console**: http://localhost:8080/h2-console
- **Frontend BFF**: http://localhost:3000/health

5. **Ver logs de los servicios (opcional):**
```bash
# Ver logs de todos los servicios
docker compose logs -f

# Ver logs solo del backend
docker compose logs -f backend

# Ver logs solo del frontend
docker compose logs -f frontend
```

#### Comandos útiles de Docker

```bash
# Detener los servicios (mantiene los contenedores)
docker compose stop

# Iniciar los servicios (sin reconstruir)
docker compose start

# Detener y eliminar contenedores
docker compose down

# Detener, eliminar contenedores y volúmenes
docker compose down -v

# Reconstruir solo un servicio específico
docker compose up --build backend

# Ver estado de los servicios
docker compose ps

# Ver uso de recursos
docker stats
```

#### Solución de problemas comunes con Docker

**Error: "Docker daemon is not running"**
- Se verifica que Docker Desktop esté corriendo
- Se espera 1-2 minutos después de iniciar Docker Desktop
- Se reinicia Docker Desktop si es necesario

**Error: "Port already in use"**
- Se verifica que los puertos 8080 y 3000 no estén en uso:
  ```bash
  # Windows
  netstat -ano | findstr :8080
  netstat -ano | findstr :3000
  
  # Linux/Mac
  lsof -i :8080
  lsof -i :3000
  ```
- Se detienen los servicios que usan esos puertos o se cambian los puertos en `docker-compose.yml`

**Los servicios no inician correctamente**
- Se revisan los logs: `docker compose logs`
- Se reconstruye sin caché: `docker compose build --no-cache`
- Se limpia todo y se vuelve a levantar:
  ```bash
  docker compose down -v
  docker compose up --build
  ```

**Los contenedores se detienen inmediatamente**
- Se revisan los logs: `docker compose logs backend` y `docker compose logs frontend`
- Se verifica que no haya errores de compilación o configuración

> 📖 **¿Primera vez usando Docker?** Consulta la [Guía Completa de Docker](GUIA-DOCKER.md) que incluye instrucciones paso a paso desde la instalación.

### Opción 2: Levantar manualmente (paso a paso)

#### Paso 1: Levantar el Backend (Spring Boot)

1. Se abre una terminal y se navega al directorio del backend:
```bash
cd backend
```

2. Se ejecuta el backend usando Maven Wrapper:
```bash
# En Windows (PowerShell)
.\mvnw.cmd spring-boot:run

# En Linux/Mac
./mvnw spring-boot:run
```

3. Se espera a que el backend inicie. Se verá un mensaje similar a:
```
Started EventBackendApplication in X.XXX seconds
```

4. El backend estará disponible en:
   - **API**: `http://localhost:8080`
   - **Swagger UI**: `http://localhost:8080/swagger-ui.html`
   - **API Docs**: `http://localhost:8080/api/docs`
   - **H2 Console**: `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:eventdb`)

#### Paso 2: Levantar el Frontend (NestJS)

1. Se abre una **nueva terminal** (se deja el backend corriendo) y se navega al directorio del frontend:
```bash
cd frontend
```

2. Se instalan las dependencias (solo la primera vez):
```bash
npm install
```

3. Se configuran las variables de entorno (opcional, tiene valores por defecto):
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

4. Se inicia el frontend en modo desarrollo:
```bash
npm run start:dev
```

5. El frontend estará disponible en:
   - **BFF API**: `http://localhost:3000`
   - **Health Check**: `http://localhost:3000/health`

---

## Autenticación y uso de la API

### Credenciales disponibles

| Usuario | Password | Rol | Permisos |
|---------|----------|-----|----------|
| `admin` | `admin123` | ADMIN | Se puede hacer todo (crear, leer, actualizar, eliminar) |
| `analyst` | `analyst123` | USER | Solo se puede leer (GET) |

### Cómo obtener el token JWT

El token JWT es necesario para acceder a los endpoints protegidos. Se puede obtener de tres formas:

#### Opción 1: Usar Swagger UI 

1. Se abre el navegador en: http://localhost:8080/swagger-ui.html
2. Se busca el endpoint `POST /api/auth/login` y se hace clic en "Try it out"
3. Se ingresan las credenciales:
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
4. Se hace clic en "Execute"
5. Se copia el `token` de la respuesta
6. Se hace clic en el botón "Authorize" (arriba a la derecha, con icono de candado)
7. Se ingresa: `Bearer <tu-token-aqui>` y se hace clic en "Authorize"
8. ¡Listo! Ahora se pueden probar todos los endpoints directamente desde Swagger

**Respuesta esperada:**
```json
{
  "token": "eyJhbGciOiJIUzM4NCJ9...",
  "type": "Bearer"
}
```

#### Opción 2: Usar Postman o Thunder Client

1. Se crea una nueva petición **POST**
2. URL: `http://localhost:8080/api/auth/login`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
5. Se envía la petición
6. Se copia el `token` de la respuesta
7. Para otras peticiones, se agrega el header: `Authorization: Bearer <token>`

#### Opción 3: Usar PowerShell o curl

**PowerShell:**
```powershell
$body = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $body -ContentType "application/json"
$token = $response.token
Write-Host "Token: $token"
```

**curl:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### Usar el token en las peticiones

Una vez obtenido el token, se incluye en todas las peticiones protegidas agregando el header:

```
Authorization: Bearer <tu-token-aqui>
```

**Ejemplo en PowerShell:**
```powershell
$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method GET -Headers $headers
```

**Ejemplo en curl:**
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer tu-token-aqui"
```

---

## Endpoints disponibles

### Backend API (Puerto 8080)

#### Autenticación
- `POST /api/auth/login` - Obtener token JWT

#### Usuarios
- `GET /api/users` - Listar todos los usuarios
- `GET /api/users/{id}` - Obtener usuario por ID
- `POST /api/users` - Crear nuevo usuario
- `PUT /api/users/{id}` - Actualizar usuario

#### Tickets
- `GET /api/tickets` - Listar tickets (con filtros opcionales: `?status=ABIERTO&userId=<uuid>&page=0&size=10`)
- `GET /api/tickets/{id}` - Obtener ticket por ID
- `POST /api/tickets` - Crear nuevo ticket
- `PUT /api/tickets/{id}` - Actualizar ticket
- `DELETE /api/tickets/{id}` - Eliminar ticket
- `GET /api/tickets/user/{userId}` - Obtener tickets de un usuario específico

### Frontend BFF (Puerto 3000)

El frontend actúa como un BFF (Backend for Frontend) y expone los mismos endpoints:

- `GET /health` - Health check del servicio
- `GET /users` - Listar todos los usuarios
- `GET /users/:id` - Obtener usuario por ID
- `POST /users` - Crear nuevo usuario
- `PUT /users/:id` - Actualizar usuario
- `GET /tickets` - Listar tickets (con filtros opcionales)
- `GET /tickets/:id` - Obtener ticket por ID
- `POST /tickets` - Crear nuevo ticket
- `PUT /tickets/:id` - Actualizar ticket
- `GET /tickets/user/:userId` - Obtener tickets de un usuario específico

> **Nota:** El BFF requiere autenticación JWT del backend. Primero se obtiene el token desde `http://localhost:8080/api/auth/login` y luego se usa en las peticiones al BFF.

---

## Cómo probar los endpoints

### Opción 1: Swagger UI (Interfaz gráfica) 

Swagger UI es la forma más fácil de probar todos los endpoints:

1. Se abre el navegador en: http://localhost:8080/swagger-ui.html
2. Se hace login siguiendo los pasos de la sección [Cómo obtener el token JWT](#cómo-obtener-el-token-jwt)
3. Se autoriza con el token usando el botón "Authorize"
4. Se puede probar cualquier endpoint directamente desde la interfaz

**Ventajas:**
- Interfaz gráfica intuitiva
- Documentación interactiva
- No requiere herramientas externas
- Permite ver las respuestas en tiempo real

### Opción 2: Postman o Thunder Client

1. Se importa la colección de endpoints (opcional)
2. Se crea una petición de login para obtener el token
3. Se configura el token en las variables de entorno o en cada petición
4. Se prueban los endpoints uno por uno

**Ventajas:**
- Permite guardar colecciones de peticiones
- Facilita el trabajo en equipo
- Permite automatizar pruebas

### Opción 3: Scripts automatizados (PowerShell)

Se pueden usar scripts para probar múltiples endpoints automáticamente. Consulta los scripts disponibles en el repositorio.

---

## Ejemplos de uso

### Crear un usuario

**PowerShell:**
```powershell
$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

$user = @{
    firstName = "Juan"
    lastName = "Pérez"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method POST -Headers $headers -Body $user
```

**curl:**
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"Juan","lastName":"Pérez"}'
```

### Crear un ticket

**PowerShell:**
```powershell
$ticket = @{
    description = "Problema con acceso al sistema de eventos"
    userId = "<uuid-del-usuario>"
    status = "ABIERTO"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets" -Method POST -Headers $headers -Body $ticket
```

**curl:**
```bash
curl -X POST http://localhost:8080/api/tickets \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Problema con acceso al sistema de eventos",
    "userId": "<uuid-del-usuario>",
    "status": "ABIERTO"
  }'
```

### Filtrar tickets

**PowerShell:**
```powershell
# Filtrar por estado
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?status=ABIERTO" -Method GET -Headers $headers

# Filtrar por usuario y estado
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?status=ABIERTO&userId=<uuid>" -Method GET -Headers $headers

# Con paginación
$tickets = Invoke-RestMethod -Uri "http://localhost:8080/api/tickets?page=0&size=10" -Method GET -Headers $headers
```

**curl:**
```bash
# Filtrar por estado
curl -X GET "http://localhost:8080/api/tickets?status=ABIERTO" \
  -H "Authorization: Bearer $token"

# Con paginación
curl -X GET "http://localhost:8080/api/tickets?page=0&size=10" \
  -H "Authorization: Bearer $token"
```

---

## Ver los datos en la base de datos H2

1. Se abre el navegador en: http://localhost:8080/h2-console
2. Se ingresan los siguientes datos:
   - **JDBC URL**: `jdbc:h2:mem:eventdb`
   - **Usuario**: `sa`
   - **Password**: `sa`
3. Se hace clic en "Connect"
4. Se ejecutan consultas SQL:
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

---

## Solución de problemas comunes

### El backend no inicia
- Se verifica que se tenga Java 17+ instalado: `java -version`
- Se asegura de estar en el directorio `backend/`
- Si hay errores de puerto, se verifica que el puerto 8080 no esté en uso

### El frontend no se conecta al backend
- Se verifica que el backend esté corriendo en `http://localhost:8080`
- Se revisan las variables de entorno `API_BASE_URL`, `API_USERNAME`, `API_PASSWORD`
- Se asegura de que ambos servicios estén en la misma red (si se usa Docker)

### Error 401/403 en las peticiones
- Se asegura de haber obtenido un token JWT válido desde `/api/auth/login`
- Se verifica que el header `Authorization: Bearer <token>` esté presente
- El token expira después de 24 horas, se obtiene uno nuevo si es necesario
- Se verifica que el usuario tenga los permisos necesarios (ADMIN para crear/actualizar/eliminar)

### Error al ejecutar Maven Wrapper
- En Windows, se usa `.\mvnw.cmd` en lugar de `./mvnw`
- Se asegura de tener permisos de ejecución en el archivo `mvnw` (Linux/Mac): `chmod +x mvnw`

### Swagger UI no muestra el botón "Authorize"
- Se verifica que se haya configurado correctamente la seguridad JWT en el backend
- Se refresca la página o se limpia la caché del navegador
- Se verifica que se esté accediendo a la URL correcta: http://localhost:8080/swagger-ui.html

### Los contenedores Docker no inician
- Se verifica que Docker Desktop esté corriendo
- Se revisan los logs: `docker compose logs`
- Se consulta la sección de solución de problemas comunes con Docker más arriba

---

## Seguridad

El backend utiliza autenticación JWT (JSON Web Tokens) con usuarios en memoria:

| Usuario | Rol  | Contraseña |
|---------|------|------------|
| admin   | ADMIN| `admin123`  |
| analyst | USER | `analyst123`|

### Autenticación
1. Se obtiene el token JWT: `POST /api/auth/login` con `{"username": "admin", "password": "admin123"}`
2. Se usa el token: Se incluye en el header `Authorization: Bearer <token>`

### Permisos
- `USER`: Se pueden consumir endpoints GET (solo lectura)
- `ADMIN`: Se pueden crear, actualizar o eliminar recursos (CRUD completo)

Los recursos de Swagger y H2 permanecen públicos para facilitar las pruebas locales.

---

## Ejecutar con Docker Compose

```bash
docker compose up --build
```

Esto levanta ambos servicios y se abren los mismos puertos (`8080` backend, `3000` frontend) dentro de la misma red para facilitar las llamadas internas.
