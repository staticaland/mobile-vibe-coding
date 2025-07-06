# VPS Configuration

## Cloud Provider Selection

Choose a VPS provider:

### Digital Ocean (Recommended)

**Setup:**

1. Go to https://cloud.digitalocean.com/
2. Select **Create Droplets** → **Ubuntu 22.04 LTS**
3. Choose **Basic plan** ($4-6/month for development workloads)
4. **Add SSH Key**: Paste your public key from iOS SSH application[^5]
5. **Create Droplet** and note the assigned IP address

### AWS EC2

**Setup:**

1. Go to https://aws.amazon.com/ec2/
2. Select **Launch Instance** → **Ubuntu Server 22.04 LTS**
3. Choose **t2.micro** (eligible for free tier)
4. Configure security group rules (allow SSH port 22)
5. Upload your SSH public key
6. **Launch instance** and record connection details

### Alternative Providers

Compare these cost-effective options:

| Provider    | Starting Price | Notable Features                          |
| ----------- | -------------- | ----------------------------------------- |
| **Linode**  | $5/month       | Excellent performance, global locations   |
| **Vultr**   | $2.50/month    | Competitive pricing, SSD storage          |
| **Hetzner** | €3.29/month    | European focus, high-performance hardware |

## Server Configuration

### Initial System Setup

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

### iOS Connection Configuration

Configure your iOS SSH client:

**Connection details:**

```
Host: your-vps-ip-address
Port: 22 (default) or 2222 (if modified)
Username: developer (or root for initial setup)
Authentication: SSH Key (from your iOS keychain)
Protocol: SSH or Mosh (recommended for mobile usage)
```

### Mobile-Optimized Connections

#### **Mosh Protocol (Recommended)**

Mosh provides better mobile connectivity:

- **Network Roaming**: Automatic reconnection when switching networks
- **Local Echo**: Immediate response for better typing experience
- **Connection Resilience**: Maintains sessions during device sleep/wake cycles
- **UDP-Based**: More efficient than TCP for mobile connections

**Client Configuration:**

| Client          | Mosh Support     | Additional Features            |
| --------------- | ---------------- | ------------------------------ |
| **Termius**     | Native support   | Better connectivity management |
| **Blink Shell** | Full integration | Automatic reconnection         |

#### **Persistent Sessions**

Configure automatic session management:

```bash
# Set startup command in your SSH client
tmux new-session -A -s main
```

### Connection Verification

Test your setup:

1. **Open your iOS SSH client** (Termius, Blink Shell, etc.)
2. **Create new host** using your VPS IP address
3. **Select SSH key** from the application's keychain
4. **Choose Mosh protocol** if available
5. **Connect and verify** successful authentication

## Security Configuration

### SSH Hardening

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

!!! warning "Security Considerations"
For comprehensive server hardening, consult the [complete security guide¹](../references.md#references) which covers firewall configuration, intrusion detection, system monitoring, and additional security measures.

### Connection Optimization

Configure persistent connections:

**Server-side SSH Configuration:**

```bash
# Edit SSH client configuration
vim ~/.ssh/config

# Add connection optimization
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

**Firewall Configuration:**

```bash
# Configure UFW firewall
sudo ufw allow 2222/tcp          # SSH port
sudo ufw allow 60000:61000/udp   # Mosh port range
sudo ufw --force enable
```
