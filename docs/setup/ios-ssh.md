# iOS SSH Setup

## iOS SSH Clients

**Recommended iOS Apps:**
- **Termius²** (Free/Pro) - Cross-platform SSH client with mosh support, custom keyboards, and seamless authentication
- **Blink Shell³** ($20) - Professional terminal with mosh integration, VS Code/Codespaces support, and external keyboard compatibility
- **1Password** - SSH key generation and management

## Generate SSH Keys on iOS

You can generate SSH keys using several iOS apps:

### Using Termius (Recommended)
1. Open Termius → Settings → Keychain
2. Tap "+" → Add Key → Generate
3. Key type: Ed25519[^6]
4. Label: "iOS Development Key"
5. Copy the public key for VPS setup

### Using Blink Shell
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub  # Copy this public key
```

### Using 1Password
1. Open 1Password → Create → SSH Key
2. Name: "Development SSH Key"
3. Key type: Ed25519
4. Save and copy public key