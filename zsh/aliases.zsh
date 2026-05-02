# --- Aliases & Functions ---

# Navigation
function lcd() { cd "$1" && ls }

# Common aliases
alias ll='ls -lah'
alias gs='git status'
alias gclean='rm -rf ~/.gradle/caches && rm -rf ~/.cache/go-build'

# Config editing
alias zconfig="micro $ZDOTDIR/.zshrc"
alias dotconfig="cd ~/.dotfiles"

# FZF key bindings
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
