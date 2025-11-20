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

## Ejecutar con Docker Compose
```
docker compose up --build
```
Esto levanta ambos servicios y abre los mismos puertos (`8080` backend, `3000` frontend) dentro de la misma red para facilitar las llamadas internas.

## Siguientes pasos
1. Modelar las entidades `Usuario` y `Ticket` en el backend.
2. Exponer los endpoints CRUD y filtros descritos en la prueba.
3. Implementar la capa BFF en NestJS y conectar ambos servicios mediante DTOs compartidos.
4. Agregar pruebas unitarias e integraciÃ³n, ademÃ¡s de seguridad y documentaciÃ³n detallada.