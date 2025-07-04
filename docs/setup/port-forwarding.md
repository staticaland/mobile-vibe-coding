# Port Forwarding with Mosh

Port forwarding with Mosh has some important limitations. Here's what you need to know:

## **The Challenge:**

Mosh has no concepts of SSH tunnels or bastion hosts - this is a fundamental limitation of the Mosh protocol itself.

## **Workaround in Blink Shell:**

### **Method 1: SSH Tunnel + Mosh (Recommended)**

You can run a SSH tunnel in a different window. Once the SSH tunnel is established and the remote port brought to your machine, you can use `mosh localhost:1234` where 1234 is the port you tunneled, to connect via the SSH tunnel to Mosh.

**Steps:**

1. **First terminal:** Set up SSH tunnel with port forwarding
   
   ```bash
   ssh -L 8000:localhost:8000 -N user@server
   ```

2. **Second terminal:** Connect via Mosh through the tunnel
   
   ```bash
   mosh localhost
   ```

### **Method 2: Direct SSH for Port Forwarding**

If you need persistent port forwarding, you might need to use SSH directly instead of Mosh:

```bash
ssh -L 8000:localhost:8000 user@server
```

## **Key Points:**

- Mosh cannot establish SSH tunnels directly
- Use separate SSH connections for port forwarding
- The tunnel and Mosh connection can run simultaneously
- Consider using SSH when port forwarding is essential