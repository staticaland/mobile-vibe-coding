# Troubleshooting Guide

Common issues and solutions for mobile development environment setup.

## SSH Connection Issues

### Problem: Unable to connect to VPS

**Symptoms:**

- Connection timeout
- "Connection refused" error
- Authentication failures

**Solutions:**

1. **Verify SSH service status**

   ```bash
   sudo systemctl status ssh
   sudo systemctl start ssh  # If not running
   ```

2. **Check firewall configuration**

   ```bash
   sudo ufw status
   sudo ufw allow ssh  # If SSH port is blocked
   ```

3. **Validate SSH key configuration**
   ```bash
   # On server
   cat ~/.ssh/authorized_keys
   # Ensure your public key is present
   ```

### Problem: SSH key authentication fails

**Symptoms:**

- Password prompt instead of key authentication
- "Permission denied (publickey)" error

**Solutions:**

1. **Verify key permissions**

   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```

2. **Check SSH daemon configuration**

   ```bash
   sudo grep -E "(PubkeyAuthentication|PasswordAuthentication)" /etc/ssh/sshd_config
   # Ensure: PubkeyAuthentication yes
   ```

3. **Validate key format**
   ```bash
   ssh-keygen -l -f ~/.ssh/id_ed25519.pub
   # Should show valid key fingerprint
   ```

## Mosh Connection Issues

### Problem: Mosh connection fails

**Symptoms:**

- "mosh: command not found"
- Connection hangs after initial SSH handshake
- Firewall blocking UDP traffic

**Solutions:**

1. **Install Mosh on server**

   ```bash
   sudo apt update && sudo apt install -y mosh
   ```

2. **Configure firewall for Mosh**

   ```bash
   sudo ufw allow 60000:61000/udp
   ```

3. **Verify Mosh server is running**
   ```bash
   which mosh-server
   # Should return path to mosh-server
   ```

## GitHub CLI Issues

### Problem: GitHub authentication fails

**Symptoms:**

- "gh: command not found"
- Authentication token errors
- Permission denied for repository operations

**Solutions:**

1. **Install GitHub CLI**

   ```bash
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
   sudo apt update && sudo apt install -y gh
   ```

2. **Re-authenticate with GitHub**

   ```bash
   gh auth logout
   gh auth login
   ```

3. **Verify authentication status**
   ```bash
   gh auth status
   ```

## Port Forwarding Issues

### Problem: Port forwarding not working

**Symptoms:**

- Unable to access forwarded ports
- Connection refused on forwarded ports
- Services not accessible from iOS device

**Solutions:**

1. **Verify service is running**

   ```bash
   sudo netstat -tlnp | grep :8000
   # Replace 8000 with your port
   ```

2. **Check SSH tunnel status**

   ```bash
   ps aux | grep ssh
   # Look for your tunnel process
   ```

3. **Test local connectivity**
   ```bash
   # On server
   curl localhost:8000
   # Should connect to your service
   ```

## iOS Client Issues

### Problem: iOS SSH client connection issues

**Symptoms:**

- Keyboard input lag
- Frequent disconnections
- Screen rendering issues

**Solutions:**

1. **Enable Mosh protocol**
   - Switch from SSH to Mosh in client settings
   - Verify Mosh is installed on server

2. **Configure session persistence**

   ```bash
   # Set as startup command in iOS client
   tmux new-session -A -s main
   ```

3. **Optimize connection settings**
   ```bash
   # Add to ~/.ssh/config on server
   Host *
       ServerAliveInterval 60
       ServerAliveCountMax 3
   ```

## Performance Issues

### Problem: Slow response times

**Symptoms:**

- Delayed command execution
- Slow file operations
- Poor interactive performance

**Solutions:**

1. **Check server resources**

   ```bash
   htop
   df -h
   free -h
   ```

2. **Optimize SSH compression**

   ```bash
   # Add to ~/.ssh/config
   Host your-server
       Compression yes
       CompressionLevel 6
   ```

3. **Use local caching**
   ```bash
   # Enable SSH connection multiplexing
   Host *
       ControlMaster auto
       ControlPath ~/.ssh/control-%r@%h:%p
       ControlPersist 10m
   ```

## General Debugging

### Enable verbose logging

**SSH debugging:**

```bash
ssh -v user@server
# Use -vv or -vvv for more detailed output
```

**Mosh debugging:**

```bash
mosh --ssh="ssh -v" user@server
```

### Check system logs

**SSH logs:**

```bash
sudo journalctl -u ssh
```

**System logs:**

```bash
sudo journalctl -f
```

## Getting Help

If you encounter issues not covered in this guide:

1. **Check the [References](references.md)** for additional resources
2. **Review server logs** for specific error messages
3. **Test individual components** to isolate the problem
4. **Document your configuration** for easier troubleshooting

## Common Command Reference

**Quick diagnostic commands:**

```bash
# System status
systemctl status ssh
systemctl status ufw

# Network connectivity
ping google.com
netstat -tlnp

# SSH configuration
ssh -T git@github.com
gh auth status

# File permissions
ls -la ~/.ssh/
```
