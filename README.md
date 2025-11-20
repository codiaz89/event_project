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

## Ejecutar el backend
```
cd backend
./mvnw spring-boot:run
```
La API quedarÃ¡ disponible en `http://localhost:8080` y expone Swagger en `http://localhost:8080/api/swagger`.

## Ejecutar el frontend
```
cd frontend
npm install
npm run start:dev
```
El gateway iniciarÃ¡ en `http://localhost:3000`.

### Endpoints BFF disponibles
- `GET /health`
- `GET /users`, `GET /users/:id`, `POST /users`, `PUT /users/:id`
- `GET /tickets`, `GET /tickets/:id`, `POST /tickets`, `PUT /tickets/:id`
- `GET /tickets/user/:userId`

## Ejecutar con Docker Compose
```
docker compose up --build
```
Esto levanta ambos servicios y abre los mismos puertos (`8080` backend, `3000` frontend) dentro de la misma red para facilitar las llamadas internas.

## Siguientes pasos
1. Construir las rutas del frontend en NestJS que consuman los endpoints creados.
2. Extender la documentaciÃ³n OpenAPI con ejemplos y colecciones de pruebas automatizadas.
3. Incorporar nuevas funcionalidades (asignaciones, mÃ©tricas, notificaciones) y pruebas end-to-end.

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