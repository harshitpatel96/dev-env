#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$HOME/.zsh/plugins"

PLUGINS=(
  "fzf-tab https://github.com/Aloxaf/fzf-tab"
  "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-bat https://github.com/fdellwing/zsh-bat.git"
  "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git"
)

# --- Plugins ---
mkdir -p "$PLUGIN_DIR"

for entry in "${PLUGINS[@]}"; do
  name="${entry%% *}"
  url="${entry#* }"
  dest="$PLUGIN_DIR/$name"
  if [ -d "$dest" ]; then
    echo "[skip] $name already exists"
  else
    echo "[clone] $name"
    git clone "$url" "$dest"
  fi
done

# --- Starship ---
if command -v starship &>/dev/null; then
  echo "[skip] starship already installed"
else
  echo "[install] starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# --- Herdr ---
if command -v herdr &>/dev/null; then
  echo "[skip] herdr already installed"
else
  echo "[install] herdr"
  brew install herdr
fi

# --- .zshrc ---
ZSHRC="$HOME/.zshrc"

read -r -d '' ZSHRC_CONTENT << 'EOF' || true
### zsh-syntax-highlighting plugin
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### zsh-you-should-use plugin
source ~/.zsh/plugins/zsh-you-should-use/zsh-you-should-use.plugin.zsh

### fzf-tab plugin
autoload -U compinit; compinit
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

### zsh-autosuggestions plugin
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

### zsh-bat plugin
source ~/.zsh/plugins/zsh-bat/zsh-bat.plugin.zsh

export PATH=$HOME/.toolbox/bin:$PATH

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

### Keep at the end
eval "$(starship init zsh)"
EOF

if [ ! -f "$ZSHRC" ] || [ ! -s "$ZSHRC" ]; then
  echo "[create] ~/.zshrc"
  printf '%s\n' "$ZSHRC_CONTENT" > "$ZSHRC"
else
  echo ""
  echo "~/.zshrc already exists and is non-empty."
  echo "Please add the following to your ~/.zshrc manually:"
  echo ""
  echo "---"
  printf '%s\n' "$ZSHRC_CONTENT"
  echo "---"
fi

echo ""
echo "Done."
