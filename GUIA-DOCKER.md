# Guía Completa: Levantar Proyecto con Docker

## 📋 Requisitos Previos

- Windows 10/11 (64-bit) con WSL 2 habilitado
- Al menos 4GB de RAM disponible
- Conexión a internet (para descargar imágenes de Docker)

---

## PASO 1: Instalar Docker Desktop

### 1.1 Descargar Docker Desktop

1. Se abre el navegador y se va a: **https://www.docker.com/products/docker-desktop/**
2. Se hace clic en el botón **"Download for Windows"**
3. Se descargará el archivo `Docker Desktop Installer.exe` (aproximadamente 500MB)

### 1.2 Instalar Docker Desktop

1. **Se ejecuta el instalador** que se acaba de descargar
2. Se aceptan los términos y condiciones
3. **Se marca la casilla**: "Use WSL 2 instead of Hyper-V" (recomendado)
4. Se hace clic en **"Ok"** para iniciar la instalación
5. Se espera a que termine la instalación (puede tomar varios minutos)
6. **Se reinicia la computadora** si se solicita

### 1.3 Iniciar Docker Desktop

1. Se busca **"Docker Desktop"** en el menú de inicio de Windows
2. Se hace clic para abrirlo
3. Se espera a que Docker Desktop se inicie completamente
4. Se verá el ícono de Docker (ballena) en la **bandeja del sistema** (tray, abajo a la derecha)
5. Cuando el ícono deje de animarse, Docker está listo

**⚠️ Importante**: Docker Desktop debe estar corriendo antes de continuar.

---

## PASO 2: Verificar la Instalación

Se abre **PowerShell** o **Terminal** y se ejecuta:

```powershell
docker --version
```

Se debería ver algo como: `Docker version 24.0.x, build xxxxx`

Luego se verifica Docker Compose:

```powershell
docker compose version
```

Se debería ver algo como: `Docker Compose version v2.x.x`

**Si se ven errores**: Se asegura de que Docker Desktop esté corriendo y se reinicia la terminal.

---

## PASO 3: Preparar el Proyecto

### 3.1 Navegar al Directorio del Proyecto

Se abre PowerShell o Terminal y se navega a la carpeta del proyecto:

```powershell
cd "E:\Pruebas Tecnicas\Double V\event_project"
```

### 3.2 Verificar que tienes los archivos necesarios

Se verifica que existan estos archivos:
- `docker-compose.yml` (en la raíz)
- `backend/` (directorio)
- `frontend/` (directorio)

Se puede verificar con:

```powershell
ls docker-compose.yml
ls backend
ls frontend
```

---

## PASO 4: Levantar el Proyecto con Docker Compose

### 4.1 Opción Automática (Recomendada)

Se ejecuta el script que se creó:

```powershell
.\levantar-proyecto-docker.ps1
```

Este script:
- ✅ Verifica que Docker esté instalado y corriendo
- ✅ Verifica la estructura del proyecto
- ✅ Construye las imágenes de Docker
- ✅ Levanta ambos servicios (backend y frontend)

### 4.2 Opción Manual

Si se prefiere hacerlo manualmente:

```powershell
docker compose up --build
```

**¿Qué hace este comando?**
- `docker compose up`: Levanta los servicios definidos en `docker-compose.yml`
- `--build`: Construye las imágenes de Docker antes de levantar (necesario la primera vez)

### 4.3 ¿Qué esperar?

La primera vez puede tomar **5-10 minutos** porque:
1. Descarga las imágenes base (Java, Node.js)
2. Compila el backend (Maven)
3. Instala dependencias del frontend (npm)
4. Construye las imágenes finales

Se verán muchos mensajes en la consola. **Es normal**. Se buscan estos mensajes al final:

```
backend  | Started EventBackendApplication in X.XXX seconds
frontend | [Nest] Application is running on: http://[::1]:3000
```

---

## PASO 5: Verificar que Todo Funciona

### 5.1 Verificar Backend

Se abre el navegador y se va a:

- **API Backend**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **H2 Console**: http://localhost:8080/h2-console

### 5.2 Verificar Frontend

- **Frontend BFF**: http://localhost:3000
- **Health Check**: http://localhost:3000/health

### 5.3 Obtener Token JWT

Para usar la API, se necesita autenticar:

1. Se abre **Postman**, **Thunder Client** o se usa **curl**:

```powershell
curl -X POST http://localhost:8080/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"username\":\"admin\",\"password\":\"admin123\"}'
```

2. Se copia el token de la respuesta
3. Se usa en las peticiones siguientes con el header:
   ```
   Authorization: Bearer <tu-token>
   ```

---

## PASO 6: Detener los Servicios

Cuando se quiera detener los servicios:

1. Se va a la terminal donde está corriendo Docker Compose
2. Se presiona **Ctrl + C**
3. Se espera a que los contenedores se detengan

O en otra terminal:

```powershell
docker compose down
```

Para detener y eliminar los contenedores y volúmenes:

```powershell
docker compose down -v
```

---

## 🐛 Solución de Problemas

### Error: "Docker daemon is not running"
**Solución**: Se inicia Docker Desktop y se espera a que esté completamente iniciado.

### Error: "Port already in use"
**Solución**: 
- Se verifica que no se tengan otros servicios usando los puertos 8080 o 3000
- O se cambian los puertos en `docker-compose.yml`

### Error: "Cannot connect to Docker daemon"
**Solución**: 
- Se reinicia Docker Desktop
- Se asegura de que WSL 2 esté habilitado

### Los servicios no inician
**Solución**:
1. Se detienen los servicios: `docker compose down`
2. Se limpian las imágenes: `docker compose down --rmi all`
3. Se vuelve a levantar: `docker compose up --build`

### Ver logs de un servicio específico
```powershell
docker compose logs backend
docker compose logs frontend
```

---

## 📝 Comandos Útiles

```powershell
# Ver servicios corriendo
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Reconstruir un servicio específico
docker compose up --build backend

# Detener servicios
docker compose stop

# Iniciar servicios (sin reconstruir)
docker compose start

# Ver uso de recursos
docker stats
```

---

## ✅ Checklist Final

- [ ] Docker Desktop instalado y corriendo
- [ ] `docker --version` funciona
- [ ] `docker compose version` funciona
- [ ] Estás en el directorio del proyecto
- [ ] `docker-compose.yml` existe
- [ ] Se ejecutó `docker compose up --build`
- [ ] Backend disponible en http://localhost:8080
- [ ] Frontend disponible en http://localhost:3000
- [ ] Se puede obtener un token JWT desde `/api/auth/login`

---

¡Listo! Tu proyecto debería estar corriendo con Docker. 🚀



