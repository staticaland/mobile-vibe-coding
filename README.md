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

### 3.3 Additional Development Tools

```bash
# Install Node.js (for web development)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
apt-get install -y nodejs

# Install Python (usually pre-installed)
apt install -y python3 python3-pip

# Install Docker (optional)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker developer
```

## Part 4: Claude Code Workflow

### 4.1 Basic Claude Code Usage

```bash
# Start Claude Code session
claude

# Common commands:
claude --resume          # Resume previous session
claude --project ./      # Start in specific directory
claude --help           # View all options
```

### 4.2 iOS-Optimized Workflow

```bash
# Create workspace directory
mkdir -p ~/workspace
cd ~/workspace

# Use screen/tmux for persistent sessions
sudo apt install screen tmux

# Start persistent session[^8]
screen -S coding
# or
tmux new-session -s coding

# Inside session, start Claude Code
claude

# Detach: Ctrl+A, D (screen) or Ctrl+B, D (tmux)
# Reattach: screen -r coding or tmux attach -t coding
```

## Part 5: Project Bootstrapping with GitHub CLI

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

# Set git user info from GitHub account
git config user.name "$(gh api user --jq .login)"
git config user.email "$(gh api user --jq .email)"

# Set default repository for easier operations
gh repo set-default owner/repo-name
```

### 4. Commit and Push

```bash
# Stage all files
git add .

# Commit with descriptive message
git commit -m "Initial commit

Add README and project setup

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
git push -u origin master
```

## Key Benefits

- **Fast Setup**: One-command repository creation
- **Integrated Auth**: GitHub CLI handles authentication seamlessly  
- **Auto-Configuration**: Git user info pulled from GitHub account
- **Remote Setup**: Origin remote configured automatically

## Part 6: Troubleshooting

### Common VPS Issues

```bash
# SSH connection refused
sudo systemctl status sshd
sudo systemctl restart sshd

# Port not accessible
sudo ufw allow 2222/tcp
sudo ufw enable

# Out of disk space
df -h
sudo apt autoremove
sudo apt autoclean
```

### GitHub CLI Issues

```bash
# Authentication problems
gh auth status
gh auth logout
gh auth login

# Permission denied
gh auth refresh --scopes repo,workflow

# Repository not found
gh repo set-default owner/repo-name
```

### iOS-specific Troubleshooting

#### Connection Drops
- **Issue**: SSH connection drops frequently
- **Solution**: Add to `~/.ssh/config`:
```
Host your-vps-ip
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

#### Keyboard Issues
- **Issue**: Special keys not working in iOS terminal apps
- **Solutions**:
  - Termius: Use custom keyboard with Esc, Tab, Ctrl keys
  - Blink Shell: Configure external keyboard shortcuts
  - General: Use `screen` or `tmux` for better terminal management

#### File Transfer
```bash
# Using scp from iOS (in supported apps)
scp -P 2222 local-file developer@your-vps-ip:~/

# Using rsync
rsync -avz -e "ssh -p 2222" ./local-dir/ developer@your-vps-ip:~/remote-dir/
```

### Claude Code Issues

```bash
# API key not set
export ANTHROPIC_API_KEY="your-key-here"
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc

# Session not resuming
claude-code --resume --session-id your-session-id

# Memory issues on small VPS
# Upgrade to larger droplet or use swap:
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Project-specific Troubleshooting

- If commit fails due to missing user identity, use `gh auth setup-git` first
- For private repos, use `--private` flag instead of `--public`
- Check authentication status with `gh auth status`
- For large files, consider Git LFS: `git lfs install`

## Part 7: Tips for iOS Development

### Optimizing the Experience

1. **Use Persistent Sessions**: Always use `screen` or `tmux`
2. **Configure Vim**: Install proper vim configuration for better editing
3. **Alias Commands**: Create shortcuts for common operations
4. **Backup Regularly**: Set up automated backups to GitHub

### Sample Aliases

```bash
# Add to ~/.bashrc
alias ll='ls -la'
alias gc='git commit'
alias gs='git status'
alias cc='claude-code'
alias proj='cd ~/workspace && claude-code --resume'

# Quick project setup
alias newproj='mkdir -p ~/workspace/$1 && cd ~/workspace/$1 && git init && gh repo create $1 --source=. --public'
```

### Recommended VPS Specs

- **Minimum**: 1 CPU, 1GB RAM, 25GB SSD ($4-6/month)
- **Recommended**: 1 CPU, 2GB RAM, 50GB SSD ($10-12/month)  
- **Heavy Development**: 2 CPU, 4GB RAM, 80GB SSD ($20-24/month)

## Conclusion

This setup creates a powerful development environment accessible from any iOS device. The combination of VPS + GitHub CLI + Claude Code provides:

- **Professional Development**: Full Linux environment with all tools
- **Persistent Sessions**: Work continues even when disconnected
- **Version Control**: Seamless GitHub integration
- **AI Assistance**: Claude Code for enhanced productivity
- **iOS Accessibility**: Code anywhere with just an iPad/iPhone

The workflow creates a complete project setup in minutes rather than manual repository creation and configuration, while providing the flexibility of a full development environment accessible from mobile devices.

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