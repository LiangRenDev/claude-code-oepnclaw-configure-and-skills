#!/bin/bash
# Claude Code & OpenClaw Daily Backup Script
# This script backs up configuration files, skills, and documentation to GitHub

# Configuration
REPO_DIR="/tmp/claude-openclaw-skills"
# Use GITHUB_TOKEN environment variable for authentication
# Set it with: export GITHUB_TOKEN="your_token_here"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
GITHUB_REPO="https://${GITHUB_TOKEN}@github.com/LiangRenDev/claude-code-oepnclaw-configure-and-skills.git"
CLAUDE_DIR="$HOME/.claude"
OPENCLAW_SKILLS_DIR="$HOME/.npm-global/lib/node_modules/openclaw"
LOG_FILE="$REPO_DIR/backup.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

# Function to backup Claude Code config
backup_claude_config() {
    log "Backing up Claude Code configuration..."

    # Create directories if they don't exist
    mkdir -p "$REPO_DIR/claude-code-config/rules"
    mkdir -p "$REPO_DIR/claude-code-config/skills"
    mkdir -p "$REPO_DIR/claude-code-config/agents"

    # Copy main config files (only if they exist)
    [ -f "$CLAUDE_DIR/user-preferences.md" ] && cp "$CLAUDE_DIR/user-preferences.md" "$REPO_DIR/claude-code-config/"
    [ -f "$CLAUDE_DIR/settings.json" ] && cp "$CLAUDE_DIR/settings.json" "$REPO_DIR/claude-code-config/"
    [ -f "$CLAUDE_DIR/settings.local.json" ] && cp "$CLAUDE_DIR/settings.local.json" "$REPO_DIR/claude-code-config/"

    # Copy rules
    cp -r "$CLAUDE_DIR/rules"/*.md "$REPO_DIR/claude-code-config/rules/" 2>/dev/null || true

    # Copy skills
    rm -rf "$REPO_DIR/claude-code-config/skills/"*
    cp -r "$CLAUDE_DIR/skills"/* "$REPO_DIR/claude-code-config/skills/" 2>/dev/null || true

    # Copy agent skills
    rm -rf "$REPO_DIR/claude-code-config/agents/"*
    cp -r "$CLAUDE_DIR/.agents/skills"/* "$REPO_DIR/claude-code-config/agents/" 2>/dev/null || true

    log "Claude Code configuration backed up successfully."
}

# Function to backup OpenClaw documentation
backup_openclaw_docs() {
    log "Backing up OpenClaw documentation..."

    # Backup OpenClaw docs if directory exists
    if [ -d "$OPENCLAW_SKILLS_DIR/docs" ]; then
        mkdir -p "$REPO_DIR/openclaw-docs"
        cp "$OPENCLAW_SKILLS_DIR/docs/cli/agents.md" "$REPO_DIR/openclaw-docs/" 2>/dev/null || true
        cp "$OPENCLAW_SKILLS_DIR/docs/cli/config.md" "$REPO_DIR/openclaw-docs/" 2>/dev/null || true
        cp "$OPENCLAW_SKILLS_DIR/docs/cli/setup.md" "$REPO_DIR/openclaw-docs/" 2>/dev/null || true
        cp "$OPENCLAW_SKILLS_DIR/docs/cli/configure.md" "$REPO_DIR/openclaw-docs/" 2>/dev/null || true
        cp "$OPENCLAW_SKILLS_DIR/README.md" "$REPO_DIR/openclaw-docs/" 2>/dev/null || true
    fi

    log "OpenClaw documentation backed up successfully."
}

# Function to sync with GitHub
sync_to_github() {
    log "Syncing to GitHub..."

    cd "$REPO_DIR" || exit 1

    # Configure git if not already configured
    git config user.name "LiangRenDev" 2>/dev/null || true
    git config user.email "liangrendev@users.noreply.github.com" 2>/dev/null || true

    # Add all changes
    git add -A

    # Check if there are changes to commit
    if git diff --cached --quiet; then
        log "No changes to commit. Backup is up to date."
        return 0
    fi

    # Commit changes
    git commit -m "Automated backup: $(date '+%Y-%m-%d %H:%M:%S')

- Updated Claude Code configuration
- Synced OpenClaw documentation
- Added new skills and rules" 2>&1 || {
        log "Warning: Nothing to commit or commit failed"
        return 0
    }

    # Push to GitHub
    if git push origin main 2>&1; then
        log "Successfully pushed to GitHub!"
    else
        log "Error: Failed to push to GitHub"
        return 1
    fi
}

# Main execution
main() {
    log "=== Starting backup process ==="

    # Check if repo directory exists
    if [ ! -d "$REPO_DIR" ]; then
        log "Error: Repository directory not found at $REPO_DIR"
        exit 1
    fi

    # Check if git is initialized
    if [ ! -d "$REPO_DIR/.git" ]; then
        log "Error: Git not initialized in $REPO_DIR"
        exit 1
    fi

    # Perform backups
    backup_claude_config
    backup_openclaw_docs

    # Sync to GitHub
    sync_to_github

    log "=== Backup process completed ==="
    echo ""
}

# Run main function
main "$@"
