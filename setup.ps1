# GUAN Framework Setup Script (Windows PowerShell)
# Usage: git clone https://github.com/cvidkal/guan-setup.git; cd guan-setup; .\setup.ps1
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$HomeDir = $env:USERPROFILE
$CodesDir = Join-Path $HomeDir "Codes"

function Info  { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Ok    { param($msg) Write-Host "[OK]   $msg" -ForegroundColor Green }
function Warn  { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Fail  { param($msg) Write-Host "[FAIL] $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "======================================"
Write-Host "   GUAN Framework Setup v1.3 (Win)    "
Write-Host "======================================"
Write-Host ""

# ============================================================
# Step 1: Check prerequisites
# ============================================================
Info "Step 1: Checking prerequisites..."

function Test-Command { param($cmd) return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

if (Test-Command "node") {
    Ok "node found: $(node --version)"
} else {
    Warn "Node.js not found. Trying winget..."
    if (Test-Command "winget") {
        winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
    } else {
        Fail "Node.js not found. Install from https://nodejs.org"
        exit 1
    }
}

if (-not (Test-Command "npm")) { Fail "npm not found"; exit 1 }
if (-not (Test-Command "git")) { Fail "git not found. Install from https://git-scm.com"; exit 1 }

# ============================================================
# Step 2: Install CLI tools
# ============================================================
Info "Step 2: Installing CLI tools..."

function Install-NpmGlobal { param($pkg, $cmd)
    if (Test-Command $cmd) {
        $ver = & $cmd --version 2>$null
        Ok "$cmd already installed: $ver"
    } else {
        Info "Installing $pkg..."
        npm install -g $pkg
        Ok "$cmd installed"
    }
}

Install-NpmGlobal "@anthropic-ai/claude-code" "claude"
Install-NpmGlobal "@openai/codex" "codex"

if (Test-Command "gemini") {
    Ok "gemini already installed: $(gemini --version 2>$null)"
} else {
    Info "Installing Gemini CLI..."
    try { npm install -g @google/gemini-cli } catch { Warn "Gemini CLI install failed. Install manually." }
}

# ============================================================
# Step 3: Setup persona directory
# ============================================================
Info "Step 3: Setting up persona directory..."

$PersonaDir = Join-Path $HomeDir "persona"
if (Test-Path (Join-Path $PersonaDir "core")) {
    Warn "Persona directory already exists at $PersonaDir, skipping"
} else {
    Info "Copying persona to $PersonaDir..."
    Copy-Item -Path (Join-Path $ScriptDir "persona") -Destination $PersonaDir -Recurse -Force
    Push-Location $PersonaDir
    git init
    git add -A
    git commit -m "Initial persona import from GUAN setup"
    Pop-Location
    Ok "Persona directory initialized at $PersonaDir"
}

# ============================================================
# Step 4: Clone GUAN Framework repo
# ============================================================
Info "Step 4: Setting up GUAN Framework..."

if (-not (Test-Path $CodesDir)) { New-Item -ItemType Directory -Path $CodesDir | Out-Null }
$GuanDir = Join-Path $CodesDir "GUAN-Framework"
if (Test-Path (Join-Path $GuanDir ".git")) {
    Warn "GUAN-Framework already exists, pulling latest..."
    try { git -C $GuanDir pull --ff-only } catch { Warn "Pull failed, using existing" }
} else {
    Info "Cloning GUAN-Framework..."
    git clone https://github.com/whoisguan/GUAN-Framework $GuanDir
    Ok "GUAN-Framework cloned"
}

# ============================================================
# Step 5: Configure Claude Code
# ============================================================
Info "Step 5: Configuring Claude Code..."

$ClaudeDir = Join-Path $HomeDir ".claude"
$ClaudeRulesDir = Join-Path $ClaudeDir "rules"
$ClaudeCommandsDir = Join-Path $ClaudeDir "commands"
$ClaudePluginsDir = Join-Path $ClaudeDir "plugins"

New-Item -ItemType Directory -Path $ClaudeRulesDir -Force | Out-Null
New-Item -ItemType Directory -Path $ClaudeCommandsDir -Force | Out-Null
New-Item -ItemType Directory -Path $ClaudePluginsDir -Force | Out-Null

Copy-Item (Join-Path $ScriptDir "configs\claude\settings.json") (Join-Path $ClaudeDir "settings.json") -Force
Copy-Item (Join-Path $ScriptDir "configs\claude\settings.local.json") (Join-Path $ClaudeDir "settings.local.json") -Force
Ok "Claude settings installed"

Copy-Item (Join-Path $ScriptDir "configs\claude-plugins\blocklist.json") (Join-Path $ClaudePluginsDir "blocklist.json") -Force

# Fix path in known_marketplaces.json
$kmContent = Get-Content (Join-Path $ScriptDir "configs\claude-plugins\known_marketplaces.json") -Raw
$kmContent = $kmContent -replace '/Users/cc/', ($HomeDir.Replace('\', '/') + '/')
Set-Content -Path (Join-Path $ClaudePluginsDir "known_marketplaces.json") -Value $kmContent -NoNewline
Ok "Claude plugins metadata installed"

# Copy rules from persona (Windows symlinks need admin, so we copy)
$PersonaRules = Join-Path $PersonaDir ".claude\rules"
if (Test-Path $PersonaRules) {
    Get-ChildItem -Path $PersonaRules -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $ClaudeRulesDir $_.Name) -Force
    }
    Ok "Claude rules copied from persona"
}

# Copy commands from persona
$PersonaCmds = Join-Path $PersonaDir ".claude\commands"
if (Test-Path $PersonaCmds) {
    Get-ChildItem -Path $PersonaCmds -Filter "*.md" | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $ClaudeCommandsDir $_.Name) -Force
    }
    Ok "Claude commands copied from persona"
}

# ============================================================
# Step 6: Configure Codex
# ============================================================
Info "Step 6: Configuring Codex..."

$CodexDir = Join-Path $HomeDir ".codex"
New-Item -ItemType Directory -Path $CodexDir -Force | Out-Null

$configContent = Get-Content (Join-Path $ScriptDir "configs\codex\config.toml") -Raw
$configContent = $configContent -replace '/Users/cc', ($HomeDir.Replace('\', '/'))
Set-Content -Path (Join-Path $CodexDir "config.toml") -Value $configContent -NoNewline
Ok "Codex config.toml installed (paths updated)"

# ============================================================
# Step 7: Configure Gemini
# ============================================================
Info "Step 7: Configuring Gemini..."

$GeminiDir = Join-Path $HomeDir ".gemini"
New-Item -ItemType Directory -Path $GeminiDir -Force | Out-Null

Copy-Item (Join-Path $ScriptDir "configs\gemini\settings.json") (Join-Path $GeminiDir "settings.json") -Force
Ok "Gemini settings.json installed"

# ============================================================
# Step 8: Done
# ============================================================
Write-Host ""
Write-Host "======================================"
Write-Host "   Setup Complete!                    "
Write-Host "======================================"
Write-Host ""
Info "Installed components:"
Write-Host "  $PersonaDir              -- Persona cognitive library"
Write-Host "  $GuanDir                 -- Framework source"
Write-Host "  $ClaudeDir               -- Claude Code config + rules"
Write-Host "  $CodexDir                -- Codex config"
Write-Host "  $GeminiDir               -- Gemini config"
Write-Host ""
Warn "Authentication required (run these manually):"
Write-Host "  1. claude   -- First run will prompt for Anthropic auth"
Write-Host "  2. codex    -- First run will prompt for OpenAI auth"
Write-Host "  3. gemini   -- First run will prompt for Google OAuth"
Write-Host ""
Info "Verification: cd into any project and run 'claude' then type /boot"
Write-Host ""
Ok "GUAN Framework v1.3 ready."
