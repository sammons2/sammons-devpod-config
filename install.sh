#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect if running in container
is_container() {
    # Check multiple indicators for container environment
    if [[ -f /.dockerenv ]]; then
        return 0
    fi

    if [[ -f /proc/1/cgroup ]] && grep -q docker /proc/1/cgroup; then
        return 0
    fi

    if [[ "${CONTAINER:-}" == "true" ]]; then
        return 0
    fi

    # Check for common DevContainer indicators
    if [[ -n "${REMOTE_CONTAINERS:-}" ]] || [[ -n "${CODESPACES:-}" ]]; then
        return 0
    fi

    return 1
}

# Create backup of existing file/symlink
backup_existing() {
    local target="$1"
    local backup_dir="$HOME/.dotfiles-backup"

    if [[ -e "$target" ]]; then
        mkdir -p "$backup_dir"
        local backup_name="$(basename "$target").$(date +%Y%m%d_%H%M%S)"
        local backup_path="$backup_dir/$backup_name"

        log_warning "Backing up existing $target to $backup_path"
        mv "$target" "$backup_path"
        return 0
    fi
    return 1
}

# Create symlink with backup logic
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        log_error "Source file does not exist: $source"
        return 1
    fi

    # If target is already a symlink to the correct source, skip
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        log_info "Symlink already exists and is correct: $target -> $source"
        return 0
    fi

    # Backup existing file/symlink if it exists
    backup_existing "$target"

    # Create the symlink
    ln -sf "$source" "$target"
    log_success "Created symlink: $target -> $source"
    return 0
}

# Install dotfiles
install_dotfiles() {
    local dotfiles_dir="$1"

    log_info "Installing dotfiles from: $dotfiles_dir"

    # Find all dotfiles in subdirectories
    local installed_count=0
    local error_count=0

    for category_dir in "$dotfiles_dir"/*/; do
        if [[ ! -d "$category_dir" ]]; then
            continue
        fi

        local category="$(basename "$category_dir")"
        log_info "Processing category: $category"

        for dotfile in "$category_dir"/.??*; do
            if [[ ! -f "$dotfile" ]]; then
                continue
            fi

            local filename="$(basename "$dotfile")"
            local target="$HOME/$filename"

            log_info "Installing $filename"

            if create_symlink "$dotfile" "$target"; then
                ((installed_count++))
            else
                ((error_count++))
            fi
        done
    done

    log_info "Installation complete: $installed_count files installed, $error_count errors"
    return $error_count
}

# Main installation logic
main() {
    log_info "Starting dotfiles installation..."

    # Detect environment
    if is_container; then
        log_info "Container environment detected"
    else
        log_info "Host environment detected"
    fi

    # Check if script is being run from the correct directory
    if [[ ! -d "$SCRIPT_DIR/bash" ]] || [[ ! -d "$SCRIPT_DIR/git" ]] || [[ ! -d "$SCRIPT_DIR/zsh" ]]; then
        log_error "This script must be run from the dotfiles directory containing bash/, git/, and zsh/ subdirectories"
        exit 1
    fi

    # Install dotfiles
    if install_dotfiles "$SCRIPT_DIR"; then
        log_success "All dotfiles installed successfully!"

        # Show next steps
        echo
        log_info "Next steps:"
        echo "  1. Source your shell configuration or restart your shell"
        echo "  2. For bash: source ~/.bashrc"
        echo "  3. For zsh: source ~/.zshrc"

        if is_container; then
            echo "  4. Container detected - dotfiles are ready for use"
        else
            echo "  4. Host system detected - consider installing mise if not already installed"
        fi

    else
        log_error "Some errors occurred during installation"
        exit 1
    fi
}

# Run main function
main "$@"