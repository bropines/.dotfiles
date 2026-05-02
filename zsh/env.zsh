# --- Path & Tooling ---

# Helper to add to PATH only if directory exists
path_add() {
    [ -d "$1" ] && export PATH="$1:$PATH"
}

# Go
[ -d "/usr/local/go" ] && export GOROOT=/usr/local/go
export GOPATH=$HOME/go
path_add "$GOROOT/bin"
path_add "$GOPATH/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh" --no-use
fi

# FNM
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env)"
fi

# Skip heavy tools if explicitly requested (e.g. on lightweight servers)
if [[ "$DOTFILES_SKIP_HEAVY" != "true" ]]; then

    # Pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    if [ -d "$PYENV_ROOT/bin" ]; then
        export PATH="$PYENV_ROOT/bin:$PATH"
        if command -v pyenv &>/dev/null; then
            eval "$(pyenv init -)"
        fi
    fi

    # SDKMAN
    export SDKMAN_DIR="$HOME/.sdkman"
    if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi

fi

# Bun
export BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL" ]; then
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Android SDK
export ANDROID_HOME="/opt/android-sdk"
path_add "$ANDROID_HOME/cmdline-tools/latest/bin"
path_add "$ANDROID_HOME/platform-tools"
path_add "$ANDROID_HOME/emulator"
path_add "$ANDROID_HOME/tools/bin"

# Local bin
path_add "$HOME/.local/bin"

# Editor
if command -v micro &>/dev/null; then
    export EDITOR='micro'
else
    export EDITOR='nano'
fi
