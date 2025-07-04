# Development Environment Setup

## GitHub CLI Installation

Install and configure GitHub CLI for seamless repository management:

```bash
# Install GitHub CLI (Ubuntu/Debian)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
```

**Authentication Process:**

```bash
# Authenticate with GitHub
gh auth login[^7]
# Follow prompts: GitHub.com → HTTPS → Authenticate via web browser
```

## Claude Code Installation

Install Claude Code following the [official documentation](https://docs.anthropic.com/en/docs/claude-code/overview).

**Installation verification:**

```bash
# Verify installation
claude --version
```

## Project Bootstrapping Workflow

### Prerequisites Checklist

Before proceeding, ensure you have:

- ✅ VPS with GitHub CLI installed and authenticated
- ✅ SSH access configured from iOS device
- ✅ Claude Code installed and configured
- ✅ Git installed and configured

### Repository Creation Process

#### 1. Initialize Git Repository

```bash
# Initialize git repository
git init

# Create GitHub repository from current directory
gh repo create --source=. --public
```

#### 2. Project Documentation (Optional)

```bash
# Create basic README file
echo "# Your Project Name" > README.md
echo "" >> README.md
echo "Project description goes here." >> README.md
```

#### 3. Git Configuration

```bash
# Configure git authentication with GitHub
gh auth setup-git

# Set git user information from GitHub account
git config --global user.name "$(gh api user --jq .name)"
git config --global user.email "$(gh api user --jq .email)"

# Set default repository for streamlined operations
gh repo set-default owner/repo-name
```

### Workflow Verification

Test your setup with these commands:

```bash
# Verify GitHub authentication
gh auth status

# Check git configuration
git config --list | grep user

# Test repository access
gh repo view
```
