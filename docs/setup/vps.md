# VPS Setup

## Create a VPS

### Digital Ocean (Recommended)
1. Go to https://cloud.digitalocean.com/
2. Create Droplets → Ubuntu 22.04 LTS
3. Choose Basic plan ($4-6/month)
4. **Add SSH Key**: Paste your public key from iOS SSH app[^5]
5. Create Droplet

### AWS EC2 Alternative
1. Go to https://aws.amazon.com/ec2/
2. Launch Instance → Ubuntu Server 22.04 LTS
3. Choose t2.micro (free tier eligible)
4. Configure security group (allow SSH port 22)
5. Upload your SSH public key
6. Launch instance

### Other VPS Providers
- **Linode**: $5/month basic plans
- **Vultr**: $2.50/month starting
- **Hetzner**: €3.29/month in EU

## Server Setup and iOS Access

### Initial Server Configuration
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

### iOS Connection Setup
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

### SSH Security Configuration
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

!!! note "Security Note"
    For comprehensive server hardening, see the complete security guide¹ which covers firewall configuration, intrusion detection, system monitoring, and additional security measures.

### iOS Connection Optimization
Add to `~/.ssh/config` on the server:
```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
```