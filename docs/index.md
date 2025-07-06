# Mobile development environment setup

Code from your iOS device using Claude Code and a remote development server.

## What you'll set up

1. **[iOS SSH setup](setup/ios-ssh.md)** - Configure SSH keys and terminal clients on iOS
2. **[VPS setup](setup/vps.md)** - Create and configure a cloud development server  
3. **[Development environment](setup/dev-env.md)** - Install development tools and Claude Code
4. **[Cloud-Init](setup/cloud-init.md)** - Automated server setup (optional)
5. **[Port forwarding](setup/port-forwarding.md)** - Configure network tunneling for local development

## Key features

- **One-command setup** - Repository creation and configuration
- **GitHub authentication** - CLI handles auth automatically  
- **Auto-configuration** - Git user info pulled from GitHub
- **Remote development** - Origin remote configured automatically
- **Mobile-optimized** - Persistent connections using Mosh and tmux

## What you need

- iOS device with SSH client
- GitHub account with appropriate permissions
- Cloud hosting provider access (Digital Ocean, AWS, etc.)
- Basic command-line familiarity

## Quick start

Follow these steps in order:

1. Generate SSH keys on your iOS device
2. Create and configure your VPS instance
3. Install development tools and authenticate with GitHub
4. Configure Claude Code for your workflow

Advanced users can use [Cloud-Init](setup/cloud-init.md) for automated server setup.
