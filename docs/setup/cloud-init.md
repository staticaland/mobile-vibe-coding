# Automated server provisioning with cloud-init

Cloud-init automates server configuration during initial provisioning. Skip manual setup steps and ensure consistent, reproducible deployments.

## Cloud-init configuration

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

## Using cloud-init

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

## Advantages of cloud-init

Cloud-init provides key benefits for development environment setup:

- **Consistent configuration**: Identical setup across all deployments
- **Zero manual intervention**: Server ready immediately after boot
- **Version control**: Track infrastructure changes in version control
- **Reproducible environments**: Easily recreate identical development setups
- **Security by default**: Automated security hardening from initial boot
- **Time efficiency**: Reduces setup time from hours to minutes

## Configuration customization

Customize the cloud-config.yaml file before deploying:

### Required modifications

1. **SSH key**: Replace the example SSH key with your actual public key
2. **Username**: Modify the `developer` username if desired
3. **Additional packages**: Add any specific packages required for your workflow
4. **Firewall rules**: Adjust security rules based on your specific requirements

### Advanced customization

- **Service configuration**: Add systemd service definitions
- **Environment variables**: Set development environment variables
- **Cron jobs**: Configure scheduled tasks
- **File permissions**: Set specific file and directory permissions

The server will be fully configured and ready for development work within minutes, with all dependencies installed and security measures in place.
