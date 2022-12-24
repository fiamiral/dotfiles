# PATH
typeset -U path PATH
path+=("${HOME}/.local/bin" "${CARGO_HOME}/bin")

# --------------------------------
# keybind
# --------------------------------
bindkey -v # set to vi mode
KEYTIMEOUT=1 # remove wait when press escape

# zsh-vi-mode
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}

# --------------------------------
# Completion
# --------------------------------
# Load completion
autoload -U compinit
compinit

# fzf-tab
# minimum size of completion window
zstyle ':fzf-tab:*' popup-pad 60 20
# completion with fzf and tmux popup
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# set default keybind
zstyle 'fzf-tab:complete:*' fzf-bindings \
    'backward-eof:abort'
# preview directory when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview ' \
    exa -alFT --no-permissions --no-filesize --no-user --no-time --git \
    --level=2 --ignore-glob=".git" --color=always $realpath'


# --------------------------------
# Appearance
# --------------------------------
# LS_COLORS
export LS_COLORS="$(vivid generate nord)"

# Starship
eval "$(starship init zsh)"


# --------------------------------
# History
# --------------------------------
if [ ! -d "${XDG_DATA_HOME}/zsh" ]; then
    mkdir -p "${XDG_DATA_HOME}/zsh"
fi
HISTFILE="${XDG_DATA_HOME}/zsh/history" # XDG spec
HISTSIZE=1000000
SAVEHIST=10000000

setopt extended_history # Record a timestamp and duration
setopt hist_ignore_all_dups # Remove the same command from history
setopt hist_ignore_dups # Don't record consecutive same command
setopt hist_ignore_space # Don't record commands that begin with a space
setopt hist_reduce_blanks # Remove superfluous spaces
setopt share_history # Share history between terminals


# --------------------------------
# Alias & Abbr
# --------------------------------
# zabrze
eval "$(zabrze init --bind-keys)"

# ls
alias ll='exa -alF --time-style=long-iso --git'
alias lt='exa -alFT --no-permissions --no-filesize --no-user --no-time --git --level=2 --ignore-glob=".git"'

# cat
alias cat=bat

# editor
alias edit="${VISUAL}"


# --------------------------------
# Autostart
# --------------------------------

# Load plugins
eval "$(sheldon source)"

# tmux
if [[ ! -n $TMUX ]]; then
    if ! tmux has-session -t main 2>/dev/null; then
        tmux new-session -d -s main -c "${HOME}"
    fi
    tmux attach-session -t main
fi
