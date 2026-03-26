#!/bin/bash

# ==============================================================================
# AlastackAI - Universal AI Environment Setup Script (Agents Team Lite)
# Autor: @alaslibress
# Descripción: Automatiza la creacion de Worktrees, inyeccion de Skills base,
#              generacion de Engram global, CLI GGA y perfiles de Agentes.
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}==================================================================${NC}"
echo -e "${GREEN} Iniciando Bootstrap: AlastackAI + Engram + Agents Team Lite      ${NC}"
echo -e "${BLUE}==================================================================${NC}\n"

if [ ! -d ".git" ]; then
  echo -e "${RED}[ERROR] Este script debe ejecutarse en la raiz de un repositorio Git inicializado.${NC}"
  exit 1
fi

echo -e "${BLUE}Paso 1: Configurando Git Worktrees (Aislamiento de Dominios)...${NC}"
crear_worktree() {
    local folder=$1
    local branch=$2
    if [ ! -d "$folder" ]; then
        echo "  -> Creando entorno aislado: $folder (Rama: $branch)"
        git branch $branch 2>/dev/null || true
        git worktree add $folder $branch
    else
        echo "  -> Entorno $folder ya existe."
    fi
}

# Estructura generica aplicable a casi cualquier proyecto moderno
crear_worktree "backend" "dev/backend"
crear_worktree "frontend" "dev/frontend"
crear_worktree "infra" "dev/infra"

echo -e "\n${BLUE}Paso 2: Inyectando Skills Base (Mejores Practicas Genericas)...${NC}"
inyectar_archivo() {
    local path=$1
    local content=$2
    mkdir -p "$(dirname "$path")"
    echo "$content" > "$path"
}

inyectar_archivo "backend/.claude/skills/backend-clean-architecture/SKILL.md" "\
# Generic Backend Guidelines
1. Architecture: Strictly follow Clean Architecture / Hexagonal Architecture principles. Isolate domain logic from frameworks.
2. Security: Never log sensitive data. Sanitize all inputs to prevent injection attacks.
3. Performance: Optimize database queries and avoid N+1 problems. Use pagination for large datasets.
4. Testing: Ensure high test coverage for core business logic."

inyectar_archivo "frontend/.claude/skills/frontend-component-design/SKILL.md" "\
# Generic Frontend Guidelines
1. Architecture: Use modular, reusable, and isolated components.
2. State Management: Keep global state to an absolute minimum. Favor local state where possible.
3. Typing: Strictly enforce static typing (e.g., TypeScript). Prohibit the use of 'any' or implicit types.
4. UX/UI: Ensure responsive design and accessibility (a11y) standards by default."

inyectar_archivo "infra/.claude/skills/infrastructure-as-code/SKILL.md" "\
# Generic Infrastructure Guidelines
1. Security: Zero Trust network policies. Deny all internal traffic by default.
2. Secrets Management: Never hardcode secrets. Always use a secure vault or managed secrets service.
3. Immutability: Treat infrastructure as immutable. Containerize all services with strict resource limits."

echo -e "  -> Base de conocimiento inyectada en todos los dominios."

echo -e "\n${BLUE}Paso 3: Forjando el Engram (Memoria Global del Proyecto)...${NC}"
cat << 'EOF' > engram.md
# AlastackAI - Global Engram Memory

**Project Vision:** [DEFINE TU PROYECTO AQUI - Reemplaza este texto con el objetivo principal de tu aplicacion]

**Core Directives for all Agents:**
1. Maintain strict domain isolation. Do not modify files outside your designated worktree.
2. Read the specific `/skills/` in your local `.claude` folder before writing any code.
3. Prioritize modularity, security, and clean code principles above all else.
EOF
echo "  -> engram.md creado en la raiz. (Recuerda editarlo con la vision de tu proyecto)."

echo -e "\n${BLUE}Paso 4: Desplegando Matriz 'Agents Team Lite'...${NC}"

# Agente 0: Orchestrator (Raiz)
inyectar_archivo "CLAUDE.md" "\
# ROL: AGENTE 0 (Orchestrator)
Eres el Director de Orquesta de este proyecto bajo el estandar AlastackAI.
Tu mision: Planificar la arquitectura global y coordinar a los demas agentes. No escribas codigo de implementacion directa.
Siempre lee \`engram.md\` primero para entender el contexto de negocio."

# Agente 1: Backend Implementer
inyectar_archivo "backend/CLAUDE.md" "\
# ROL: AGENTE 1 (Backend Implementer)
Eres el especialista en logica de servidor y bases de datos.
Flujo de trabajo:
1. Lee \`../engram.md\` para contexto global.
2. Genera o lee un \`PLAN.md\` antes de programar.
3. Aplica los principios de Clean Architecture definidos en tus skills locales."

# Agente 2: Frontend Implementer
inyectar_archivo "frontend/CLAUDE.md" "\
# ROL: AGENTE 2 (Frontend Implementer)
Eres el especialista en interfaces de usuario y experiencia de cliente.
Flujo de trabajo:
1. Lee \`../engram.md\` para contexto global.
2. Genera o lee un \`PLAN.md\` antes de programar.
3. Construye componentes robustos y tipados siguiendo tus skills locales."

# Agente 3: DevOps / Infra Architect
inyectar_archivo "infra/CLAUDE.md" "\
# ROL: AGENTE 3 (Infra / DevOps)
Eres el especialista en despliegues, contenedores y seguridad en la nube.
Flujo de trabajo:
1. Lee \`../engram.md\` para contexto global.
2. Diseña manifiestos (Docker, Kubernetes, Terraform) seguros y escalables.
3. Aplica politicas de Zero Trust y gestion segura de secretos."

echo "  -> Identidades de agentes asignadas a la estructura."

echo -e "\n${BLUE}Paso 5: Compilando el CLI 'GGA' (Gentleman Global Assistant)...${NC}"
mkdir -p .bin
cat << 'EOF' > .bin/gga
#!/bin/bash
# AlastackAI - Global AI CLI Wrapper
CMD=$1
shift

if [ "$CMD" == "plan" ] || [ "$CMD" == "think" ]; then
    echo "[AlastackAI] Invocando Modo Pensamiento (Arquitectura/Planificacion)..."
    claude --model claude-3-opus-20240229 "$@"
elif [ "$CMD" == "do" ] || [ "$CMD" == "code" ]; then
    echo "[AlastackAI] Invocando Modo Ejecucion (Implementacion)..."
    claude --model claude-3-5-sonnet-20241022 "$@"
else
    echo "Uso de GGA (AlastackAI):"
    echo "  gga plan [prompt] -> Inicia el modelo pensante para crear un PLAN.md."
    echo "  gga do [prompt]   -> Inicia el modelo ejecutor para escribir el codigo."
    echo "  gga               -> Abre la terminal interactiva de Claude Code."
    claude "$@"
fi
EOF
chmod +x .bin/gga
echo "  -> CLI 'gga' configurado."

echo -e "\n${BLUE}Paso 6: Activacion del Entorno AlastackAI${NC}"
echo -e "${YELLOW}Ejecuta este comando para activar tu CLI en esta terminal:${NC}"
echo -e "${GREEN}export PATH=\"\$PWD/.bin:\$PATH\"${NC}\n"
echo -e "${GREEN}El ecosistema AlastackAI esta listo. Modifica engram.md con los detalles de tu nuevo proyecto y a construir.${NC}"
