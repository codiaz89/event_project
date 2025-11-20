# Cómo hacer login en el proyecto

## El problema que se está viendo

Si se intenta abrir `http://localhost:8080/api/auth/login` directamente en el navegador, se verá un error **405 Method Not Allowed** porque:

- El navegador hace una petición **GET** por defecto
- El endpoint `/api/auth/login` solo acepta peticiones **POST**

## Solución: 3 formas de hacer login

### Opción 1: Usar Swagger UI (Más fácil) ⭐

1. Se abre Swagger UI: http://localhost:8080/swagger-ui.html
2. Se busca el endpoint `POST /api/auth/login`
3. Se hace clic en "Try it out"
4. Se ingresan las credenciales:
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
5. Se hace clic en "Execute"
6. Se copia el `jwtToken` de la respuesta
7. Se hace clic en el botón "Authorize" (arriba a la derecha)
8. Se pega el token: `Bearer <tu-token-aqui>`
9. ¡Listo! Ahora se pueden probar todos los endpoints

### Opción 2: Usar PowerShell

```powershell
# 1. Hacer login
$body = @{
    username = "admin"
    password = "admin123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $body -ContentType "application/json"

# 2. Ver el token
$token = $response.jwtToken
Write-Host "Tu token es: $token"

# 3. Usar el token para hacer peticiones
$headers = @{
    Authorization = "Bearer $token"
}

# Ejemplo: Listar usuarios
$users = Invoke-RestMethod -Uri "http://localhost:8080/api/users" -Method GET -Headers $headers
$users
```

### Opción 3: Usar Postman o Thunder Client

1. Crea una nueva petición **POST**
2. URL: `http://localhost:8080/api/auth/login`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
   ```json
   {
     "username": "admin",
     "password": "admin123"
   }
   ```
5. Envía la petición
6. Copia el `jwtToken` de la respuesta
7. Para otras peticiones, agrega el header: `Authorization: Bearer <token>`

### Opción 4: Usar el script automatizado

Se ejecuta el script que ya se creó:

```powershell
.\probar-api.ps1
```

Este script hace el login automáticamente y prueba todos los endpoints.

## Credenciales disponibles

| Usuario | Password | Rol | Permisos |
|---------|----------|-----|----------|
| `admin` | `admin123` | ADMIN | Puede hacer todo (crear, leer, actualizar, eliminar) |
| `analyst` | `analyst123` | USER | Solo puede leer (GET) |

## Respuesta esperada del login

```json
{
  "jwtToken": "eyJhbGciOiJIUzM4NCJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9BRE1JTiJ9XSwic3ViIjoiYWRtaW4iLCJpYXQiOjE3NjM2NjM1NjAsImV4cCI6MTc2Mzc0OTk2MH0..."
}
```

## ¿Por qué no funciona en el navegador directamente?

Cuando se escribe una URL en el navegador, este hace una petición **GET**. Pero el login necesita enviar datos (username y password), por lo que requiere un **POST**.

Es como intentar enviar una carta sin ponerla en un sobre: se necesita usar el método correcto (POST) para enviar los datos.

## Próximos pasos

1. **Se usa Swagger UI** (la opción más fácil): http://localhost:8080/swagger-ui.html
2. O se ejecuta el script: `.\probar-api.ps1`

¡Eso es todo! 🚀

