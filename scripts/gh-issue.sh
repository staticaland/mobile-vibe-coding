#!/bin/bash
# GitHub issue management script

set -e

# Function to display usage
show_usage() {
    echo "Usage: $0 [issue_content]"
    echo "  With no arguments: Use fzf to select an issue interactively"
    echo "  With issue_content: Pass the content directly to Claude"
}

# Function to work on a specific issue using fzf
work_with_fzf() {
    # Get issues in a format suitable for fzf
    local selected_issue
    selected_issue=$(gh issue list --state open --json number,title,labels --template '{{range .}}#{{.number}}: {{.title}} {{range .labels}}[{{.name}}] {{end}}{{"\n"}}{{end}}' | fzf --prompt="Select issue: " --height=40% --reverse)
    
    if [[ -z "$selected_issue" ]]; then
        echo "No issue selected"
        exit 1
    fi
    
    # Extract issue number from the selected line
    local issue_number
    issue_number=$(echo "$selected_issue" | sed 's/^#\([0-9]*\):.*/\1/')
    
    echo "Selected issue #$issue_number"
    
    # Get the full issue content
    local issue_content
    issue_content=$(gh issue view "$issue_number" --json title,body,url --template '# {{.title}}

{{.body}}

Issue URL: {{.url}}')
    
    echo "Starting Claude with issue content..."
    claude "$issue_content"
}

# Main command handling
if [[ $# -eq 0 ]]; then
    # No arguments, use fzf
    work_with_fzf
elif [[ "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]]; then
    show_usage
else
    # Pass the first argument as issue content to Claude
    claude "$1"
fi