# Frequently asked questions

Common questions about mobile development environment setup.

## General questions

### What iOS versions are supported?

iOS 12.0 and later. Modern SSH clients like Termius and Blink Shell need iOS 13.0 or later for best results.

### Can I use this setup with Android devices?

While this guide focuses on iOS, the server-side configuration works with any SSH client. Android users can use Termux or JuiceSSH with similar results.

### How much does it cost to run a development server?

Basic VPS instances start at $2.50-6/month depending on the provider. A 1GB RAM instance is usually enough for development work.

## SSH and security

### Is it safe to use SSH keys on mobile devices?

Yes, when properly configured. Use Ed25519 keys, enable device lock screens, and consider using SSH key passphrases for additional security.

### Should I use the default SSH port?

No. Change the default SSH port (22) to a non-standard port like 2222. This reduces automated attack attempts.

### How do I backup my SSH keys?

Most iOS SSH clients support key export. Store encrypted backups in secure locations like 1Password or iCloud Keychain.

## Connection and performance

### Why is Mosh recommended over SSH?

Mosh provides better mobile connectivity with:

- Network roaming support
- Connection resilience during device sleep
- Instant local echo for better responsiveness
- UDP-based protocol optimized for mobile networks

### Can I use multiple SSH sessions simultaneously?

Yes, both Termius and Blink Shell support multiple concurrent connections. Use tmux on the server for session management.

### How do I handle network interruptions?

Use tmux for session persistence and Mosh for automatic reconnection. Your work continues even if the connection drops.

## Development environment

### Can I run VS Code on the server?

Yes, use VS Code Server or GitHub Codespaces. Access the web interface through port forwarding for a full IDE experience.

### How do I manage multiple projects?

Use GitHub CLI for repository management and tmux sessions for project organization. Each project can have its own tmux session.

### What about large file transfers?

Use `rsync` or `scp` for efficient file transfers. For regular workflows, direct editing on the server is more efficient.

## GitHub integration

### How do I handle GitHub authentication?

GitHub CLI handles authentication automatically. Use `gh auth login` to authenticate once, then all git operations work seamlessly.

### Can I use multiple GitHub accounts?

Yes, configure different SSH keys for different accounts and use git config to specify which account to use per repository.

### How do I manage private repositories?

GitHub CLI supports private repositories automatically after authentication. Ensure your SSH keys are properly configured.

## Cloud providers

### Which cloud provider is best for mobile development?

Digital Ocean is recommended for simplicity and reliability. AWS EC2 offers free tier options. Choose based on your location and requirements.

### Can I use my existing server?

Yes, any Ubuntu/Debian server with SSH access works. Follow the server configuration steps in the VPS setup guide.

### How do I handle server backups?

Use your cloud provider's snapshot features or implement automated backups using tools like `rsync` or `duplicity`.

## iOS clients

### Which iOS SSH client is best?

- **Termius**: Best for beginners, excellent sync features
- **Blink Shell**: Advanced features, professional developers
- **Choice depends on**: Budget, feature requirements, and workflow preferences

### Can I use external keyboards?

Yes, both Termius and Blink Shell support external keyboards. Blink Shell has particularly good external keyboard support.

### How do I handle special key combinations?

iOS SSH clients provide virtual key bars or customizable keyboards for special keys like Ctrl, Alt, and function keys.

## Troubleshooting

### My connection keeps dropping, what should I do?

1. Switch to Mosh protocol
2. Enable SSH keep-alive settings
3. Check your mobile network stability
4. Use tmux for session persistence

### I can't connect to my server, what's wrong?

Check:

1. Server IP address and port
2. SSH service status (`systemctl status ssh`)
3. Firewall configuration (`ufw status`)
4. SSH key authentication setup

### GitHub authentication isn't working, how do I fix it?

1. Re-run `gh auth login`
2. Check GitHub CLI installation
3. Verify network connectivity
4. Ensure proper SSH key configuration

## Advanced usage

### Can I use this setup for production deployments?

This setup is designed for development. For production, implement additional security measures, monitoring, and backup strategies.

### How do I scale this setup for teams?

Use separate user accounts per team member, implement proper SSH key management, and consider using bastion hosts for enhanced security.

### Can I automate the entire setup?

Yes, use the Cloud-Init configuration provided in the guide for fully automated server provisioning and configuration.

## Performance optimization

### How can I improve performance?

- Use SSD-based VPS instances
- Enable SSH compression
- Use connection multiplexing
- Optimize your mobile network connection
- Use local caching where possible

### What about battery life on iOS?

SSH clients are generally efficient. Use Mosh for better power management and consider reducing screen brightness during long coding sessions.

## Getting started

### I'm new to command line, is this guide suitable?

This guide assumes basic command line familiarity. Consider completing a basic Linux tutorial before starting.

### How long does the setup take?

- Manual setup: 30-60 minutes
- Cloud-Init automated setup: 10-15 minutes
- Learning curve: 1-2 hours for new users

### What if I need help?

1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Review the [References](references.md) for additional resources
3. Ensure you follow the setup steps sequentially
4. Document your specific configuration for easier debugging
