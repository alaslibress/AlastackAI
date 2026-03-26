# AlastackAI: Universal AI Environment Setup

**AlastackAI** es un *boilerplate* automatizado diseñado por [@alaslibress] para desplegar entornos de desarrollo asistidos por Inteligencia Artificial en segundos. Implementa la metodología **Agents Team Lite**, transformando un repositorio vacío en una fábrica de software estructurada, segura y operada por múltiples agentes de IA especializados (Claude Code).

---

## Qué es y para qué sirve

Cuando desarrollas proyectos complejos con IA, los asistentes tienden a mezclar contextos, romper arquitecturas o sobrescribir código accidentalmente. AlastackAI soluciona esto aplicando **aislamiento de dominios e inyección de contexto**.

Al ejecutar el script de inicialización, el sistema automatiza la creación de:

1. **Aislamiento Físico (Git Worktrees):** Divide tu proyecto en laboratorios independientes (`/backend`, `/frontend`, `/infra`). Los agentes de un dominio no pueden romper el código de otro.
2. **Memoria Global (`engram.md`):** Crea un "hipocampo" centralizado donde defines la visión y reglas de negocio de tu proyecto para que todos los agentes compartan el mismo objetivo.
3. **Inyección de Skills de Nivel Senior:** Despliega automáticamente directrices de industria en carpetas ocultas (`.claude/skills/`). La IA programará usando Clean Architecture, TypeScript estricto y políticas Zero Trust por defecto.
4. **Identidades Multi-Agente:** Configura archivos `CLAUDE.md` locales para que la IA asuma roles específicos según la carpeta en la que te encuentres (por ejemplo, *Frontend Implementer* o *DevOps Architect*).
5. **GGA CLI (Global Assistant Wrapper):** Instala un comando de terminal ligero (`gga`) para orquestar los modos "Pensador" (Opus) y "Ejecutor" (Sonnet) sin tener que recordar comandos complejos.

---

## Requisitos Previos

Antes de ejecutar AlastackAI, asegúrate de tener instalado en tu sistema:

- **Git** (el repositorio debe estar inicializado)
- **Claude Code** de Anthropic (CLI oficial)
- Una terminal compatible (Bash/Zsh para Linux/macOS o PowerShell para Windows)

---

## Instalación en Linux y macOS

**Distribuciones compatibles:** Ubuntu, Debian, Fedora, Arch Linux, CentOS, openSUSE y cualquier entorno macOS utilizando Bash o Zsh.

1. Navega a la carpeta de tu nuevo proyecto e inicializa Git:

   ```bash
   mkdir mi-nuevo-proyecto && cd mi-nuevo-proyecto
   git init
   ```

2. Descarga o copia el script `alastack-init.sh` en la raíz de la carpeta.

3. Otorga permisos de ejecución y lanza el instalador:

   ```bash
   chmod +x alastack-init.sh
   ./alastack-init.sh
   ```

4. Activa el CLI: al finalizar, el script te proporcionará un comando para añadir `gga` a tu sesión actual. Ejecútalo:

   ```bash
   export PATH="$PWD/.bin:$PATH"
   ```

---

## Instalación en Windows

**Compatibilidad:** Windows 10 y Windows 11 utilizando PowerShell 5.1 o PowerShell Core (`pwsh`).

1. Abre PowerShell, crea tu carpeta e inicializa Git:

   ```powershell
   mkdir mi-nuevo-proyecto
   cd mi-nuevo-proyecto
   git init
   ```

2. Descarga o copia el script `alastack-init.ps1` en la raíz de la carpeta.

3. Permite la ejecución temporal de scripts en tu terminal y lanza el instalador:

   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   .\alastack-init.ps1
   ```

4. Activa el CLI: copia y pega el comando que aparece al final de la instalación para registrar `gga.bat`:

   ```powershell
   $env:PATH = "$PWD\.bin;$env:PATH"
   ```

---

## Flujo de Trabajo

Una vez instalado, abre el archivo `engram.md` en la raíz y define de qué trata tu proyecto. Luego, navega a cualquier carpeta de dominio (por ejemplo, `cd backend`) y utiliza el CLI:

**Paso 1: Planificar (Modo Arquitecto / Opus)**

```bash
gga plan "Diseña la estructura de la base de datos para los usuarios y guárdalo en un archivo PLAN.md"
```

El agente leerá las skills, el engram y generará un documento arquitectónico sin tocar el código fuente.

**Paso 2: Ejecutar (Modo Implementador / Sonnet)**

```bash
gga do "Implementa el código exacto descrito en el PLAN.md"
```

El agente leerá el plan aprobado y escribirá el código de producción respetando el aislamiento de su dominio.

**Paso 3: Terminal interactiva**

```bash
gga
```

Abre la consola estándar de Claude Code manteniendo el contexto de AlastackAI.
