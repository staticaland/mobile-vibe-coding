# Scripts

This directory contains utility scripts for the project.

## enable-pages.sh

A script that uses the GitHub CLI to enable GitHub Pages with GitHub Actions as the source.

### Prerequisites

- [GitHub CLI](https://cli.github.com/) installed and authenticated
- `jq` installed for JSON processing
- Repository must be public (or you need GitHub Pro/Team for private repos)

### Usage

```bash
# Run from the repository root
./scripts/enable-pages.sh
```

### What it does

1. **Checks prerequisites**: Verifies GitHub CLI is installed and authenticated
2. **Gets repository info**: Identifies the current repository
3. **Checks Pages status**: Determines if Pages is already enabled and configured
4. **Enables/Updates Pages**:
   - If Pages is disabled: Enables it with GitHub Actions as source
   - If Pages is enabled with wrong source: Updates it to use GitHub Actions
   - If Pages is already correctly configured: Reports success

### Output

The script provides colored output showing:

- ✅ Success messages in green
- ⚠️ Warnings in yellow
- ℹ️ Info messages in blue
- ❌ Errors in red

### Example output

```
🚀 GitHub Pages Setup Script
================================
[SUCCESS] GitHub CLI is installed and authenticated
[INFO] Repository: username/repo-name
[INFO] Checking current Pages status...
[INFO] GitHub Pages is not currently enabled
[INFO] Enabling GitHub Pages with GitHub Actions as source...
[SUCCESS] GitHub Pages enabled successfully!
[SUCCESS] Pages URL: https://username.github.io/repo-name

[SUCCESS] Setup complete! 🎉
[INFO] Your GitHub Actions workflow will now be able to deploy to Pages.
[INFO] Push your workflow to the main branch to trigger the first deployment.
```

### API Endpoints Used

- `GET /repos/{owner}/{repo}/pages` - Check Pages status
- `POST /repos/{owner}/{repo}/pages` - Enable Pages
- `PUT /repos/{owner}/{repo}/pages` - Update Pages configuration

### Error Handling

The script handles common issues:

- GitHub CLI not installed or authenticated
- Repository not found or no GitHub remote
- Insufficient permissions
- Private repository without GitHub Pro/Team
- Pages already enabled with different configuration
