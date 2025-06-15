#!/bin/bash

# Show help
show_help() {
    cat << EOF
Coverage Watch Script - Auto-run coverage when files change

Usage: $0 [options]

This script monitors your lib/ and test/ directories for changes
and automatically runs coverage analysis when files are modified.

Options:
  -h, --help     Show this help message

Examples:
  $0             # Start watching for file changes

Requirements:
  - inotify-tools (Linux): sudo apt install inotify-tools
  
The script will:
1. Monitor lib/ and test/ directories for changes
2. Run quick coverage check when files are modified
3. Display results and continue watching

Press Ctrl+C to stop watching.

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
echo "👀 Watching for changes... Press Ctrl+C to stop"

if command -v inotifywait &> /dev/null; then
    while inotifywait -r -e modify lib/ test/; do
        echo "🔄 Files changed, running tests..."
        ./scripts/coverage-quick.sh --quiet
        echo "✅ Coverage check complete"
        echo ""
    done
else
    echo "Install inotify-tools for file watching: sudo apt install inotify-tools"
    echo "Run: sudo apt install inotify-tools"
fi
