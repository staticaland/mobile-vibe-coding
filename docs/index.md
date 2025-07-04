# Mobile Development Environment Setup Guide

This guide provides step-by-step instructions for establishing a complete mobile development environment using Claude Code, enabling you to code effectively from iOS devices through a remote development server.

## Overview

This documentation covers the complete setup process from initial configuration to productive development:

1. **[iOS SSH Setup](setup/ios-ssh.md)** - Configure SSH keys and terminal clients on iOS devices
2. **[VPS Setup](setup/vps.md)** - Create and configure a cloud development server
3. **[Development Environment](setup/dev-env.md)** - Install essential development tools and Claude Code
4. **[Cloud-Init](setup/cloud-init.md)** - Automated server provisioning (optional)
5. **[Port Forwarding](setup/port-forwarding.md)** - Configure network tunneling for local development

## Key Features

- **Streamlined Setup**: One-command repository creation and configuration
- **Integrated Authentication**: GitHub CLI handles authentication seamlessly
- **Auto-Configuration**: Git user information pulled from GitHub account
- **Remote Development**: Origin remote configured automatically
- **Mobile-Optimized**: Persistent connections using Mosh and tmux

## Prerequisites

Before starting, ensure you have:

- An iOS device with a compatible SSH client
- A GitHub account with appropriate permissions
- Access to a cloud hosting provider (Digital Ocean, AWS, etc.)
- Basic familiarity with command-line interfaces

## Quick Start

Follow the setup sections in sequential order for optimal results:

1. Generate SSH keys on your iOS device
2. Create and configure your VPS instance
3. Install development tools and authenticate with GitHub
4. Configure Claude Code for your development workflow

For advanced users, the [Cloud-Init](setup/cloud-init.md) section provides automated server provisioning options.
