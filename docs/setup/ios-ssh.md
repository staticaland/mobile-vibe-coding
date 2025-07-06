# iOS SSH setup

## SSH clients

Choose an SSH client for iOS:

### **Termius²** (Free/Pro)

Cross-platform SSH client with:

- Mosh protocol for reliable mobile connections
- Custom keyboard layouts for development
- Authentication across devices
- Sync across platforms

### **Blink Shell³** ($20)

Professional terminal with:

- Native mosh integration
- VS Code and GitHub Codespaces support
- External keyboard compatibility
- Advanced terminal features

### **1Password**

Secure key management with:

- SSH key generation
- Encrypted storage and sync
- Integration with SSH clients

## Generate SSH keys

Create SSH keys using your chosen iOS app:

### Method 1: Termius (recommended)

1. Go to **Termius** → **Settings** → **Keychain**
2. Select **"+"** → **Add Key** → **Generate**
3. Set key options:
   - **Key type**: Ed25519[^6] (recommended for security)
   - **Label**: "iOS Development Key"
4. Copy the public key for server setup

!!! tip "Key deployment"
For automated key deployment, see the [official Termius documentation](https://termius.com/documentation/copy-ssh-key-to-server).

### Method 2: Blink Shell

Generate keys in the terminal:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub  # Display public key for copying
```

Deploy keys with the built-in utility:

```bash
ssh-copy-id your-key-name user@your-server.com
```

!!! note "Key reference"
Replace `your-key-name` with the actual key name from Blink Shell. For ssh-copy-id usage, see the [official Blink documentation](https://docs.blink.sh/basics/commands#ssh-copy-id).

### Method 3: 1Password

1. Open **1Password** → **Create** → **SSH Key**
2. Set key options:
   - **Name**: "Development SSH Key"
   - **Key type**: Ed25519
3. Save the key and copy the public key
