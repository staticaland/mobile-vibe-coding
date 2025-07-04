# Build and serve MkDocs site

# Install dependencies
install:
    uv sync

# Serve site locally for development
serve:
    uv run mkdocs serve --dev-addr 0.0.0.0:8000

# Build the site
build:
    uv run mkdocs build

# Clean build artifacts
clean:
    rm -rf site/

# Deploy to GitHub Pages
deploy:
    uv run mkdocs gh-deploy

# Build and open site locally
dev: build
    open site/index.html

# Format all markdown files with Prettier
format-md:
    npx prettier --write "**/*.md"

# Work on a GitHub issue using interactive fzf selector
issue:
    ./scripts/gh-issue.sh

# List all open GitHub issues
issues:
    gh issue list --state open