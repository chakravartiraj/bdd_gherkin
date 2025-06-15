#!/bin/bash

# Show help
show_help() {
    cat << EOF
Test Coverage Script

Usage: $0 [options]

This script runs Flutter tests with coverage analysis and generates
both text and HTML coverage reports.

Options:
  -h, --help     Show this help message
  --html-only    Generate only HTML report (skip text summary)

Examples:
  $0             # Run tests with coverage and show summary
  $0 --html-only # Generate HTML report only

The script will:
1. Run 'flutter test --coverage'
2. Generate coverage report in coverage/lcov.info
3. Show coverage summary (if LCOV available)
4. Generate HTML report in coverage/html/ (if genhtml available)

EOF
}

# Parse command line arguments
HTML_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --html-only)
            HTML_ONLY=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Main execution
echo "🧪 Running tests with coverage..."
flutter test --coverage

if [ -f "coverage/lcov.info" ]; then
    if [ "$HTML_ONLY" = false ]; then
        echo ""
        echo "📊 Coverage Summary:"
        if command -v lcov &> /dev/null; then
            lcov --summary coverage/lcov.info
        else
            echo "Install LCOV for detailed coverage: sudo apt install lcov"
        fi
    fi
    
    # Generate HTML report
    if command -v genhtml &> /dev/null; then
        echo "Generating HTML report..."
        genhtml coverage/lcov.info -o coverage/html/ 2>/dev/null || true
        if [ -f "coverage/html/index.html" ]; then
            echo "📊 HTML report: coverage/html/index.html"
        fi
    fi
else
    echo "❌ No coverage data generated"
fi
