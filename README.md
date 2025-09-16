# DevPod TypeScript Development Environment & Dotfiles

This repository provides a dual-purpose setup for both DevContainer-based TypeScript development and personal dotfiles configuration.

## Quick Start with DevPod

```bash
# Use this repository as a DevContainer template
devpod up https://github.com/sammons2/sammons-devpod-config

# Or with an existing project, use as dotfiles
devpod up <your-project> --dotfiles https://github.com/sammons2/sammons-devpod-config
```

## Structure

- `.devcontainer/` - DevContainer configuration for TypeScript development
- `bash/` - Bash configuration files and scripts
- `git/` - Git configuration and aliases
- `zsh/` - Zsh configuration and themes

## Getting Started

### DevContainer Setup

This repository includes a DevContainer configuration that provides a complete TypeScript development environment with Node.js 24 on Debian Bookworm.

#### Credential Forwarding

The DevContainer is configured to forward credentials from your host machine for seamless development:

**Required Host Setup:**
- GitHub CLI (`gh`) authenticated on your host machine
- Claude CLI configuration in `~/.claude/` directory
- AWS CLI credentials in `~/.aws/` directory
- SSH agent running with your SSH keys loaded

**Forwarded Credentials:**
- GitHub CLI configuration (`.config/gh`) - for GitHub operations
- Claude CLI configuration (`.claude`) - for Claude Code access
- AWS credentials (`.aws`) - for AWS service access
- SSH agent socket - for Git operations over SSH

**Features Included:**
- GitHub CLI (`gh`) - pre-installed and configured
- AWS CLI - pre-installed and configured
- ESLint VS Code extension - for TypeScript linting

To verify credential forwarding works after container startup:
```bash
gh auth status    # Should show your GitHub authentication
aws sts get-caller-identity  # Should show your AWS identity (if configured)
ssh-add -l       # Should list your SSH keys
```

### Standalone Dotfiles Installation

You can use this repository as a standalone dotfiles configuration on any Linux or macOS system.

#### Quick Install

```bash
# Clone the repository
git clone https://github.com/sammons2/sammons-devpod-config.git ~/.dotfiles

# Navigate to the directory
cd ~/.dotfiles

# Run the installation script
./install.sh
```

#### What Gets Installed

The installation script will create symlinks in your home directory for:

- `~/.bashrc` - Bash configuration with mise activation
- `~/.bash_profile` - Bash profile that sources bashrc
- `~/.zshrc` - Zsh configuration with mise activation
- `~/.gitconfig` - Git configuration with user settings

#### Installation Features

- **Smart Backup**: Existing files are automatically backed up to `~/.dotfiles-backup/`
- **Idempotent**: Safe to run multiple times without creating duplicates
- **Container Detection**: Automatically detects if running in a container vs host system
- **Symlink Management**: Creates symlinks that stay in sync with the repository

#### Prerequisites

The dotfiles expect [mise](https://mise.jdx.dev/) to be installed for tool version management:

```bash
# Install mise
curl https://mise.run | sh

# Add to your PATH (the dotfiles will handle activation)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

#### Manual Installation

If you prefer manual installation, you can create symlinks individually:

```bash
ln -sf ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/bash/.bash_profile ~/.bash_profile
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
```

### Dotfiles Organization

The dotfiles are organized by shell and tool type for easy management and deployment.

## Complete Tool Chain

This development environment includes a carefully curated tool chain for modern TypeScript development and AI-assisted coding.

### Core Runtime Management

**mise (v2024.12.x)**
- **Purpose**: Universal tool version manager (replaces nvm, rbenv, pyenv, etc.)
- **Installation**: Auto-installed via DevContainer lifecycle commands
- **Configuration**: Automatically trusts `.mise.toml` files in home directory
- **Global Tools**: Node.js 24 (LTS) configured globally
- **PATH Integration**: Shims directory added to PATH for seamless tool access

### Development Environment

**Node.js 24 (LTS)**
- **Purpose**: JavaScript/TypeScript runtime
- **Management**: Managed via mise for consistent versions
- **Package Manager**: npm (bundled with Node.js)
- **Global Packages**: Claude Code CLI installed automatically

**TypeScript Development Stack**
- **ESLint**: Code linting and formatting
- **VS Code Extensions**: Integrated ESLint extension for real-time feedback
- **Container Base**: Microsoft's official TypeScript DevContainer image
- **Port Forwarding**: Pre-configured for common development ports (3000, 8080, 5173)

### AI Development Tools

**Claude Code CLI (@anthropic-ai/claude-code)**
- **Purpose**: AI-powered code assistance and automation
- **Version**: Latest stable release
- **Installation**: Auto-installed via npm during container creation
- **Configuration**: Inherits settings from host machine's `~/.claude/` directory
- **Integration**: Seamless credential forwarding from host

### Version Control & Collaboration

**GitHub CLI (gh)**
- **Purpose**: GitHub operations from command line
- **Installation**: Pre-installed via DevContainer feature
- **Authentication**: Forwarded from host machine
- **Verification**: Auto-checked on container start
- **Organization**: Supports both personal (Sammons) and enterprise (sammons2) accounts

**Git Configuration**
- **User**: ben@sammons.io
- **Organizations**: Personal (Sammons) and business (sammons2/Sammons Software LLC)
- **SSH**: Key forwarding via SSH agent socket mounting

### Cloud Integration

**AWS CLI**
- **Purpose**: Amazon Web Services operations
- **Installation**: Pre-installed via DevContainer feature
- **Credentials**: Forwarded from host machine's `~/.aws/` directory
- **Verification**: Available via `aws sts get-caller-identity`

### Container Lifecycle

**DevContainer Lifecycle Commands**
- **onCreateCommand**: Checks if dotfiles are already installed
- **postCreateCommand**:
  - Installs mise tool manager
  - Configures Node.js 24 globally
  - Installs Claude Code CLI
  - Runs dotfile installation script
- **postStartCommand**: Verifies GitHub CLI authentication status

### Shell Configuration

**Bash & Zsh Support**
- **Activation**: Both shells configured with mise activation
- **PATH Management**: Automatic mise shims directory inclusion
- **Auto-trust**: Mise configurations automatically trusted in home directory
- **History**: Optimized history settings for development workflow
- **Aliases**: Common development aliases pre-configured

### Development Workflow

1. **Container Creation**: Tools installed automatically via lifecycle commands
2. **Credential Access**: All host credentials available immediately
3. **Tool Activation**: mise manages all tool versions seamlessly
4. **AI Assistance**: Claude Code ready for immediate use
5. **Version Control**: GitHub operations available via CLI
6. **Cloud Operations**: AWS resources accessible when configured

This tool chain provides a complete, reproducible development environment that combines traditional development tools with modern AI assistance for enhanced productivity.