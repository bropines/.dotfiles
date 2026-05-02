# --- Main Zsh Config ---

# Load prompt (includes p10k instant prompt)
source "$ZDOTDIR/prompt.zsh"

# Load environment variables
source "$ZDOTDIR/env.zsh"

# Load shell options
source "$ZDOTDIR/options.zsh"

# Load plugins (includes Oh My Zsh)
source "$ZDOTDIR/plugins.zsh"

# Load aliases
source "$ZDOTDIR/aliases.zsh"

# Load machine-specific config if it exists
[[ ! -f "$ZDOTDIR/.zshrc.local" ]] || source "$ZDOTDIR/.zshrc.local"
