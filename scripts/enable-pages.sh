#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if gh CLI is installed and authenticated
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed. Please install it first."
        echo "Visit: https://cli.github.com/"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated. Please run 'gh auth login' first."
        exit 1
    fi

    print_success "GitHub CLI is installed and authenticated"
}

# Get repository information
get_repo_info() {
    if ! REPO_INFO=$(gh repo view --json owner,name 2>/dev/null); then
        print_error "Could not get repository information. Make sure you're in a Git repository with a GitHub remote."
        exit 1
    fi

    OWNER=$(echo "$REPO_INFO" | jq -r '.owner.login')
    REPO=$(echo "$REPO_INFO" | jq -r '.name')
    
    print_status "Repository: $OWNER/$REPO"
}

# Check if Pages is already enabled
check_pages_status() {
    print_status "Checking current Pages status..."
    
    if PAGES_INFO=$(gh api "/repos/$OWNER/$REPO/pages" 2>/dev/null); then
        SOURCE=$(echo "$PAGES_INFO" | jq -r '.source.branch // .source.path // "unknown"')
        URL=$(echo "$PAGES_INFO" | jq -r '.html_url // "unknown"')
        
        print_warning "GitHub Pages is already enabled"
        echo "  Source: $SOURCE"
        echo "  URL: $URL"
        
        # Check if it's using GitHub Actions
        if echo "$PAGES_INFO" | jq -e '.build_type == "workflow"' > /dev/null 2>&1; then
            print_success "Pages is already configured to use GitHub Actions"
            return 0
        else
            print_warning "Pages is enabled but not using GitHub Actions as source"
            return 1
        fi
    else
        print_status "GitHub Pages is not currently enabled"
        return 1
    fi
}

# Enable GitHub Pages with GitHub Actions as source
enable_pages() {
    print_status "Enabling GitHub Pages with GitHub Actions as source..."
    
    # Create the Pages configuration
    PAGES_CONFIG='{
        "source": {
            "branch": null,
            "path": null
        },
        "build_type": "workflow"
    }'
    
    if gh api --method POST "/repos/$OWNER/$REPO/pages" --input - <<< "$PAGES_CONFIG" > /dev/null 2>&1; then
        print_success "GitHub Pages enabled successfully!"
        
        # Get the Pages URL
        sleep 2  # Wait a moment for the API to update
        if PAGES_INFO=$(gh api "/repos/$OWNER/$REPO/pages" 2>/dev/null); then
            URL=$(echo "$PAGES_INFO" | jq -r '.html_url')
            print_success "Pages URL: $URL"
        fi
    else
        print_error "Failed to enable GitHub Pages"
        print_status "This might be because:"
        echo "  - Pages is already enabled"
        echo "  - Repository is private and you don't have GitHub Pro/Team"
        echo "  - Insufficient permissions"
        exit 1
    fi
}

# Update existing Pages to use GitHub Actions
update_pages_source() {
    print_status "Updating Pages to use GitHub Actions as source..."
    
    PAGES_CONFIG='{
        "source": {
            "branch": null,
            "path": null
        },
        "build_type": "workflow"
    }'
    
    if gh api --method PUT "/repos/$OWNER/$REPO/pages" --input - <<< "$PAGES_CONFIG" > /dev/null 2>&1; then
        print_success "GitHub Pages updated to use GitHub Actions!"
        
        # Get the updated Pages URL
        sleep 2  # Wait a moment for the API to update
        if PAGES_INFO=$(gh api "/repos/$OWNER/$REPO/pages" 2>/dev/null); then
            URL=$(echo "$PAGES_INFO" | jq -r '.html_url')
            print_success "Pages URL: $URL"
        fi
    else
        print_error "Failed to update GitHub Pages source"
        exit 1
    fi
}

# Main execution
main() {
    echo "🚀 GitHub Pages Setup Script"
    echo "================================"
    
    check_gh_cli
    get_repo_info
    
    if check_pages_status; then
        print_success "GitHub Pages is already properly configured!"
    else
        # Try to enable or update Pages
        if gh api "/repos/$OWNER/$REPO/pages" &> /dev/null; then
            # Pages exists but needs updating
            update_pages_source
        else
            # Pages doesn't exist, create it
            enable_pages
        fi
    fi
    
    echo ""
    print_success "Setup complete! 🎉"
    print_status "Your GitHub Actions workflow will now be able to deploy to Pages."
    print_status "Push your workflow to the main branch to trigger the first deployment."
}

# Run main function
main "$@"