#!/usr/bin/env bash

# This script handles credential mounting from the host
# DevPod should handle the actual mounting, but this provides fallback

echo "Checking for mounted credentials..."

# DevPod typically mounts credentials automatically when they exist
# This script just verifies and reports status

check_credentials() {
    local path="$1"
    local name="$2"

    if [ -d "$path" ] && [ "$(ls -A $path 2>/dev/null)" ]; then
        echo "✓ $name credentials available at $path"
        return 0
    else
        echo "ℹ $name credentials not available (optional)"
        return 1
    fi
}

# Check each credential location
check_credentials "$HOME/.config/gh" "GitHub CLI"
check_credentials "$HOME/.claude" "Claude"
check_credentials "$HOME/.aws" "AWS"

# Check SSH agent
if [ ! -z "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ]; then
    echo "✓ SSH agent forwarding is active"
else
    echo "ℹ SSH agent not available (optional)"
fi

echo ""
echo "Note: To use credentials, ensure they exist on your host machine:"
echo "  - GitHub CLI: Run 'gh auth login' on host"
echo "  - AWS: Configure with 'aws configure' on host"
echo "  - Claude: Set up Claude CLI on host"
echo ""