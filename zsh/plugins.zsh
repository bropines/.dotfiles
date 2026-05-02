# --- Plugins & Oh My Zsh ---

# Path to Oh My Zsh
# We'll use the existing one for now, but modularized
export ZSH="$ZDOTDIR/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  sudo
  extract
  cp
  command-not-found
  web-search
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  fzf-tab
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
