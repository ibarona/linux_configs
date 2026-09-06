# ==============================================================================
# CONFIGURACIÓN BÁSICA Y HISTORIAL
# ==============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Opciones de historial
setopt SHARE_HISTORY          # Comparte el historial entre diferentes terminales abiertas
setopt HIST_IGNORE_DUPS       # No grabe comandos duplicados seguidos
setopt HIST_IGNORE_ALL_DUPS   # Elimina duplicados previos
setopt HIST_IGNORE_SPACE      # Ignora comandos que empiecen por espacio
setopt HIST_SAVE_NO_DUPS      # No guarda duplicados en el archivo

# Opciones de navegación
setopt AUTO_CD                # Escribir la ruta de una carpeta te mueve a ella directamente
setopt INTERACTIVE_COMMENTS   # Permite comentarios con '#' en la shell interactiva

# ==============================================================================
# SISTEMA DE AUTOCOMPLETADO (zsh-completions incluido)
# ==============================================================================
autoload -U compinit && compinit -C

# Estilo para el menú de autocompletado con tabulador
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Búsqueda case-insensitive
#zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Colores tipo 'ls' en las sugerencias

# ==============================================================================
# ATTACH DE PLUGINS PACKAGED POR VOID LINUX
# ==============================================================================
# Rutas estándar en Void Linux para los plugins instalados vía XBPS

# 1. zsh-autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 2. zsh-syntax-highlighting (DEBE cargarse al final de las utilidades)
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[command]='fg=3'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=3'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=3'
    ZSH_HIGHLIGHT_STYLES[function]='fg=3'
fi

# 3. zsh-history-substring-search
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    # Vincular las flechas arriba/abajo para buscar en el historial por lo escrito
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

# ==============================================================================
# REEMPLAZOS DE PLUGINS DE OH-MY-ZSH (Sudo, Git, FZF)
# ==============================================================================

# -- Plugin "sudo" (Pulsar ESC 2 veces para poner/quitar 'sudo' al comando actual) --
sudo-command-line() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# -- Soporte para FZF (si está instalado el paquete 'fzf') --
if command -v fzf &>/dev/null; then
    # Habilitar atajos Ctrl+R (historial) y Alt+C (carpetas)
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null
    source /usr/share/fzf/completion.zsh 2>/dev/null
fi

# -- Aliases estilo Git (versiones ligeras del plugin de git) --
if command -v git &>/dev/null; then
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit -m'
    alias gp='git push'
    alias gl='git pull'
    alias gd='git diff'
    alias gb='git branch'
fi

# ==============================================================================
# PROMPT: STARSHIP
# ==============================================================================
#if command -v starship &>/dev/null; then
#    eval "$(starship init zsh)"
#fi

# ==============================================================================
# CONFIGURACIÓN DEL PROMPT NATIVO USANDO LOS COLORES DE KITTY
# ==============================================================================

# 1. Cargar módulo interno de Zsh para control de versiones
autoload -Uz vcs_info
autoload -Uz colors && colors

# Activar comprobación de Git antes de dibujar cada línea de prompt
precmd() { vcs_info }

# Habilitar la expansión de variables y colores en el prompt
setopt PROMPT_SUBST

# 2. Configurar el formato de Git usando los colores de Kitty:
# - %F{magenta} / %F{5}: Color magenta de Kitty para la rama
# - %F{yellow} / %F{3}: Color amarillo de Kitty para avisar si hay cambios sin guardar
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{3}●%f'   # Muestra un punto amarillo si hay cambios sin hacer commit
zstyle ':vcs_info:git:*' stagedstr ' %F{2}●%f'     # Muestra un punto verde si hay cambios preparados (staged)
zstyle ':vcs_info:git:*' formats ' %F{8}on%f %F{5}🌱 %b%c%u%f'

# 3. Definir la estructura del prompt:
# - %F{6}%~%f : Directorio actual usando el color cian de Kitty (o %F{cyan})
# - ${vcs_info_msg_0_} : Cadena formateada de Git (solo aparece si es un repo Git)
# - %# : Muestra '$' para usuario normal o '#' para root
#PROMPT='%F{6}%~%f${vcs_info_msg_0_} %# '
#PROMPT='[%F{2}%n%f@%F{4}%m%f %F{6}%~%f]${vcs_info_msg_0_}%# '

PROMPT='[%n%f@%m%f %~%f]${vcs_info_msg_0_}%# '

