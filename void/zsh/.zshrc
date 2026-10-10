# The shell configuration has the following dependencies:
# bat, batman, duf, dust, fastfetch, fd, fzf, git, lsd, procs, starship, topgrade.
# vivid, zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting and zoxide.
# Removing any of these dependencies can cause problems.

# 1. Remove all predefined aliases.

unalias -a

# 2. Define command replacements.

cat()  { bat "$@" 2>/dev/null || command cat "$@"; }
cd()   { z "$@" 2>/dev/null || command cd "$@"; }
df()   { duf "$@" 2>/dev/null || command df --human-readable "$@"; }
du()   { dust "$@" 2>/dev/null || command du --human-readable --summarize "$@"; }
man()  { batman "$@" 2>/dev/null || command man "$@"; }
ps()   { procs "$@" 2>/dev/null || command ps axu "$@"; }

# 3. Plugins.

# The fzf plugin must load before fzf-tab.

source <(fzf --zsh)

# 4. Completions.

# compinit must load before fzf-tab.

autoload -Uz compinit && compinit -C

# Automatically load bash completion functions.

autoload -U +X bashcompinit && bashcompinit

# 5. Continue plugins.

# Use fzf-tab. Must load after compinit but before autosuggestions and
# syntax-highlighting.

source "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.zsh"

# Use autosuggestions. Must load after fzf-tab.

source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Use syntax highlighting.

source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# 6. Follow the XDG base dir specification.

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# 7. Default programs.

export VISUAL="nano"
export EDITOR="nano"

# 8. Mixed exports.

# Fzf.

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/fzfrc"

# Less.

export PAGER='less -RFX'

# LS_COLORS (cached to avoid launching vivid on every shell startup).

_ls_colors_cache="$XDG_CACHE_HOME/zsh/vivid-catppuccin-mocha.txt"
if [[ ! -f $_ls_colors_cache || $(command -v vivid) -nt $_ls_colors_cache ]]; then
    mkdir -p "$XDG_CACHE_HOME/zsh"
    vivid generate catppuccin-mocha > $_ls_colors_cache
fi
export LS_COLORS="$(< $_ls_colors_cache)"
unset _ls_colors_cache

# Starship.

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"

# 9. Path.

showpath() {  # display the path variable (renamed from 'path' to avoid shadowing ZSH's path array)
    print "\e[1mList of global path.\e[0m"
    print "${PATH}" | tr ':' '\n' | bat -n --paging=never --theme="Catppuccin Mocha"
}

# Set PATH so it includes the user's private bin if it exists.

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Ensure path arrays do not contain duplicates.

typeset -gU CDPATH FPATH MAILPATH PATH MANPATH

# 10. Aliases

alias a='alias | fzf'
alias add='sudo xbps-install -S'
alias bottom='btm'
alias clean='sudo xbps-remove -O'
alias clone='git clone --depth 1 --recurse-submodules'
alias co='cd ~/.config'
alias coz='cd ~/.config/zsh'
alias cpi='cp -i'
alias del='sudo xbps-remove -R'
alias down='sudo sv down'
alias e='env | fzf'
alias ez='$EDITOR ~/.config/zsh/.zshrc'
alias fonts='cd /usr/share/fonts'
alias ft='fc-cache -f -v'
alias h='history | fzf'
alias hfonts='cd $HOME/.fonts'
alias hicons='cd $HOME/.icons'
alias hold='sudo xbps-pkgdb -m hold'
alias home='cd ~'
alias icons='cd /usr/share/icons'
alias installed='xbps-query -m'
alias list-held='xbps-query -H'
alias lll='duf -only local'
alias lo='cd ~/.local'
alias los='cd ~/.local/share'
alias ls='lsd --long --all --git'
alias lsfonts='cd $HOME/.local/share/fonts'
alias lsicons='cd $HOME/.local/share/icons'
alias lsthemes='cd $HOME/.local/share/themes'
alias m='sudo mount | column -t'
alias md='mkdir -pv'
alias mvi='mv -i'
alias n='nano'
alias o='xdg-open'
alias orphans='xbps-query --list-orphans'
alias ra='sudo xbps-reconfigure -fa'
alias reconf='sudo xbps-reconfigure -f'
alias restart='sudo sv restart'
alias rl='exec $SHELL -l'
alias rmi='rm -i'
alias ro='sudo xbps-remove --remove-orphans'
alias search='xbps-query -Rs'
alias services='sudo sv status /var/service/*'
alias sf='fc-list : family spacing | /bin/grep -i'
alias sn='sudo nano'
alias start='sudo sv start'
alias status='sudo sv status'
alias stop='sudo sv stop'
alias t='topgrade'
alias themes='cd /usr/share/themes'
alias unblock='sudo rfkill unblock all'
alias unhold='sudo xbps-pkgdb -m unhold'
alias update='sudo xbps-install -Su'
alias userlist='cut -d: -f1 /etc/passwd'
alias wi='wezterm imgcat'
alias wk='wezterm show-keys --lua'

# 11. Setopt/unsetopt.

## Changing directories.

setopt autocd
setopt autopushd
setopt chasedots
setopt chaselinks
setopt pushdignoredups
setopt pushdsilent
setopt pushdtohome

## Completion, expansion, and globbing.

setopt autolist
setopt autoremoveslash
setopt braceccl
setopt extendedglob
setopt globdots
setopt listpacked
setopt markdirs
setopt menucomplete
setopt nomatch
setopt numericglobsort
setopt rc_quotes
setopt rec_exact

## History.

setopt histexpiredupsfirst
setopt histignorealldups
setopt histignorespace
setopt histnostore
setopt histreduceblanks
setopt histverify
setopt sharehistory

HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$ZDOTDIR/.zsh_history"

## Input/Output.

setopt correct
setopt interactivecomments
setopt promptsubst

## Scripts and functions.

setopt multios

## Unset.

unsetopt beep
unsetopt bgnice
unsetopt checkjobs
unsetopt clobber
unsetopt hup
unsetopt rmstar_silent

## Zle.

setopt combiningchars

# 12. Final.

# Suggest installation of xbps packages in interactive shell sessions.

source /usr/share/zsh/plugins/xbps-command-not-found/xbps-command-not-found.zsh

fastfetch

# Cache starship and zoxide init scripts for faster startup.

#_cache_eval() {
#    local cache="$XDG_CACHE_HOME/zsh/${1}.zsh"
#    mkdir -p "$XDG_CACHE_HOME/zsh"
#    [[ ! -f $cache || $commands[$1] -nt $cache ]] && "$@" > $cache
#    source $cache
#}

#_cache_eval starship init zsh
#_cache_eval zoxide init zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
