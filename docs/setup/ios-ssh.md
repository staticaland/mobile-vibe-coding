# iOS SSH Configuration

## Recommended SSH Clients

Choose from these professional iOS SSH clients based on your needs:

### **Termius²** (Free/Pro)

Cross-platform SSH client featuring:

- Mosh protocol support for reliable mobile connections
- Custom keyboard layouts for development
- Seamless authentication across devices
- Synchronization across platforms

### **Blink Shell³** ($20)

Professional terminal application with:

- Native mosh integration
- VS Code and GitHub Codespaces support
- External keyboard compatibility
- Advanced terminal features

### **1Password**

Secure key management with:

- SSH key generation capabilities
- Encrypted storage and synchronization
- Integration with SSH clients

## SSH Key Generation

Generate SSH keys using your preferred iOS application following these standardized procedures:

### Method 1: Termius (Recommended)

1. Navigate to **Termius** → **Settings** → **Keychain**
2. Select **"+"** → **Add Key** → **Generate**
3. Configure key parameters:
   - **Key type**: Ed25519[^6] (recommended for security)
   - **Label**: "iOS Development Key"
4. Copy the generated public key for server configuration

!!! tip "Key Deployment"
For automated key deployment to your server, refer to the [official Termius documentation](https://termius.com/documentation/copy-ssh-key-to-server).

### Method 2: Blink Shell

Generate keys using the integrated terminal:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub  # Display public key for copying
```

Deploy keys using the built-in utility:

```bash
ssh-copy-id your-key-name user@your-server.com
```

!!! note "Key Reference"
Replace `your-key-name` with the actual key name assigned in Blink Shell. For comprehensive ssh-copy-id usage and troubleshooting, consult the [official Blink documentation](https://docs.blink.sh/basics/commands#ssh-copy-id).

### Method 3: 1Password

1. Open **1Password** → **Create** → **SSH Key**
2. Configure key settings:
   - **Name**: "Development SSH Key"
   - **Key type**: Ed25519
3. Save the key and copy the public key portion
