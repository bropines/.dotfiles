# --- Zsh Options ---

# History
HISTFILE="$ZDOTDIR/.zhistory"
SAVEHIST=10000
HISTSIZE=10000

setopt extended_history       # Add timestamps to history
setopt share_history          # Share history between sessions
setopt append_history         # Append to history file
setopt inc_append_history     # Immediately append to history
setopt hist_ignore_all_dups   # Don't record dups in history
setopt hist_reduce_blanks     # Remove extra blanks from commands
setopt hist_no_store          # Don't store history commands
setopt interactive_comments   # Allow comments in interactive shell

# Directory Navigation
setopt AUTO_CD                # If command is a directory, cd into it
DIRSTACKSIZE=20

# Notifications
setopt NOTIFY                 # Notify of background job status changes

# Misc
setopt BRACECCL               # Expansion of {a-d} to a b c d

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' insert-tab false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'

# URL Magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
