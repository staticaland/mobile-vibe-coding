# Port Forwarding Configuration

Port forwarding enables secure access to services running on your remote development server from your local iOS device.

## Protocol Limitations

### **Mosh Constraints**

Mosh protocol has inherent limitations regarding port forwarding:

- **No SSH Tunnel Support**: Mosh cannot establish SSH tunnels directly
- **No Bastion Host Capability**: Fundamental protocol limitation
- **UDP-Based**: Different architecture than SSH's TCP-based tunneling

## Implementation Strategies

### **Method 1: Hybrid SSH + Mosh (Recommended)**

Combine SSH tunneling with Mosh connections for optimal mobile development:

**Step 1: Establish SSH Tunnel**

```bash
# Create port forwarding tunnel (runs in background)
ssh -L 8000:localhost:8000 -N user@server
```

**Step 2: Connect via Mosh**

```bash
# Connect to server via Mosh (separate connection)
mosh user@server
```

This approach provides:

- **Persistent Tunneling**: SSH handles port forwarding
- **Mobile Resilience**: Mosh provides connection stability
- **Concurrent Operation**: Both connections run simultaneously

### **Method 2: Direct SSH Port Forwarding**

For scenarios requiring persistent port forwarding:

```bash
# SSH with port forwarding (blocking connection)
ssh -L 8000:localhost:8000 user@server
```

Use this method when:

- Port forwarding is critical to your workflow
- You need guaranteed tunnel persistence
- Mobile connection stability is less important

## **Configuration Examples**

### **Development Server Access**

Forward common development ports:

```bash
# Forward web development server
ssh -L 3000:localhost:3000 -N user@server

# Forward database connections
ssh -L 5432:localhost:5432 -N user@server

# Forward API development
ssh -L 8080:localhost:8080 -N user@server
```

### **Multiple Port Forwarding**

```bash
# Forward multiple ports simultaneously
ssh -L 3000:localhost:3000 \
    -L 5432:localhost:5432 \
    -L 8080:localhost:8080 \
    -N user@server
```

## **Best Practices**

- **Use SSH for Port Forwarding**: Leverage SSH's proven tunneling capabilities
- **Separate Connections**: Maintain independent SSH and Mosh connections
- **Background Tunnels**: Use `-N` flag for dedicated tunneling connections
- **Security**: Only forward ports that require external access
