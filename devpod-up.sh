#!/usr/bin/env bash

# Helper script to start DevPod with optional credential mounts

echo "Starting DevPod with optional credential mounts..."

# Build mount arguments dynamically
MOUNT_ARGS=""

# Check and add mounts for directories that exist
if [ -d "$HOME/.config" ]; then
    MOUNT_ARGS="$MOUNT_ARGS --mount source=$HOME/.config,target=/home/node/.config,type=bind"
    echo "✓ Will mount .config"
fi

if [ -d "$HOME/.claude" ]; then
    MOUNT_ARGS="$MOUNT_ARGS --mount source=$HOME/.claude,target=/home/node/.claude,type=bind"
    echo "✓ Will mount .claude"
fi

if [ -d "$HOME/.aws" ]; then
    MOUNT_ARGS="$MOUNT_ARGS --mount source=$HOME/.aws,target=/home/node/.aws,type=bind"
    echo "✓ Will mount .aws"
fi

# Start devpod with dynamic mounts
echo "Starting DevPod..."
devpod up . $MOUNT_ARGS "$@"