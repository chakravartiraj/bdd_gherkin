#!/bin/bash
# Test Watch Script - Auto-run tests when files change
# Monitors lib/ and test/ directories for changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Print colored output
print_header() {
    echo -e "${BLUE}🎯 === $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️ $1${NC}"
}

print_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        print_error "This doesn't appear to be a Flutter project (no pubspec.yaml found)"
        echo "Please run this script from your Flutter project root directory."
        exit 1
    fi
}

# Check for required tools
check_tools() {
    if ! command -v inotifywait &> /dev/null; then
        print_error "inotifywait not found"
        echo ""
        echo "To install on Ubuntu/Debian:"
        echo "  sudo apt install inotify-tools"
        echo ""
        echo "To install on macOS:"
        echo "  brew install fswatch"
        echo ""
        echo "Alternative: Use 'flutter test --watch' (built-in Flutter option)"
        exit 1
    fi
}

# Show initial status
show_initial_status() {
    print_header "Test Watch Mode Started"
    echo ""
    print_info "👀 Monitoring directories:"
    echo "   📁 lib/ - Application code"
    echo "   📁 test/ - Test files"
    echo ""
    
    # Count files being watched
    local dart_files=$(find lib test -name "*.dart" 2>/dev/null | wc -l)
    local feature_files=$(find test -name "*.feature" 2>/dev/null | wc -l)
    
    echo "📊 Watching $dart_files Dart files"
    if [ "$feature_files" -gt 0 ]; then
        echo "📊 Watching $feature_files feature files"
    fi
    echo ""
    
    print_info "🎯 What triggers test runs:"
    echo "   • Saving any .dart file in lib/ or test/"
    echo "   • Saving any .feature file in test/"
    echo "   • Any file modification in watched directories"
    echo ""
    
    print_success "Ready! Make changes to your code to trigger tests..."
    echo ""
    print_warning "Press Ctrl+C to stop watching"
    echo ""
    echo "========================================"
    echo ""
}

# Run tests with smart output
run_tests_smart() {
    local timestamp=$(date '+%H:%M:%S')
    
    print_step "[$timestamp] Running tests..."
    echo ""
    
    # Use quick-test.sh if available, otherwise flutter test
    if [ -f "scripts/quick-test.sh" ]; then
        if ./scripts/quick-test.sh; then
            echo ""
            print_success "[$timestamp] ✅ All tests passed!"
        else
            echo ""
            print_error "[$timestamp] ❌ Some tests failed"
        fi
    else
        if flutter test --reporter=compact; then
            echo ""
            print_success "[$timestamp] ✅ All tests passed!"
        else
            echo ""
            print_error "[$timestamp] ❌ Some tests failed"
        fi
    fi
    
    echo ""
    echo "========================================"
    echo ""
}

# Run initial test
run_initial_test() {
    if [ "${SKIP_INITIAL_TEST:-}" != "true" ]; then
        print_step "Running initial test to verify setup..."
        echo ""
        run_tests_smart
    fi
}

# Watch for changes using inotifywait
watch_with_inotify() {
    local events="modify,create,delete,move"
    local watched_dirs="lib test"
    
    # Check if directories exist
    local existing_dirs=""
    for dir in $watched_dirs; do
        if [ -d "$dir" ]; then
            existing_dirs="$existing_dirs $dir"
        fi
    done
    
    if [ -z "$existing_dirs" ]; then
        print_error "No lib/ or test/ directories found to watch"
        exit 1
    fi
    
    print_info "Watching for changes in:$existing_dirs"
    echo ""
    
    # Watch for changes
    while true; do
        # Wait for any change in the watched directories
        if changed_file=$(inotifywait -r -e $events --format '%w%f' $existing_dirs 2>/dev/null); then
            # Filter for relevant file types
            if [[ "$changed_file" == *.dart ]] || [[ "$changed_file" == *.feature ]]; then
                local filename=$(basename "$changed_file")
                print_info "📝 File changed: $filename"
                
                # Small delay to avoid multiple rapid triggers
                sleep 1
                
                # Skip if it's a temp file or hidden file
                if [[ "$filename" != .* ]] && [[ "$filename" != *~ ]] && [[ "$filename" != *.tmp ]]; then
                    run_tests_smart
                else
                    print_info "Ignoring temporary file: $filename"
                    echo ""
                fi
            fi
        fi
    done
}

# Watch for changes using fswatch (macOS)
watch_with_fswatch() {
    if command -v fswatch &> /dev/null; then
        print_info "Using fswatch for file monitoring..."
        echo ""
        
        fswatch -o lib test 2>/dev/null | while read num; do
            print_info "📝 Files changed"
            sleep 1
            run_tests_smart
        done
    else
        print_error "fswatch not found. Install with: brew install fswatch"
        exit 1
    fi
}

# Smart mode selection
choose_watch_mode() {
    local mode="${WATCH_MODE:-auto}"
    
    case "$mode" in
        inotify)
            check_tools
            watch_with_inotify
            ;;
        fswatch)
            watch_with_fswatch
            ;;
        flutter)
            print_info "Using built-in Flutter watch mode..."
            flutter test --watch
            ;;
        auto)
            if command -v inotifywait &> /dev/null; then
                watch_with_inotify
            elif command -v fswatch &> /dev/null; then
                watch_with_fswatch
            else
                print_warning "No file watching tools found. Using Flutter's built-in watch mode..."
                echo ""
                flutter test --watch
            fi
            ;;
        *)
            print_error "Unknown watch mode: $mode"
            exit 1
            ;;
    esac
}

# Handle interruption gracefully
cleanup() {
    echo ""
    echo ""
    print_info "🛑 Watch mode stopped"
    print_success "Thanks for testing! 🚀"
    exit 0
}

# Set up signal handling
trap cleanup SIGINT SIGTERM

# Usage help
show_help() {
    cat << EOF
Test Watch Script - Auto-run tests when files change

Usage: $0 [options]

Options:
  -h, --help              Show this help message
  --skip-initial-test     Skip running tests on startup
  --mode=MODE             Watch mode: inotify, fswatch, flutter, auto
  
Environment Variables:
  SKIP_INITIAL_TEST=true  Skip initial test run
  WATCH_MODE=mode         Set watch mode (inotify, fswatch, flutter, auto)

Watch Modes:
  inotify    Use inotifywait (Linux, requires inotify-tools)
  fswatch    Use fswatch (macOS, requires fswatch)
  flutter    Use Flutter's built-in watch mode
  auto       Automatically choose best available option (default)

Examples:
  $0                              # Auto-detect best watch mode
  $0 --skip-initial-test          # Don't run tests immediately
  $0 --mode=flutter               # Use Flutter's built-in watch
  WATCH_MODE=inotify $0           # Force inotify mode

The script monitors lib/ and test/ directories for .dart and .feature file changes
and automatically runs tests when changes are detected.

EOF
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --skip-initial-test)
                export SKIP_INITIAL_TEST=true
                shift
                ;;
            --mode=*)
                export WATCH_MODE="${1#*=}"
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check if we're in a Flutter project
    check_flutter_project
    
    # Show initial status
    show_initial_status
    
    # Run initial test
    run_initial_test
    
    # Start watching
    choose_watch_mode
}

# Run the script
main "$@"
