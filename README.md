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

### Opción 1: Levantar manualmente (paso a paso)

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
   - API: `http://localhost:8080`
   - Swagger UI: `http://localhost:8080/api/swagger`
   - H2 Console: `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:eventdb`)

#### Paso 2: Obtener token JWT (opcional, pero recomendado)

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
   - BFF API: `http://localhost:3000`
   - Health Check: `http://localhost:3000/health`

### Opción 2: Levantar con Docker Compose (todo en uno)

> 📖 **¿Primera vez usando Docker?** Consulta la [Guía Completa de Docker](GUIA-DOCKER.md) que incluye instrucciones paso a paso desde la instalación.

#### Pasos rápidos:

1. **Asegúrate de tener Docker Desktop instalado y corriendo**
   - Descarga desde: https://www.docker.com/products/docker-desktop/
   - Inicia Docker Desktop y espera a que esté listo

2. **Verifica la instalación:**
```bash
docker --version
docker compose version
```

3. **Desde la raíz del proyecto, ejecuta:**
```bash
# Opción A: Usar el script automatizado (Windows)
.\levantar-proyecto-docker.ps1

# Opción B: Comando manual
docker compose up --build
```

4. **Espera a que los servicios inicien** (5-10 minutos la primera vez)

5. **Verifica que todo funciona:**
   - Backend: http://localhost:8080
   - Swagger: http://localhost:8080/api/swagger
   - Frontend: http://localhost:3000

6. **Para detener los servicios:**
```bash
# Presiona Ctrl+C en la terminal donde corre Docker
# O ejecuta en otra terminal:
docker compose down
```

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

## Ejemplos de uso

### 1. Crear un usuario
```bash
POST http://localhost:8080/api/users
Authorization: Bearer <tu-token>
Content-Type: application/json

{
  "firstName": "Juan",
  "lastName": "Pérez"
}
```

### 2. Crear un ticket
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

### 3. Filtrar tickets por estatus
```bash
GET http://localhost:8080/api/tickets?status=ABIERTO&page=0&size=10
Authorization: Bearer <tu-token>
```

### 4. Obtener tickets de un usuario
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