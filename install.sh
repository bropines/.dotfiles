#!/bin/bash

# --- Dotfiles Installer ---
# Sets up Zsh configuration and ensures dependencies are installed.

set -e

# --- OS Detection & Package Manager Helper ---
install_packages() {
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y "$@"
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm "$@"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y "$@"
    else
        echo "❌ Unsupported package manager. Please install: $* manually."
        exit 1
    fi
}

# --- Self-Bootstrap Logic ---
# If script is run directly (e.g. via curl), clone the full repo first.
TARGET_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/bropines/.dotfiles.git"

if [ "$(basename "$0")" == "bash" ] || [ ! -f "$TARGET_DIR/install.sh" ]; then
    echo "🚀 Bootstrapping Dotfiles from $REPO_URL..."
    
    # Ensure git is present for cloning
    if ! command -v git &> /dev/null; then
        install_packages git
    fi

    if [ ! -d "$TARGET_DIR" ]; then
        git clone "$REPO_URL" "$TARGET_DIR"
    else
        echo "📂 Target directory already exists, skipping clone."
    fi
    
    # Execute the installer from the cloned directory
    exec "$TARGET_DIR/install.sh" "$@"
fi

DOTFILES_DIR="$TARGET_DIR"
ZSH_CUSTOM="${ZSH_CUSTOM:-$DOTFILES_DIR/zsh/.oh-my-zsh/custom}"

HEAVY_MODE=false
ANDROID_MODE=false
# Parse flags
for arg in "$@"; do
    case $arg in
        --heavy|-h)
        HEAVY_MODE=true
        shift
        ;;
        --android|-a)
        ANDROID_MODE=true
        shift
        ;;
    esac
done

echo "🦔 Setting up your Hedgehog Dotfiles..."

# 1. Ensure core dependencies are installed
echo "📦 Checking core dependencies..."
# Check for each command and build install list
TO_INSTALL=()
for cmd in zsh fzf curl git unzip; do
    if ! command -v "$cmd" &> /dev/null; then
        TO_INSTALL+=("$cmd")
    fi
done

if [ ${#TO_INSTALL[@]} -ne 0 ]; then
    install_packages "${TO_INSTALL[@]}"
fi

# 2. Oh My Zsh
if [ ! -d "$DOTFILES_DIR/zsh/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    export ZSH="$DOTFILES_DIR/zsh/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Clean up default .zshrc created by OMZ installer in HOME
    rm -f "$HOME/.zshrc" "$HOME/.zshrc.pre-oh-my-zsh"
fi

# 3. Powerlevel10k
ZSH_CUSTOM="$DOTFILES_DIR/zsh/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# 4. Plugins
echo "🔌 Ensuring plugins are installed..."
mkdir -p "$ZSH_CUSTOM/plugins"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ] && git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"

# 5. Programming Languages & Tools
# Go Installation
if ! command -v go &> /dev/null; then
    echo "🐹 Installing Go..."
    GO_VERSION="1.22.2"
    curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
fi

# Pyenv (Useful everywhere)
if [ ! -d "$HOME/.pyenv" ]; then
    echo "🐍 Installing Pyenv..."
    curl https://pyenv.run | bash
fi

# Android SDK (Optional)
if [ "$ANDROID_MODE" = true ]; then
    echo "🤖 Installing Android SDK Command-line tools..."
    # Dependencies: Java is required for Android tools
    if ! command -v java &> /dev/null; then
        echo "⚠️ Java not found. Installing Java..."
        if command -v apt-get &> /dev/null; then
            install_packages default-jdk
        elif command -v pacman &> /dev/null; then
            install_packages jdk-openjdk
        elif command -v dnf &> /dev/null; then
            install_packages java-latest-openjdk-devel
        fi
    fi
    
    ANDROID_HOME="/opt/android-sdk"
    if [ ! -d "$ANDROID_HOME" ]; then
        sudo mkdir -p "$ANDROID_HOME"
        echo "⬇️ Downloading Android Command-line tools..."
        curl -LO "https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip"
        sudo unzip -q "commandlinetools-linux-14742923_latest.zip" -d "$ANDROID_HOME"
        rm "commandlinetools-linux-14742923_latest.zip"
        
        # Google's special requirement: Move contents into cmdline-tools/latest/
        sudo mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
        # We need to move everything from the extracted 'cmdline-tools' folder into 'cmdline-tools/latest'
        # To avoid moving the 'latest' folder into itself, we move files one by one or via temp
        sudo mv "$ANDROID_HOME/cmdline-tools/bin" "$ANDROID_HOME/cmdline-tools/latest/"
        sudo mv "$ANDROID_HOME/cmdline-tools/lib" "$ANDROID_HOME/cmdline-tools/latest/"
        sudo mv "$ANDROID_HOME/cmdline-tools/source.properties" "$ANDROID_HOME/cmdline-tools/latest/"
        sudo mv "$ANDROID_HOME/cmdline-tools/NOTICE.txt" "$ANDROID_HOME/cmdline-tools/latest/"
        
        # Ensure current user has permissions
        sudo chown -R "$USER:$USER" "$ANDROID_HOME"
        echo "✅ Android SDK tools installed to $ANDROID_HOME"
        echo "📝 Don't forget to accept licenses later: sdkmanager --licenses"
    else
        echo "📂 Android SDK directory already exists, skipping download."
    fi
fi

# 6. Heavy Mode Tools (Optional)
LOCAL_RC="$DOTFILES_DIR/zsh/.zshrc.local"
if [ "$HEAVY_MODE" = true ]; then
    echo "🐘 Heavy Mode: Installing additional tools..."
    # SDKMAN
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "☕ Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
    fi
    # Ensure heavy tools are NOT skipped
    echo "export DOTFILES_SKIP_HEAVY=false" > "$LOCAL_RC"
else
    echo "☁️ Server Mode: Skipping SDKMAN and heavy init..."
    echo "export DOTFILES_SKIP_HEAVY=true" > "$LOCAL_RC"
fi

# 6. Setup .zshenv to point ZDOTDIR to dotfiles
echo "🔗 Linking Zsh configuration..."
ZSHENV="$HOME/.zshenv"
ZSHENV_CONTENT="export ZDOTDIR=\$HOME/.dotfiles/zsh"

if [ ! -f "$ZSHENV" ]; then
    echo "$ZSHENV_CONTENT" > "$ZSHENV"
elif ! grep -q "ZDOTDIR" "$ZSHENV"; then
    echo -e "\n$ZSHENV_CONTENT" >> "$ZSHENV"
else
    # Update existing line
    sed -i "s|export ZDOTDIR=.*|$ZSHENV_CONTENT|" "$ZSHENV"
fi

echo "✨ Done! Restart your terminal or run 'zsh' to enjoy your new setup."
if [ "$HEAVY_MODE" = false ]; then
    echo "💡 Note: If you want heavy dev tools (Pyenv, SDKMAN), run with: ./install.sh --heavy"
fi
