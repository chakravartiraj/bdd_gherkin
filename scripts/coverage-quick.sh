#!/bin/bash

# Quick coverage check script

# Show help
show_help() {
    cat << EOF
Quick Coverage Check Script

Usage: $0 [options]

This script runs Flutter tests with coverage analysis and provides
a quick summary of code coverage.

Options:
  -h, --help     Show this help message
  -q, --quiet    Quiet mode (less output)

Examples:
  $0             # Run quick coverage check
  $0 --quiet     # Run with minimal output

The script will:
1. Run 'flutter test --coverage'
2. Generate coverage report in coverage/lcov.info
3. Show coverage summary if LCOV is available

EOF
}

# Parse command line arguments
QUIET_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -q|--quiet)
            QUIET_MODE=true
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
if [ "$QUIET_MODE" = false ]; then
    echo "🧪 Running quick coverage check..."
fi

# Run tests with coverage
flutter test --coverage

if [ -f "coverage/lcov.info" ]; then
    # Quick summary
    if [ "$QUIET_MODE" = false ]; then
        echo ""
        echo "📊 Coverage Summary:"
    fi
    if command -v lcov &> /dev/null; then
        lcov --summary coverage/lcov.info
    else
        if [ "$QUIET_MODE" = false ]; then
            echo "Install LCOV for detailed coverage analysis: sudo apt install lcov"
        fi
    fi
else
    echo "❌ No coverage data generated"
fi
