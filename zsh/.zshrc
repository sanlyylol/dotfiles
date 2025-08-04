# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/szymon/.zshrc'
# compinstall no more

# export COLORTERM="truecolor"
# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
source "/etc/grc.zsh"

zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "Aloxaf/fzf-tab"
zinit light "jeffreytse/zsh-vi-mode"
ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
ZVM_VI_HIGHLIGHT_FOREGROUND=gray              # color name
ZVM_VI_HIGHLIGHT_FOREGROUND=#838783           # hex value
ZVM_VI_HIGHLIGHT_BACKGROUND=black             # color name
ZVM_VI_HIGHLIGHT_BACKGROUND=#131413           # hex value
ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold #,underline    # bold and underline

# load
autoload -Uz compinit && compinit
zinit cdreplay -q
autoload -U colors && colors
autoload -Uz vcs_info
autoload -U promptinit && promptinit

function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      VIMODE="N"
    ;;
    $ZVM_MODE_INSERT)
      VIMODE="I"
    ;;
    $ZVM_MODE_VISUAL)
      VIMODE="V"
    ;;
    $ZVM_MODE_VISUAL_LINE)
      VIMODE="L"
    ;;
    $ZVM_MODE_REPLACE)
      VIMODE="R"
    ;;
  esac
  PS1="%B%F{062}$VIMODE%b%f %B%F{51}%~ 🡪%b%f "
}

# aliases
alias ls='exa --icons --group-directories-first --color=always'
alias grep='rg --color=auto'
alias cat='bat --theme=base16 --paging=never'
alias find='fd'

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# starship, fzf, z
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# PS1="I %~ > "
# Configure prompt
setopt PROMPT_SUBST
PROMPT='%B%F{208}𝓲%b%f %B%F{51}%~ 🡪%b%f '

# PATHS
export PATH="/home/szymon/.cargo/bin:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# End of lines added by compinstall
