#!/usr/bin/env bash
# GUAN Framework Setup Script
# One-command setup on a new machine
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"
CODES_DIR="$HOME_DIR/Codes"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "${RED}[FAIL]${NC} $1"; }

echo "╔══════════════════════════════════════╗"
echo "║   GUAN Framework Setup v1.3          ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ============================================================
# Step 1: Check prerequisites
# ============================================================
info "Step 1: Checking prerequisites..."

check_cmd() {
    if command -v "$1" &>/dev/null; then
        ok "$1 found: $(command -v "$1")"
        return 0
    else
        return 1
    fi
}

# Node.js
if ! check_cmd node; then
    warn "Node.js not found. Installing via brew..."
    if check_cmd brew; then
        brew install node@22
    else
        fail "Neither node nor brew found. Install Node.js first: https://nodejs.org"
        exit 1
    fi
fi

# npm
check_cmd npm || { fail "npm not found"; exit 1; }

# ============================================================
# Step 2: Install CLI tools
# ============================================================
info "Step 2: Installing CLI tools..."

install_npm_global() {
    local pkg="$1"
    local cmd="$2"
    if command -v "$cmd" &>/dev/null; then
        ok "$cmd already installed: $($cmd --version 2>/dev/null || echo 'version unknown')"
    else
        info "Installing $pkg..."
        npm install -g "$pkg"
        ok "$cmd installed"
    fi
}

install_npm_global "@anthropic-ai/claude-code" "claude"
install_npm_global "@openai/codex" "codex"

# Gemini CLI (npm or brew)
if command -v gemini &>/dev/null; then
    ok "gemini already installed: $(gemini --version 2>/dev/null || echo 'version unknown')"
else
    info "Installing Gemini CLI..."
    npm install -g @anthropic-ai/gemini-cli 2>/dev/null || \
    npm install -g @google/gemini-cli 2>/dev/null || \
    { warn "npm install failed, trying brew..."; brew install gemini-cli 2>/dev/null; } || \
    warn "Gemini CLI install failed. Install manually."
fi

# ============================================================
# Step 3: Setup persona directory
# ============================================================
info "Step 3: Setting up persona directory..."

PERSONA_DIR="$HOME_DIR/persona"
if [ -d "$PERSONA_DIR/core" ]; then
    warn "Persona directory already exists at $PERSONA_DIR, skipping"
else
    info "Copying persona to $PERSONA_DIR..."
    mkdir -p "$PERSONA_DIR"
    cp -a "$SCRIPT_DIR/persona/"* "$SCRIPT_DIR/persona/".* "$PERSONA_DIR/" 2>/dev/null || \
    cp -a "$SCRIPT_DIR/persona/"* "$PERSONA_DIR/"
    # Initialize git
    cd "$PERSONA_DIR"
    git init
    git add -A
    git commit -m "Initial persona import from GUAN setup"
    cd "$SCRIPT_DIR"
    ok "Persona directory initialized at $PERSONA_DIR"
fi

# ============================================================
# Step 4: Clone GUAN Framework repo
# ============================================================
info "Step 4: Setting up GUAN Framework..."

mkdir -p "$CODES_DIR"
GUAN_DIR="$CODES_DIR/GUAN-Framework"
if [ -d "$GUAN_DIR/.git" ]; then
    warn "GUAN-Framework already exists at $GUAN_DIR, pulling latest..."
    git -C "$GUAN_DIR" pull --ff-only 2>/dev/null || warn "Pull failed, using existing"
else
    info "Cloning GUAN-Framework..."
    git clone https://github.com/whoisguan/GUAN-Framework "$GUAN_DIR"
    ok "GUAN-Framework cloned"
fi

# ============================================================
# Step 5: Configure Claude Code
# ============================================================
info "Step 5: Configuring Claude Code..."

CLAUDE_DIR="$HOME_DIR/.claude"
mkdir -p "$CLAUDE_DIR/plugins" "$CLAUDE_DIR/rules"

# settings.json
cp "$SCRIPT_DIR/configs/claude/settings.json" "$CLAUDE_DIR/settings.json"
ok "Claude settings.json installed"

# settings.local.json
cp "$SCRIPT_DIR/configs/claude/settings.local.json" "$CLAUDE_DIR/settings.local.json"
ok "Claude settings.local.json installed"

# Plugins metadata
cp "$SCRIPT_DIR/configs/claude-plugins/blocklist.json" "$CLAUDE_DIR/plugins/blocklist.json"
cp "$SCRIPT_DIR/configs/claude-plugins/known_marketplaces.json" "$CLAUDE_DIR/plugins/known_marketplaces.json"
# Fix installLocation path in known_marketplaces.json
sed -i.bak "s|/Users/cc/|$HOME_DIR/|g" "$CLAUDE_DIR/plugins/known_marketplaces.json"
rm -f "$CLAUDE_DIR/plugins/known_marketplaces.json.bak"
ok "Claude plugins metadata installed"

# Symlink rules from persona (so persona repo stays the single source of truth)
if [ -d "$PERSONA_DIR/.claude/rules" ]; then
    for rule in "$PERSONA_DIR/.claude/rules"/*.md; do
        [ -f "$rule" ] || continue
        fname="$(basename "$rule")"
        ln -sf "$rule" "$CLAUDE_DIR/rules/$fname"
    done
    ok "Claude rules symlinked from persona"
fi

# Symlink commands from persona
if [ -d "$PERSONA_DIR/.claude/commands" ]; then
    mkdir -p "$CLAUDE_DIR/commands"
    for cmd in "$PERSONA_DIR/.claude/commands"/*.md; do
        [ -f "$cmd" ] || continue
        fname="$(basename "$cmd")"
        ln -sf "$cmd" "$CLAUDE_DIR/commands/$fname"
    done
    ok "Claude commands symlinked from persona"
fi

# ============================================================
# Step 6: Configure Codex
# ============================================================
info "Step 6: Configuring Codex..."

CODEX_DIR="$HOME_DIR/.codex"
mkdir -p "$CODEX_DIR"

# config.toml — replace old home path with current
sed "s|/Users/cc|$HOME_DIR|g" "$SCRIPT_DIR/configs/codex/config.toml" > "$CODEX_DIR/config.toml"
ok "Codex config.toml installed (paths updated)"

# ============================================================
# Step 7: Configure Gemini
# ============================================================
info "Step 7: Configuring Gemini..."

GEMINI_DIR="$HOME_DIR/.gemini"
mkdir -p "$GEMINI_DIR"

cp "$SCRIPT_DIR/configs/gemini/settings.json" "$GEMINI_DIR/settings.json"
ok "Gemini settings.json installed"

# ============================================================
# Step 8: Authentication reminders
# ============================================================
echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Setup Complete!                    ║"
echo "╚══════════════════════════════════════╝"
echo ""
info "Installed components:"
echo "  ~/persona/                  — Persona cognitive library"
echo "  ~/Codes/GUAN-Framework/    — Framework source"
echo "  ~/.claude/                  — Claude Code config + rules"
echo "  ~/.codex/                   — Codex config"
echo "  ~/.gemini/                  — Gemini config"
echo ""
warn "Authentication required (run these manually):"
echo "  1. claude   — First run will prompt for Anthropic auth"
echo "  2. codex    — First run will prompt for OpenAI auth"
echo "  3. gemini   — First run will prompt for Google OAuth"
echo ""
info "Verification: cd into any project and run 'claude' then type /boot"
echo ""
ok "GUAN Framework v1.3 ready."
