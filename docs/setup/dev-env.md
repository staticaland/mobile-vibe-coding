# Development Environment Setup

## Install GitHub CLI

Follow the [GitHub CLI installation instructions](https://github.com/cli/cli) for your platform.

```bash
# Authenticate with GitHub
gh auth login[^7]
# Follow prompts: GitHub.com → HTTPS → Authenticate via web browser
```

## Install Claude Code

See the [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code/overview) for installation instructions.

## Project Bootstrapping with GitHub CLI

### Prerequisites

- VPS with GitHub CLI installed and authenticated
- SSH access from iOS device
- Claude Code installed and configured

### 1. Create GitHub Repository

```bash
# Initialize git if not already done
git init

# Create GitHub repo from current directory (name defaults to directory name)
gh repo create --source=. --public
```

### 2. Create README (Optional)

```bash
# Create a basic README file
echo "# Your Project Name" > README.md
echo "" >> README.md
echo "Project description goes here." >> README.md
```

### 3. Configure Git with GitHub CLI

```bash
# Setup git authentication with GitHub
gh auth setup-git

# Set git user info from GitHub account (globally)
git config --global user.name "$(gh api user --jq .name)"
git config --global user.email "$(gh api user --jq .email)"

# Set default repository for easier operations
gh repo set-default owner/repo-name
```