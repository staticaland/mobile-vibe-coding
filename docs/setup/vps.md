# VPS configuration

## Cloud provider selection

Choose a VPS provider:

### Digital Ocean (recommended)

**Setup:**

1. Go to https://cloud.digitalocean.com/
2. Select **Create Droplets** → **Ubuntu 22.04 LTS**
3. Choose **Basic plan** ($4-6/month for development)
4. **Add SSH Key**: Paste your public key from iOS SSH app[^5]
5. **Create Droplet** and note the IP address

### AWS EC2

**Setup:**

1. Go to https://aws.amazon.com/ec2/
2. Select **Launch Instance** → **Ubuntu Server 22.04 LTS**
3. Choose **t2.micro** (free tier eligible)
4. Configure security group rules (allow SSH port 22)
5. Upload your SSH public key
6. **Launch instance** and record connection details

### Alternative providers

Compare these cost-effective options:

| Provider    | Starting Price | Notable Features                          |
| ----------- | -------------- | ----------------------------------------- |
| **Linode**  | $5/month       | Excellent performance, global locations   |
| **Vultr**   | $2.50/month    | Competitive pricing, SSD storage          |
| **Hetzner** | €3.29/month    | European focus, high-performance hardware |

## Server configuration

### Initial setup

Run these commands:

```bash
# Update system packages
apt update && apt upgrade -y

# Install essential packages
apt install -y mosh tmux curl git build-essential

# Create development user account
adduser developer
usermod -aG sudo developer

# Transfer SSH keys to new user
rsync --archive --chown=developer:developer ~/.ssh /home/developer
```

### iOS connection setup

Configure your iOS SSH client:

**Connection details:**

```
Host: your-vps-ip-address
Port: 22 (default) or 2222 (if modified)
Username: developer (or root for initial setup)
Authentication: SSH Key (from your iOS keychain)
Protocol: SSH or Mosh (recommended for mobile)
```

### Mobile-optimized connections

#### **Mosh protocol (recommended)**

Mosh provides better mobile connectivity:

- **Network roaming**: Automatic reconnection when switching networks
- **Local echo**: Immediate response for better typing
- **Connection resilience**: Maintains sessions during device sleep/wake cycles
- **UDP-based**: More efficient than TCP for mobile connections

**Client configuration:**

| Client          | Mosh Support     | Additional Features            |
| --------------- | ---------------- | ------------------------------ |
| **Termius**     | Native support   | Better connectivity management |
| **Blink Shell** | Full integration | Automatic reconnection         |

#### **Persistent sessions**

Configure automatic session management:

```bash
# Set startup command in your SSH client
tmux new-session -A -s main
```

### Connection verification

Test your setup:

1. **Open your iOS SSH client** (Termius, Blink Shell, etc.)
2. **Create new host** using your VPS IP address
3. **Select SSH key** from the app's keychain
4. **Choose Mosh protocol** if available
5. **Connect and verify** successful authentication

## Security configuration

### SSH hardening

Secure your server:

```bash
# Edit SSH daemon configuration
sudo vim /etc/ssh/sshd_config

# Apply security settings:
# Port 2222                    # Change default port
# PermitRootLogin no          # Disable root login
# PasswordAuthentication no   # Use keys only
# PubkeyAuthentication yes    # Enable key authentication

# Restart SSH service to apply changes
sudo systemctl restart sshd
```

!!! warning "Security considerations"
For comprehensive server hardening, consult the [complete security guide¹](../references.md#references) which covers firewall configuration, intrusion detection, system monitoring, and additional security measures.

### Connection optimization

Configure persistent connections:

**Server-side SSH configuration:**

```bash
# Edit SSH client configuration
vim ~/.ssh/config

# Add connection optimization
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

**Firewall configuration:**

```bash
# Configure UFW firewall
sudo ufw allow 2222/tcp          # SSH port
sudo ufw allow 60000:61000/udp   # Mosh port range
sudo ufw --force enable
```
