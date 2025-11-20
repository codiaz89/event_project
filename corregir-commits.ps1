# Script para corregir mensajes de commit con caracteres mal codificados y prefijos inconsistentes

$commits = @(
    @{hash="dc3e970"; old="docs: cambiar todo el README a construcciÃ³n impersonal con 'se'"; new="docs: cambiar todo el README a construcción impersonal con 'se'"},
    @{hash="958bb9f"; old="docs: eliminar archivo SOLUCION-ERROR-DOCKER.md y actualizar referencias en README"; new="docs: eliminar archivo SOLUCION-ERROR-DOCKER.md y actualizar referencias en README"},
    @{hash="77e9087"; old="docs: mejorar secciÃ³n de Docker en README y eliminar archivos de diagnÃ³stico y verificaciÃ³n"; new="docs: mejorar sección de Docker en README y eliminar archivos de diagnóstico y verificación"},
    @{hash="add5331"; old="docs: reorganizar README con toda la informaciÃ³n necesaria y eliminar archivos redundantes"; new="docs: reorganizar README con toda la información necesaria y eliminar archivos redundantes"},
    @{hash="7fe7140"; old="fix: corregir caracter & en nombres de pruebas usando concatenacion"; new="fix: corregir caracter & en nombres de pruebas usando concatenación"},
    @{hash="c939ef1"; old="fix: corregir error de sintaxis con caracter & en URLs de PowerShell"; new="fix: corregir error de sintaxis con caracter & en URLs de PowerShell"},
    @{hash="3c07cd2"; old="docs: actualizar README con nuevo script de pruebas completo"; new="docs: actualizar README con nuevo script de pruebas completo"},
    @{hash="1c88256"; old="feat: agregar script completo para probar todos los endpoints automÃ¡ticamente"; new="feat: agregar script completo para probar todos los endpoints automáticamente"},
    @{hash="fd99501"; old="docs: corregir acentos y cambiar indicaciones a tercera persona en todos los README"; new="docs: corregir acentos y cambiar indicaciones a tercera persona en todos los README"},
    @{hash="2b48b5e"; old="docs: actualizar instrucciones para levantar el proyecto con Docker Compose"; new="docs: actualizar instrucciones para levantar el proyecto con Docker Compose"},
    @{hash="4b84289"; old="refactor: remover import no utilizado de Contact"; new="refactor: remover import no utilizado de Contact"},
    @{hash="bbbee5a"; old="refactor: remover informacion de contacto de Swagger UI"; new="refactor: remover información de contacto de Swagger UI"},
    @{hash="045f4a3"; old="feat: configurar Swagger UI para mostrar API local por defecto"; new="feat: configurar Swagger UI para mostrar API local por defecto"},
    @{hash="570774c"; old="feat: agregar configuracion de seguridad JWT en Swagger UI"; new="feat: agregar configuración de seguridad JWT en Swagger UI"},
    @{hash="fbaed1a"; old="fix: corregir configuracion de seguridad para Swagger UI"; new="fix: corregir configuración de seguridad para Swagger UI"},
    @{hash="b967803"; old="fix: corregir manejo de token en script de pruebas"; new="fix: corregir manejo de token en script de pruebas"},
    @{hash="978d4ca"; old="docs: agregar guia completa de uso con datos reales y script de pruebas"; new="docs: agregar guía completa de uso con datos reales y script de pruebas"},
    @{hash="68828c9"; old="docs: agregar guia de verificacion del proyecto"; new="docs: agregar guía de verificación del proyecto"},
    @{hash="ccc6b00"; old="fix: corregir errores de TypeScript en build del frontend"; new="fix: corregir errores de TypeScript en build del frontend"},
    @{hash="86542d3"; old="fix: corregir errores de sintaxis en script de diagnÃ³stico"; new="fix: corregir errores de sintaxis en script de diagnóstico"},
    @{hash="6f2c621"; old="docs: agregar diagnÃ³stico y soluciÃ³n para error 500 de Docker"; new="docs: agregar diagnóstico y solución para error 500 de Docker"},
    @{hash="1cf0526"; old="fix: corregir errores de sintaxis en script de Docker"; new="fix: corregir errores de sintaxis en script de Docker"},
    @{hash="5f2453b"; old="docs: agregar guÃ­a completa paso a paso para Docker"; new="docs: agregar guía completa paso a paso para Docker"},
    @{hash="170e264"; old="docs: agregar guÃ­a paso a paso para levantar el proyecto"; new="docs: agregar guía paso a paso para levantar el proyecto"},
    @{hash="7e9ef52"; old="implementar autenticaciÃ³n JWT y pruebas de integraciÃ³n"; new="feat: implementar autenticación JWT y pruebas de integración"},
    @{hash="52b9c90"; old="extender documentaciÃ³n OpenAPI y agregar endpoint DELETE"; new="feat: extender documentación OpenAPI y agregar endpoint DELETE"},
    @{hash="4ade7ce"; old="agregar BFF en NestJS"; new="feat: agregar BFF en NestJS"},
    @{hash="d5cfee6"; old="implementar dominio de usuarios y tickets"; new="feat: implementar dominio de usuarios y tickets"},
    @{hash="4314543"; old="Inicio del workspace fullstack"; new="feat: inicio del workspace fullstack"},
    @{hash="2a564b1"; old="Initial commit"; new="chore: initial commit"}
)

Write-Host "Corrigiendo mensajes de commit..." -ForegroundColor Yellow

foreach ($commit in $commits) {
    if ($commit.old -ne $commit.new) {
        Write-Host "Corrigiendo: $($commit.hash)" -ForegroundColor Cyan
        git commit --amend -m $commit.new --no-edit 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error al corregir commit $($commit.hash)" -ForegroundColor Red
        }
    }
}

Write-Host "Completado!" -ForegroundColor Green

