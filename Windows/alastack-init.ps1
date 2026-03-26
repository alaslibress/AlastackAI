# ==============================================================================
# AlastackAI - Universal AI Environment Setup Script (Agents Team Lite) - WINDOWS
# Autor: @alaslibress
# Descripcion: Automatiza la creacion de Worktrees, inyeccion de Skills base,
#              generacion de Engram global, CLI GGA y perfiles de Agentes.
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host " Iniciando Bootstrap: AlastackAI + Engram + Agents Team Lite      " -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if (!(Test-Path ".git")) {
    Write-Host "[ERROR] Este script debe ejecutarse en la raiz de un repositorio Git inicializado." -ForegroundColor Red
    exit 1
}

Write-Host "Paso 1: Configurando Git Worktrees (Aislamiento de Dominios)..." -ForegroundColor Cyan
function Crear-Worktree {
    param([string]$folder, [string]$branch)
    if (!(Test-Path $folder)) {
        Write-Host "  -> Creando entorno aislado: $folder (Rama: $branch)"
        git branch $branch 2>$null
        git worktree add $folder $branch
    } else {
        Write-Host "  -> Entorno $folder ya existe." -ForegroundColor Yellow
    }
}

Crear-Worktree "backend" "dev/backend"
Crear-Worktree "frontend" "dev/frontend"
Crear-Worktree "infra" "dev/infra"

Write-Host "`nPaso 2: Inyectando Skills Base (Mejores Practicas Genericas)..." -ForegroundColor Cyan
function Inyectar-Archivo {
    param([string]$path, [string]$content)
    $dir = Split-Path $path
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
    Set-Content -Path $path -Value $content -Encoding UTF8
    Write-Host "  -> Archivo forjado: $path"
}

$backendSkill = @"
# Generic Backend Guidelines
1. Architecture: Strictly follow Clean Architecture / Hexagonal Architecture principles. Isolate domain logic from frameworks.
2. Security: Never log sensitive data. Sanitize all inputs to prevent injection attacks.
3. Performance: Optimize database queries and avoid N+1 problems. Use pagination for large datasets.
4. Testing: Ensure high test coverage for core business logic.
"@
Inyectar-Archivo "backend\.claude\skills\backend-clean-architecture\SKILL.md" $backendSkill

$frontendSkill = @"
# Generic Frontend Guidelines
1. Architecture: Use modular, reusable, and isolated components.
2. State Management: Keep global state to an absolute minimum. Favor local state where possible.
3. Typing: Strictly enforce static typing (e.g., TypeScript). Prohibit the use of 'any' or implicit types.
4. UX/UI: Ensure responsive design and accessibility (a11y) standards by default.
"@
Inyectar-Archivo "frontend\.claude\skills\frontend-component-design\SKILL.md" $frontendSkill

$infraSkill = @"
# Generic Infrastructure Guidelines
1. Security: Zero Trust network policies. Deny all internal traffic by default.
2. Secrets Management: Never hardcode secrets. Always use a secure vault or managed secrets service.
3. Immutability: Treat infrastructure as immutable. Containerize all services with strict resource limits.
"@
Inyectar-Archivo "infra\.claude\skills\infrastructure-as-code\SKILL.md" $infraSkill

Write-Host "  -> Base de conocimiento inyectada en todos los dominios."

Write-Host "`nPaso 3: Forjando el Engram (Memoria Global del Proyecto)..." -ForegroundColor Cyan
$engramContent = @"
# AlastackAI - Global Engram Memory

**Project Vision:** [DEFINE TU PROYECTO AQUI - Reemplaza este texto con el objetivo principal de tu aplicacion]

**Core Directives for all Agents:**
1. Maintain strict domain isolation. Do not modify files outside your designated worktree.
2. Read the specific `/skills/` in your local `.claude` folder before writing any code.
3. Prioritize modularity, security, and clean code principles above all else.
"@
Inyectar-Archivo "engram.md" $engramContent
Write-Host "  -> engram.md creado en la raiz. (Recuerda editarlo con la vision de tu proyecto)."

