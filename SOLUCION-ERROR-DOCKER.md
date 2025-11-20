# Solución: Error 500 al levantar Docker Compose

## 🔴 Error que se está viendo

```
unable to get image 'event-platform-frontend': request returned 500 Internal Server Error
```

Este error indica que Docker Desktop no está completamente iniciado o hay un problema de conexión con el daemon de Docker.

---

## ✅ Soluciones (en orden de prioridad)

### Solución 1: Reiniciar Docker Desktop

1. **Se cierra Docker Desktop completamente:**
   - Se hace clic derecho en el ícono de Docker en la bandeja del sistema
   - Se selecciona "Quit Docker Desktop"
   - Se espera a que se cierre completamente

2. **Se abre Docker Desktop nuevamente:**
   - Se busca "Docker Desktop" en el menú de inicio
   - Se abre y **se espera 1-2 minutos** hasta que el ícono deje de animarse
   - El ícono debe mostrar "Docker Desktop is running"

3. **Se verifica que funciona:**
   ```powershell
   docker ps
   ```
   Se debería ver una tabla vacía (sin errores)

4. **Se intenta nuevamente:**
   ```powershell
   docker compose up --build
   ```

---

### Solución 2: Verificar WSL 2

El error puede ser causado por problemas con WSL 2:

1. **Se verifica el estado de WSL:**
   ```powershell
   wsl --status
   ```
   Debe mostrar: `Default Version: 2`

2. **Si no está en versión 2, se actualiza:**
   ```powershell
   wsl --set-default-version 2
   ```

3. **Se reinicia Docker Desktop** después de cambiar WSL

---

### Solución 3: Limpiar recursos Docker

A veces hay imágenes o contenedores corruptos:

1. **Se detienen todos los contenedores:**
   ```powershell
   docker compose down
   ```

2. **Se limpian recursos no utilizados:**
   ```powershell
   docker system prune -a --volumes -f
   ```
   ⚠️ Esto eliminará todas las imágenes, contenedores y volúmenes no utilizados

3. **Se intenta nuevamente:**
   ```powershell
   docker compose up --build
   ```

---

### Solución 4: Reconstruir sin caché

Si hay problemas con la caché de Docker:

1. **Se reconstruye sin usar caché:**
   ```powershell
   docker compose build --no-cache
   ```

2. **Luego se levantan los servicios:**
   ```powershell
   docker compose up
   ```

---

### Solución 5: Verificar configuración de Docker Desktop

1. **Se abre Docker Desktop**
2. **Se va a Settings (Configuración)**
3. **General:**
   - ✅ Se marca "Use the WSL 2 based engine"
   - ✅ Se marca "Start Docker Desktop when you log in" (opcional)
4. **Resources:**
   - Se verifica que se tengan al menos 4GB de RAM asignados
   - Se verifica que se tengan al menos 20GB de espacio en disco
5. **Apply & Restart**

---

### Solución 6: Usar el script de diagnóstico

Se ejecuta el script de diagnóstico que se creó:

```powershell
.\diagnosticar-docker.ps1
```

Este script ayudará a identificar el problema específico.

---

### Solución 7: Reinstalar Docker Desktop (último recurso)

Si nada funciona:

1. **Se desinstala Docker Desktop:**
   - Panel de Control → Programas → Desinstalar
   - O desde Settings de Windows

2. **Se descarga e instala nuevamente:**
   - https://www.docker.com/products/docker-desktop/
   - Se sigue el proceso de instalación completo

3. **Se reinicia la computadora**

4. **Se inicia Docker Desktop y se espera a que esté completamente listo**

5. **Se intenta nuevamente**

---

## 🔍 Verificar que Docker funciona correctamente

Se ejecutan estos comandos para verificar:

```powershell
# 1. Verificar versión
docker --version

# 2. Verificar que el daemon responde
docker ps

# 3. Verificar información del sistema
docker info

# 4. Probar con una imagen simple
docker run hello-world
```

Si todos estos comandos funcionan sin errores, Docker está funcionando correctamente.

---

## 📝 Comandos útiles para diagnóstico

```powershell
# Ver logs de Docker Desktop
# (Se abre Docker Desktop → Troubleshoot → View logs)

# Ver contenedores corriendo
docker ps

# Ver todos los contenedores (incluyendo detenidos)
docker ps -a

# Ver imágenes
docker images

# Ver redes
docker network ls

# Ver volúmenes
docker volume ls

# Ver logs de docker compose
docker compose logs

# Ver logs de un servicio específico
docker compose logs backend
docker compose logs frontend
```

---

## ⚡ Solución Rápida (Resumen)

Si quieres intentar todo de una vez:

```powershell
# 1. Detén todo
docker compose down

# 2. Limpia recursos
docker system prune -a --volumes -f

# 3. Reinicia Docker Desktop (manual)

# 4. Espera 1-2 minutos

# 5. Verifica
docker ps

# 6. Reconstruye y levanta
docker compose up --build
```

---

## 🆘 Si el problema persiste

1. **Se revisan los logs de Docker Desktop:**
   - Docker Desktop → Troubleshoot → View logs

2. **Se verifica el Event Viewer de Windows:**
   - Se buscan errores relacionados con Docker o WSL

3. **Se consulta la documentación oficial:**
   - https://docs.docker.com/desktop/troubleshoot/

4. **Se verifica que el sistema cumple los requisitos:**
   - Windows 10/11 64-bit
   - WSL 2 habilitado
   - Virtualización habilitada en BIOS

---

## ✅ Checklist de verificación

Antes de intentar levantar el proyecto, verifica:

- [ ] Docker Desktop está instalado
- [ ] Docker Desktop está corriendo (ícono en bandeja)
- [ ] `docker ps` funciona sin errores
- [ ] `docker compose version` muestra la versión
- [ ] WSL 2 está habilitado (`wsl --status`)
- [ ] Tienes suficiente RAM (4GB+)
- [ ] Tienes suficiente espacio en disco (20GB+)
- [ ] Estás en el directorio correcto del proyecto
- [ ] `docker-compose.yml` existe en la raíz

---

¡Espero que esto resuelva tu problema! 🚀


