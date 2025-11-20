# Script para corregir acentos en mensajes de commit
$commits = @(
    @{hash="52b9c90"; old="extender documentaciÃ³n OpenAPI y agregar endpoint DELETE"; new="extender documentación OpenAPI y agregar endpoint DELETE"},
    @{hash="7e9ef52"; old="implementar autenticaciÃ³n JWT y pruebas de integraciÃ³n"; new="implementar autenticación JWT y pruebas de integración"},
    @{hash="170e264"; old="docs: agregar guÃ­a paso a paso para levantar el proyecto"; new="docs: agregar guía paso a paso para levantar el proyecto"},
    @{hash="5f2453b"; old="docs: agregar guÃ­a completa paso a paso para Docker"; new="docs: agregar guía completa paso a paso para Docker"},
    @{hash="6f2c621"; old="docs: agregar diagnÃ³stico y soluciÃ³n para error 500 de Docker"; new="docs: agregar diagnóstico y solución para error 500 de Docker"},
    @{hash="86542d3"; old="fix: corregir errores de sintaxis en script de diagnÃ³stico"; new="fix: corregir errores de sintaxis en script de diagnóstico"},
    @{hash="1c88256"; old="feat: agregar script completo para probar todos los endpoints automÃ¡ticamente"; new="feat: agregar script completo para probar todos los endpoints automáticamente"},
    @{hash="add5331"; old="docs: reorganizar README con toda la informaciÃ³n necesaria y eliminar archivos redundantes"; new="docs: reorganizar README con toda la información necesaria y eliminar archivos redundantes"},
    @{hash="77e9087"; old="docs: mejorar secciÃ³n de Docker en README y eliminar archivos de diagnÃ³stico y verificaciÃ³n"; new="docs: mejorar sección de Docker en README y eliminar archivos de diagnóstico y verificación"},
    @{hash="dc3e970"; old="docs: cambiar todo el README a construcciÃ³n impersonal con 'se'"; new="docs: cambiar todo el README a construcción impersonal con 'se'"}
)

Write-Host "Iniciando corrección de acentos en commits..." -ForegroundColor Yellow

foreach ($commit in $commits) {
    Write-Host "Corrigiendo commit $($commit.hash)..." -ForegroundColor Cyan
    $env:GIT_SEQUENCE_EDITOR = "sed -i 's/^pick $($commit.hash)/edit $($commit.hash)/'"
    git rebase -i $commit.hash^
    
    git commit --amend -m $commit.new
    git rebase --continue
}

Write-Host "Corrección completada!" -ForegroundColor Green