Write-Host "`nPaso 4: Desplegando Matriz 'Agents Team Lite'..." -ForegroundColor Cyan

$agent0 = @"
# ROL: AGENTE 0 (Orchestrator)
Eres el Director de Orquesta de este proyecto bajo el estandar AlastackAI.
Tu mision: Planificar la arquitectura global y coordinar a los demas agentes. No escribas codigo de implementacion directa.
Siempre lee `engram.md` primero para entender el contexto de negocio.
"@
Inyectar-Archivo "CLAUDE.md" $agent0

$agent1 = @"
# ROL: AGENTE 1 (Backend Implementer)
Eres el especialista en logica de servidor y bases de datos.
Flujo de trabajo:
1. Lee `..\engram.md` para contexto global.
2. Genera o lee un `PLAN.md` antes de programar.
3. Aplica los principios de Clean Architecture definidos en tus skills locales.
"@
Inyectar-Archivo "backend\CLAUDE.md" $agent1

$agent2 = @"
# ROL: AGENTE 2 (Frontend Implementer)
Eres el especialista en interfaces de usuario y experiencia de cliente.
Flujo de trabajo:
1. Lee `..\engram.md` para contexto global.
2. Genera o lee un `PLAN.md` antes de programar.
3. Construye componentes robustos y tipados siguiendo tus skills locales.
"@
Inyectar-Archivo "frontend\CLAUDE.md" $agent2

$agent3 = @"
# ROL: AGENTE 3 (Infra / DevOps)
Eres el especialista en despliegues, contenedores y seguridad en la nube.
Flujo de trabajo:
1. Lee `..\engram.md` para contexto global.
2. Diseña manifiestos (Docker, Kubernetes, Terraform) seguros y escalables.
3. Aplica politicas de Zero Trust y gestion segura de secretos.
"@
Inyectar-Archivo "infra\CLAUDE.md" $agent3

Write-Host "  -> Identidades de agentes asignadas a la estructura."

Write-Host "`nPaso 5: Compilando el CLI 'GGA' (Gentleman Guardian Angel) para Windows..." -ForegroundColor Cyan
if (!(Test-Path ".bin")) { New-Item -ItemType Directory -Force -Path ".bin" | Out-Null }

$ggaBat = @"
@echo off
setlocal
set CMD=%~1
set ARGS=

:loop
shift
if "%~1"=="" goto after_loop
set ARGS=%ARGS% "%~1"
goto loop
:after_loop

if "%CMD%"=="plan" goto plan
if "%CMD%"=="think" goto plan
if "%CMD%"=="do" goto do
if "%CMD%"=="code" goto do
goto default

:plan
echo [AlastackAI] Invocando Modo Pensamiento (Arquitectura/Planificacion)...
claude --model claude-3-opus-20240229 %ARGS%
goto end

:do
echo [AlastackAI] Invocando Modo Ejecucion (Implementacion)...
claude --model claude-3-5-sonnet-20241022 %ARGS%
goto end

:default
echo Uso de GGA (Gentleman Guardian Angel):
echo   gga plan [prompt] -^> Inicia el modelo pensante para crear un PLAN.md.
echo   gga do [prompt]   -^> Inicia el modelo ejecutor para escribir el codigo.
echo   gga               -^> Abre la terminal interactiva de Claude Code.
if "%CMD%"=="" (
    claude
) else (
    claude %CMD% %ARGS%
)

:end
"@
Inyectar-Archivo ".bin\gga.bat" $ggaBat
Write-Host "  -> CLI 'gga.bat' configurado."

Write-Host "`nPaso 6: Activacion del Entorno AlastackAI" -ForegroundColor Cyan
Write-Host "Ejecuta este comando en tu terminal actual de PowerShell para activar el CLI:" -ForegroundColor Yellow
Write-Host "`$env:PATH = `"`$PWD\.bin;`$env:PATH`"" -ForegroundColor Green
Write-Host ""
Write-Host "El ecosistema AlastackAI esta listo. Modifica engram.md con los detalles de tu nuevo proyecto y a construir." -ForegroundColor Green
