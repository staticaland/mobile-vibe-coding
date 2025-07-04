# Automated Server Provisioning with Cloud-Init

Cloud-Init provides automated server configuration during initial provisioning, eliminating manual setup steps and ensuring consistent, reproducible deployments.

## Cloud-Init Configuration

Create a `cloud-config.yaml` file:

```yaml
#cloud-config
package_update: true
package_upgrade: true

packages:
  - mosh
  - tmux
  - curl
  - git
  - build-essential

users:
  - name: developer
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: [sudo]
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGExampleKeyDataHere your-email@example.com

write_files:
  - path: /home/developer/.ssh/config
    content: |
      Host *
          ServerAliveInterval 60
          ServerAliveCountMax 3
    owner: developer:developer
    permissions: "0600"
  - path: /etc/ssh/sshd_config.d/99-custom.conf
    content: |
      PermitRootLogin no
      PasswordAuthentication no
      PubkeyAuthentication yes
      Port 2222
    permissions: "0644"

runcmd:
  - systemctl restart sshd
  - ufw allow 2222/tcp
  - ufw allow 60000:61000/udp # Mosh port range
  - ufw --force enable
  - curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  - apt update
  - apt install -y gh
  - chown -R developer:developer /home/developer/.ssh
```

## Using Cloud-Init

### Digital Ocean

```bash
# Create droplet with cloud-init
doctl compute droplet create my-dev-server \
  --image ubuntu-22-04-x64 \
  --size s-1vcpu-1gb \
  --region nyc3 \
  --user-data-file cloud-config.yaml
```

### AWS EC2

```bash
# Launch instance with cloud-init
aws ec2 run-instances \
  --image-id ami-0c7217cdde317cfec \
  --instance-type t2.micro \
  --user-data file://cloud-config.yaml \
  --security-group-ids sg-12345678
```

### Manual Upload

Most VPS providers allow uploading cloud-init files during instance creation through their web interfaces.

## Advantages of Cloud-Init

Cloud-Init provides several key benefits for development environment setup:

- **Consistent Configuration**: Identical setup across all deployments
- **Zero Manual Intervention**: Server ready immediately after boot completion
- **Version Control**: Track infrastructure changes in version control
- **Reproducible Environments**: Easily recreate identical development setups
- **Security by Default**: Automated security hardening from initial boot
- **Time Efficiency**: Reduces setup time from hours to minutes

## Configuration Customization

Before deploying, customize the cloud-config.yaml file:

### Required Modifications

1. **SSH Key**: Replace the example SSH key with your actual public key
2. **Username**: Modify the `developer` username if desired
3. **Additional Packages**: Add any specific packages required for your workflow
4. **Firewall Rules**: Adjust security rules based on your specific requirements

### Advanced Customization

- **Service Configuration**: Add systemd service definitions
- **Environment Variables**: Set development environment variables
- **Cron Jobs**: Configure scheduled tasks
- **File Permissions**: Set specific file and directory permissions

The server will be fully configured and ready for productive development work within minutes of creation, with all dependencies installed and security measures in place.
