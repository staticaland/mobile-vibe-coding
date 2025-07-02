# Coding from iOS with Claude Code: Complete Setup Guide

This comprehensive guide walks you through setting up a complete development environment for coding from iOS using Claude Code, including VPS setup, GitHub CLI configuration, and project bootstrapping.

## Overview

This guide covers:
1. **iOS SSH Setup** - Configuring SSH keys and clients on iOS devices
2. **VPS Setup** - Getting a cloud server (Digital Ocean, AWS, etc.)
3. **iOS Access Configuration** - Connecting from iOS devices using SSH
4. **Server Configuration** - Installing essential tools and GitHub CLI
5. **Claude Code Integration** - Setting up the development workflow
6. **Project Bootstrapping** - Quick project creation with GitHub CLI

## Part 1: iOS SSH Setup

### 1.1 iOS SSH Clients

**Recommended iOS Apps:**
- **Termius²** (Free/Pro) - Cross-platform SSH client with mosh support, custom keyboards, and seamless authentication
- **Blink Shell³** ($20) - Professional terminal with mosh integration, VS Code/Codespaces support, and external keyboard compatibility
- **1Password** - SSH key generation and management

### 1.2 Generate SSH Keys on iOS

You can generate SSH keys using several iOS apps:

#### Using Termius (Recommended)
1. Open Termius → Settings → Keychain
2. Tap "+" → Add Key → Generate
3. Key type: Ed25519[^6]
4. Label: "iOS Development Key"
5. Copy the public key for VPS setup

#### Using Blink Shell
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub  # Copy this public key
```

#### Using 1Password
1. Open 1Password → Create → SSH Key
2. Name: "Development SSH Key"
3. Key type: Ed25519
4. Save and copy public key


## Part 2: VPS Setup

### 2.1 Create a VPS

#### Digital Ocean (Recommended)
1. Go to https://cloud.digitalocean.com/
2. Create Droplets → Ubuntu 22.04 LTS
3. Choose Basic plan ($4-6/month)
4. **Add SSH Key**: Paste your public key from iOS SSH app[^5]
5. Create Droplet

#### AWS EC2 Alternative
1. Go to https://aws.amazon.com/ec2/
2. Launch Instance → Ubuntu Server 22.04 LTS
3. Choose t2.micro (free tier eligible)
4. Configure security group (allow SSH port 22)
5. Upload your SSH public key
6. Launch instance

#### Other VPS Providers
- **Linode**: $5/month basic plans
- **Vultr**: $2.50/month starting
- **Hetzner**: €3.29/month in EU

### 2.2 Server Setup and iOS Access

#### Initial Server Configuration
```bash
# Update system
apt update && apt upgrade -y

# Install mosh for better mobile connectivity
apt install -y mosh

# Install tmux for session management
apt install -y tmux

# Create non-root user
adduser developer
usermod -aG sudo developer

# Copy SSH keys to new user
rsync --archive --chown=developer:developer ~/.ssh /home/developer
```

#### iOS Connection Setup
**Connection Setup in iOS SSH App:**
```
Host: your-vps-ip
Port: 22 (default) or 2222 (if changed)
Username: developer (or root initially)
Authentication: SSH Key (from your iOS app)
Protocol: SSH or Mosh (recommended for mobile)
```

**Mosh Connection (Recommended for Mobile):**
- **Termius**: Supports mosh connections for better connectivity
- **Blink Shell**: Full mosh support with automatic reconnection
- **Benefits⁴**: Automatic roaming between networks, instant local echo, connection resilience during sleep/wake cycles
- **Connection Command**: Set `tmux new-session -A -s main` as startup command for persistent sessions

**First Connection Test:**
1. Open your iOS SSH app (Termius, Blink Shell, etc.)
2. Create new host with VPS IP address
3. Select your SSH key from the app's keychain
4. Choose mosh protocol if available
5. Connect and verify access

#### SSH Security Configuration
```bash
# Edit SSH config for better security
sudo vim /etc/ssh/sshd_config

# Recommended settings:
# Port 2222                    # Change default port
# PermitRootLogin no          # Disable root login
# PasswordAuthentication no   # Use keys only
# PubkeyAuthentication yes

# Restart SSH service
sudo systemctl restart sshd
```

> **Security Note**: For comprehensive server hardening, see the complete security guide¹ which covers firewall configuration, intrusion detection, system monitoring, and additional security measures.

#### iOS Connection Optimization
Add to `~/.ssh/config` on the server:
```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

## Part 3: Development Environment Setup

### 3.1 Install GitHub CLI

```bash
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt update
apt install gh -y

# Authenticate with GitHub
gh auth login[^7]
# Follow prompts: GitHub.com → HTTPS → Authenticate via web browser
```

### 3.2 Install Claude Code

See the [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code/overview) for installation instructions.

## Part 3: Project Bootstrapping with GitHub CLI

### Prerequisites

- VPS with GitHub CLI installed and authenticated
- SSH access from iOS device
- Claude Code installed and configured

### 1. Create GitHub Repository

```bash
# Initialize git if not already done
git init

# Create GitHub repo from current directory
gh repo create your-project-name --source=. --public
```

### 2. Create README (Optional)

```bash
# Create a basic README file
echo "# Your Project Name" > README.md
echo "" >> README.md
echo "Project description goes here." >> README.md
```

### 3. Configure Git with GitHub CLI

```bash
# Setup git authentication with GitHub
gh auth setup-git

# Set git user info from GitHub account (globally)
git config --global user.name "$(gh api user --jq .name)"
git config --global user.email "$(gh api user --jq .email)"

# Set default repository for easier operations
gh repo set-default owner/repo-name
```

## Key Benefits

- **Fast Setup**: One-command repository creation
- **Integrated Auth**: GitHub CLI handles authentication seamlessly  
- **Auto-Configuration**: Git user info pulled from GitHub account
- **Remote Setup**: Origin remote configured automatically

---

## References

[^1]: [How To Secure A Linux Server](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server) - Comprehensive guide covering SSH hardening, firewall configuration, intrusion detection, and system monitoring

[^2]: [Termius](https://termius.com/) - Cross-platform SSH client with mosh support, custom keyboards, and seamless authentication across iOS, Android, Windows, macOS, and Linux

[^3]: [Blink Shell](https://blink.sh/) - Professional iOS terminal with mosh integration, VS Code/Codespaces support, external keyboard compatibility, and persistent mobile connections

[^4]: [Mosh](https://mosh.org/) - Mobile shell with automatic network roaming, instant local echo, and connection resilience during network changes and device sleep cycles

[^5]: [How to Add SSH Keys to Droplets](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/) - Official DigitalOcean documentation for adding SSH keys to new or existing droplets

[^6]: [SSH Key Best Practices for 2025](https://www.brandonchecketts.com/archives/ssh-ed25519-key-best-practices-for-2025) - Current best practices for Ed25519 SSH keys, including generation, security, and management recommendations

[^7]: [GitHub CLI Authentication](https://cli.github.com/manual/gh_auth_login) - Official GitHub CLI documentation for authentication setup and token management

[^8]: [Persistent SSH Sessions with tmux](https://dev.to/idoko/persistent-ssh-sessions-with-tmux-25dm) - Guide to using tmux for maintaining persistent terminal sessions across network disconnections