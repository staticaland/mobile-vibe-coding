# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a documentation project for setting up mobile development environments using Claude Code. It's built using MkDocs with Material theme and provides guides for coding from iOS devices using VPS servers.

## Development Commands

### Dependencies and Environment

```bash
# Install dependencies using uv
just install
# or
uv sync
```

### Documentation Site

```bash
# Serve site locally for development (available at http://localhost:8000)
just serve

# Build the documentation site
just build

# Deploy to GitHub Pages
just deploy

# Clean build artifacts
just clean
```

### Code Quality

```bash
# Format all markdown files with Prettier
just format-md
```

### GitHub Integration

```bash
# Work on a specific GitHub issue
just issue <ISSUE_NUMBER>

# List all open GitHub issues
just issues
```

## Architecture

### Project Structure

- `docs/` - MkDocs documentation source files
  - `index.md` - Main documentation page
  - `setup/` - Setup guides (iOS SSH, VPS, dev environment, etc.)
  - `references.md` - Reference materials
- `scripts/` - Shell scripts for automation
  - `gh-issue.sh` - GitHub issue management with fzf integration
- `main.py` - Simple Python entry point (minimal)
- `justfile` - Task runner with all development commands
- `mkdocs.yml` - MkDocs configuration
- `pyproject.toml` - Python project configuration (uses uv for dependency management)

### Key Components

**Documentation System**: Built with MkDocs Material theme, featuring:

- Responsive design with light/dark mode toggle
- Navigation tabs and sections
- Code syntax highlighting
- Search functionality

**GitHub Integration**: Custom script (`scripts/gh-issue.sh`) provides:

- Interactive issue selection with fzf
- Direct integration with Claude Code
- Issue content formatting for development workflow

**Build System**: Uses `just` as the task runner with targets for:

- Local development server
- Site building and deployment
- Code formatting
- GitHub workflow integration

## Development Notes

- The project uses `uv` for Python dependency management
- All development commands are centralized in the `justfile`
- The site is configured to deploy to GitHub Pages
- The `gh-issue.sh` script integrates with Claude Code for issue-driven development
- Documentation is served on `0.0.0.0:8000` to allow access from remote connections (important for VPS development)

## Workflow Guidance

- Always run the justfile target after creating or changing gha workflows