# Frequently Asked Questions

Common questions and answers about mobile development environment setup.

## General Questions

### Q: What iOS versions are supported?

**A:** This guide supports iOS 12.0 and later. Modern SSH clients like Termius and Blink Shell require iOS 13.0 or later for optimal functionality.

### Q: Can I use this setup with Android devices?

**A:** While this guide focuses on iOS, the server-side configuration works with any SSH client. Android users can use Termux or JuiceSSH with similar results.

### Q: How much does it cost to run a development server?

**A:** Basic VPS instances start at $2.50-6/month depending on the provider. For development work, a 1GB RAM instance is usually sufficient.

## SSH and Security

### Q: Is it safe to use SSH keys on mobile devices?

**A:** Yes, when properly configured. Use Ed25519 keys, enable device lock screens, and consider using SSH key passphrases for additional security.

### Q: Should I use the default SSH port?

**A:** For better security, change the default SSH port (22) to a non-standard port like 2222. This reduces automated attack attempts.

### Q: How do I backup my SSH keys?

**A:** Most iOS SSH clients support key export. Store encrypted backups in secure locations like 1Password or iCloud Keychain.

## Connection and Performance

### Q: Why is Mosh recommended over SSH?

**A:** Mosh provides better mobile connectivity with:

- Network roaming support
- Connection resilience during device sleep
- Instant local echo for better responsiveness
- UDP-based protocol optimized for mobile networks

### Q: Can I use multiple SSH sessions simultaneously?

**A:** Yes, both Termius and Blink Shell support multiple concurrent connections. Use tmux on the server for session management.

### Q: How do I handle network interruptions?

**A:** Use tmux for session persistence and Mosh for automatic reconnection. Your work continues even if the connection drops.

## Development Environment

### Q: Can I run VS Code on the server?

**A:** Yes, use VS Code Server or GitHub Codespaces. Access the web interface through port forwarding for a full IDE experience.

### Q: How do I manage multiple projects?

**A:** Use GitHub CLI for repository management and tmux sessions for project organization. Each project can have its own tmux session.

### Q: What about large file transfers?

**A:** Use `rsync` or `scp` for efficient file transfers. For regular workflows, direct editing on the server is more efficient.

## GitHub Integration

### Q: How do I handle GitHub authentication?

**A:** GitHub CLI handles authentication automatically. Use `gh auth login` to authenticate once, then all git operations work seamlessly.

### Q: Can I use multiple GitHub accounts?

**A:** Yes, configure different SSH keys for different accounts and use git config to specify which account to use per repository.

### Q: How do I manage private repositories?

**A:** GitHub CLI supports private repositories automatically after authentication. Ensure your SSH keys are properly configured.

## Cloud Providers

### Q: Which cloud provider is best for mobile development?

**A:** Digital Ocean is recommended for simplicity and reliability. AWS EC2 offers free tier options. Choose based on your location and requirements.

### Q: Can I use my existing server?

**A:** Yes, any Ubuntu/Debian server with SSH access works. Follow the server configuration steps in the VPS setup guide.

### Q: How do I handle server backups?

**A:** Use your cloud provider's snapshot features or implement automated backups using tools like `rsync` or `duplicity`.

## iOS Clients

### Q: Which iOS SSH client is best?

**A:**

- **Termius**: Best for beginners, excellent sync features
- **Blink Shell**: Advanced features, professional developers
- **Choice depends on**: Budget, feature requirements, and workflow preferences

### Q: Can I use external keyboards?

**A:** Yes, both Termius and Blink Shell support external keyboards. Blink Shell has particularly good external keyboard support.

### Q: How do I handle special key combinations?

**A:** iOS SSH clients provide virtual key bars or customizable keyboards for special keys like Ctrl, Alt, and function keys.

## Troubleshooting

### Q: My connection keeps dropping, what should I do?

**A:**

1. Switch to Mosh protocol
2. Enable SSH keep-alive settings
3. Check your mobile network stability
4. Use tmux for session persistence

### Q: I can't connect to my server, what's wrong?

**A:** Check:

1. Server IP address and port
2. SSH service status (`systemctl status ssh`)
3. Firewall configuration (`ufw status`)
4. SSH key authentication setup

### Q: GitHub authentication isn't working, how do I fix it?

**A:**

1. Re-run `gh auth login`
2. Check GitHub CLI installation
3. Verify network connectivity
4. Ensure proper SSH key configuration

## Advanced Usage

### Q: Can I use this setup for production deployments?

**A:** This setup is designed for development. For production, implement additional security measures, monitoring, and backup strategies.

### Q: How do I scale this setup for teams?

**A:** Use separate user accounts per team member, implement proper SSH key management, and consider using bastion hosts for enhanced security.

### Q: Can I automate the entire setup?

**A:** Yes, use the Cloud-Init configuration provided in the guide for fully automated server provisioning and configuration.

## Performance Optimization

### Q: How can I improve performance?

**A:**

- Use SSD-based VPS instances
- Enable SSH compression
- Use connection multiplexing
- Optimize your mobile network connection
- Use local caching where possible

### Q: What about battery life on iOS?

**A:** SSH clients are generally efficient. Use Mosh for better power management and consider reducing screen brightness during long coding sessions.

## Getting Started

### Q: I'm new to command line, is this guide suitable?

**A:** This guide assumes basic command line familiarity. Consider completing a basic Linux tutorial before starting.

### Q: How long does the setup take?

**A:**

- Manual setup: 30-60 minutes
- Cloud-Init automated setup: 10-15 minutes
- Learning curve: 1-2 hours for new users

### Q: What if I need help?

**A:**

1. Check the [Troubleshooting Guide](troubleshooting.md)
2. Review the [References](references.md) for additional resources
3. Ensure you follow the setup steps sequentially
4. Document your specific configuration for easier debugging
