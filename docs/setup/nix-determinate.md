# Nix with Determinate Systems (Alternative Setup)

This guide presents an alternative approach to setting up your mobile development environment using Nix and Determinate Systems, offering reproducible and declarative environment management.

## When to Choose Nix

Consider Nix if you:

- Work with multiple projects requiring different tool versions
- Want guaranteed reproducible environments across team members
- Prefer declarative configuration over imperative setup
- Need to quickly spin up identical environments on new VPS instances
- Want to isolate project dependencies completely

## Installation

### Install Nix via Determinate Systems

On your VPS, run:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your shell and verify:

```bash
nix --version
```

## Project Environment Setup

### Create Development Environment

Add a `flake.nix` file to your project root:

```nix
{
  description = "Mobile development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core tools
            git
            gh
            curl
            
            # Python environment
            python3
            uv
            
            # Node.js
            nodejs_20
            
            # Documentation
            just
          ];
          
          shellHook = ''
            echo "🚀 Development environment ready!"
            echo "📦 Available: Python $(python3 --version | cut -d' ' -f2), Node $(node --version)"
          '';
        };
      });
}
```

### Using the Environment

Enter the development environment:

```bash
nix develop
```

All tools are now available with pinned versions.

## Automatic Environment Loading

### With direnv

Install direnv for automatic activation:

```bash
nix profile install nixpkgs#direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
```

Create `.envrc`:

```bash
use flake
```

Allow the environment:

```bash
direnv allow
```

Now the environment loads automatically when entering the project directory.

## Working with Existing Workflows

### Documentation Workflow

The existing `justfile` commands work seamlessly:

```bash
# Enter Nix environment
nix develop

# Use existing commands
just install
just serve
just build
just deploy
```

### GitHub Integration

GitHub CLI authentication works as documented:

```bash
# Same workflow as dev-env.md
gh auth login
git config --global user.name "$(gh api user --jq .name)"
git config --global user.email "$(gh api user --jq .email)"
```

### iOS SSH Integration

The Nix environment works perfectly with SSH from iOS:

1. SSH to your VPS
2. `cd` into your project
3. Enter environment with `nix develop` (or automatically with direnv)
4. Use `claude` and other development tools

## Specialized Environments

### Multiple Development Contexts

Create different environments for different tasks:

```nix
{
  devShells = {
    # Documentation (default)
    default = pkgs.mkShell {
      buildInputs = with pkgs; [ python3 uv nodejs_20 just ];
    };
    
    # Mobile development
    mobile = pkgs.mkShell {
      buildInputs = with pkgs; [
        android-studio
        gradle
        nodejs_20
        python3
        watchman
      ];
    };
  };
}
```

Access with:
```bash
nix develop          # Default environment
nix develop .#mobile # Mobile development environment
```

## Cloud-Init Integration

Add Nix installation to your cloud-init setup:

```yaml
#cloud-config
runcmd:
  # Install Nix
  - curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  
  # Configure for all users
  - echo 'source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >> /etc/bashrc
```

## Benefits of This Approach

### Reproducibility

- **Exact Tool Versions**: Every environment gets identical tool versions
- **Dependency Isolation**: Projects don't interfere with each other
- **Rollback Capability**: Easy to revert to previous working environments

### Team Consistency

- **Onboarding**: New team members get identical environments
- **CI/CD Integration**: Same environment locally and in CI
- **Cross-Platform**: Works identically across different VPS providers

### Development Efficiency

- **Fast Setup**: New VPS instances get complete environments quickly
- **Version Management**: Switch between different tool versions per project
- **Clean Environments**: No leftover dependencies from previous projects

## Comparison with Standard Setup

| Aspect | Standard Setup | Nix Setup |
|--------|----------------|-----------|
| **Tool Installation** | Manual package installation | Declarative in flake.nix |
| **Version Control** | Manual version management | Automatic pinning |
| **Environment Isolation** | Global packages | Per-project isolation |
| **Reproducibility** | "Works on my machine" | Guaranteed identical environments |
| **Setup Time** | Manual for each VPS | Instant with existing flake |
| **Rollback** | Manual restore | Built-in rollback capability |

## Getting Started

1. **Try It Out**: Add a `flake.nix` to an existing project
2. **Test Workflows**: Verify all `just` commands work in Nix environment
3. **Evaluate Benefits**: Compare setup time and consistency
4. **Decide**: Choose the approach that best fits your workflow

Both approaches achieve the same goal of mobile development from iOS devices - choose the one that matches your preferences for environment management.