# Cloud-Init for Automated Setup

For a more automated server setup, use cloud-init to configure your VPS during initial provisioning. This eliminates manual setup steps and ensures consistent configuration.

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

## Benefits of Cloud-Init

- **Consistent Setup**: Same configuration every time
- **Zero Manual Steps**: Server ready immediately after boot
- **Version Control**: Track infrastructure changes in git
- **Reproducible**: Easily recreate identical environments
- **Security**: Automated security hardening from day one

## Customization

Before using, update the cloud-config.yaml:

1. Replace the SSH key with your actual public key
2. Modify the `developer` username if desired
3. Add any additional packages or configuration needed
4. Adjust firewall rules for your specific requirements

The server will be fully configured and ready for development work within minutes of creation.
