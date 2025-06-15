#!/bin/bash
# Quick Test Runner for Flutter Projects
# Fast, focused test execution with smart output

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
    
    if [ ! -d "test" ]; then
        print_warning "No test directory found"
        echo "Create tests in the test/ directory to get started"
        exit 1
    fi
}

# Count test files
count_tests() {
    local unit_tests=$(find test -name "*_test.dart" 2>/dev/null | grep -v "integration\|e2e" | wc -l)
    local widget_tests=$(find test -name "widget_test.dart" 2>/dev/null | wc -l)
    local feature_files=$(find test -name "*.feature" 2>/dev/null | wc -l)
    local total_test_files=$((unit_tests + widget_tests))
    
    echo "📊 Test Overview:"
    echo "   🧪 Unit/Widget tests: $total_test_files files"
    if [ "$feature_files" -gt 0 ]; then
        echo "   🥒 BDD feature files: $feature_files files"
    fi
    echo ""
}

# Run tests with smart output
run_tests() {
    local test_target="$1"
    local start_time=$(date +%s)
    
    if [ -z "$test_target" ]; then
        print_step "Running all tests..."
        echo ""
        count_tests
    else
        print_step "Running tests: $test_target"
        echo ""
    fi
    
    # Create temporary file for test output
    local test_output="/tmp/flutter_test_$$.txt"
    
    # Run flutter test and capture output
    if flutter test ${test_target} --reporter=expanded 2>&1 | tee "$test_output"; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        echo ""
        print_success "🎉 All tests passed!"
        
        # Extract test statistics
        local test_count=$(grep -c "✓" "$test_output" 2>/dev/null || echo "0")
        
        echo ""
        print_header "Test Summary"
        echo "⏱️  Duration: ${duration}s"
        echo "✅ Passed: $test_count tests"
        echo "❌ Failed: 0 tests"
        
        # Check for warnings
        if grep -q "warning" "$test_output"; then
            echo ""
            print_warning "Some warnings were detected during testing"
            echo "Check the output above for details"
        fi
        
    else
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        echo ""
        print_error "Some tests failed!"
        
        # Extract failure information
        local passed_count=$(grep -c "✓" "$test_output" 2>/dev/null || echo "0")
        local failed_count=$(grep -c "✗" "$test_output" 2>/dev/null || echo "0")
        
        echo ""
        print_header "Test Summary"
        echo "⏱️  Duration: ${duration}s"
        echo "✅ Passed: $passed_count tests"
        echo "❌ Failed: $failed_count tests"
        
        echo ""
        print_header "Failed Tests"
        echo ""
        
        # Show failed test details
        if grep -A2 "✗" "$test_output" | head -20; then
            echo ""
            print_info "💡 Focus on the first few failures - fixing them might resolve others"
        fi
        
        echo ""
        print_header "Quick Troubleshooting"
        echo ""
        echo "Common causes of test failures:"
        echo "  🔍 Assertion failures - check expected vs actual values"
        echo "  🎯 Widget not found - verify widget exists and is rendered"
        echo "  ⏰ Timing issues - add await tester.pump() after actions"
        echo "  🔧 Setup issues - check test setup and dependencies"
        echo ""
        echo "💡 Tips:"
        echo "  • Run a single test file: flutter test test/specific_test.dart"
        echo "  • Use --verbose flag for more details: flutter test --verbose"
        echo "  • Check docs/test-quick-reference.md for help"
        
        # Cleanup and exit with error
        rm -f "$test_output"
        exit 1
    fi
    
    # Cleanup
    rm -f "$test_output"
}

# Run specific test types
run_widget_tests() {
    print_header "Running Widget Tests"
    echo ""
    if find test -name "widget_test.dart" | head -1 >/dev/null 2>&1; then
        run_tests "test/widget_test.dart"
    else
        print_warning "No widget_test.dart found"
        echo "Create widget tests to test your UI components"
    fi
}

run_unit_tests() {
    print_header "Running Unit Tests"
    echo ""
    local unit_test_files=$(find test -name "*_test.dart" 2>/dev/null | grep -v "widget_test.dart" | grep -v "integration\|e2e")
    
    if [ -n "$unit_test_files" ]; then
        run_tests
    else
        print_warning "No unit test files found"
        echo "Create unit tests to test your business logic"
    fi
}

run_bdd_tests() {
    print_header "Running BDD Tests"
    echo ""
    
    # Check for BDD test files that use bdd_widget_test
    if find test -name "*_test.dart" 2>/dev/null | xargs grep -l "bdd_widget_test\|testWidgets.*Feature\|FeatureContext" >/dev/null 2>&1; then
        # Look for BDD test files
        local bdd_files=$(find test -name "*_test.dart" 2>/dev/null | xargs grep -l "bdd_widget_test\|FeatureContext" 2>/dev/null)
        if [ -n "$bdd_files" ]; then
            echo "🥒 Found BDD test files:"
            for file in $bdd_files; do
                echo "  📄 $(basename $file)"
            done
            echo ""
            
            for file in $bdd_files; do
                print_step "Running BDD tests in $(basename $file)..."
                run_tests "$file"
            done
        else
            run_tests
        fi
    elif find test -name "*.feature" >/dev/null 2>&1; then
        print_warning "Feature files found but test files may not be using bdd_widget_test"
        echo ""
        print_info "Checking for any test files with BDD patterns..."
        
        # Look for any test files that might be BDD-related
        local potential_bdd=$(find test -name "*_test.dart" 2>/dev/null)
        if [ -n "$potential_bdd" ]; then
            echo "📄 Running all test files (some may be BDD):"
            run_tests
        else
            print_info "Create test files that use bdd_widget_test package"
            echo "Example: Use bddWidgetTest() in your test files"
        fi
    else
        print_warning "No BDD tests found"
        echo "Create .feature files in test/ directory to use BDD testing"
    fi
}

# Watch mode
watch_tests() {
    print_header "Test Watch Mode"
    echo ""
    print_info "Watching for file changes... Press Ctrl+C to stop"
    echo ""
    
    if command -v inotifywait &> /dev/null; then
        while true; do
            echo "👀 Waiting for changes..."
            if inotifywait -r -e modify lib/ test/ 2>/dev/null; then
                echo ""
                print_step "Files changed! Running tests..."
                echo ""
                run_tests
                echo ""
                echo "============================================"
                echo ""
            fi
        done
    else
        print_warning "inotifywait not found. Install inotify-tools for file watching:"
        echo "sudo apt install inotify-tools"
        echo ""
        print_info "Alternative: Use flutter test --watch"
        flutter test --watch
    fi
}

# Show test file structure
show_test_structure() {
    print_header "Test File Structure"
    echo ""
    
    if [ -d "test" ]; then
        tree test/ 2>/dev/null || find test -type f | sort
    else
        print_warning "No test directory found"
    fi
    
    echo ""
    print_info "Recommended test structure:"
    cat << 'EOF'
test/
├── widget_test.dart           # Widget tests
├── unit/                      # Unit tests by category
│   ├── models/
│   ├── services/
│   └── utils/
├── integration/               # Integration tests
└── bdd/                       # BDD/Gherkin tests
    ├── features/
    │   └── *.feature
    └── step_definitions/
EOF
}

# Quick coverage check
quick_coverage() {
    print_header "Quick Coverage Check"
    echo ""
    print_step "Running tests with coverage..."
    echo ""
    
    if flutter test --coverage; then
        echo ""
        if [ -f "coverage/lcov.info" ]; then
            if command -v lcov &> /dev/null; then
                print_info "Coverage Summary:"
                lcov --summary coverage/lcov.info 2>/dev/null || echo "Coverage data available"
            else
                print_success "Coverage data generated: coverage/lcov.info"
                print_info "Install lcov for detailed reports: sudo apt install lcov"
            fi
            
            # Quick coverage percentage
            if command -v lcov &> /dev/null; then
                local coverage_percent=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | grep -o '[0-9.]*%' | head -1)
                if [ -n "$coverage_percent" ]; then
                    echo ""
                    if (( $(echo "${coverage_percent%\%} >= 80" | bc -l 2>/dev/null || echo "0") )); then
                        print_success "Coverage: $coverage_percent (Good!)"
                    elif (( $(echo "${coverage_percent%\%} >= 70" | bc -l 2>/dev/null || echo "0") )); then
                        print_warning "Coverage: $coverage_percent (Acceptable)"
                    else
                        print_info "Coverage: $coverage_percent (Could be improved)"
                    fi
                fi
            fi
        else
            print_warning "No coverage data generated"
        fi
    fi
}

# Usage help
show_help() {
    cat << EOF
Quick Test Runner for Flutter Projects

Usage: $0 [command] [options]

Commands:
  (no args)         Run all tests
  widget           Run widget tests only
  unit             Run unit tests only
  bdd              Run BDD/Gherkin tests only
  watch            Run tests in watch mode
  coverage         Run tests with coverage
  structure        Show test file structure
  
Options:
  -h, --help       Show this help message
  -v, --verbose    Verbose output
  
Examples:
  $0               # Run all tests
  $0 widget        # Run only widget tests
  $0 watch         # Watch for changes and auto-run tests
  $0 coverage      # Run with coverage analysis

EOF
}

# Main execution
main() {
    # Parse command line arguments
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        widget)
            check_flutter_project
            run_widget_tests
            ;;
        unit)
            check_flutter_project
            run_unit_tests
            ;;
        bdd|gherkin)
            check_flutter_project
            run_bdd_tests
            ;;
        watch)
            check_flutter_project
            watch_tests
            ;;
        coverage)
            check_flutter_project
            quick_coverage
            ;;
        structure)
            show_test_structure
            ;;
        "")
            check_flutter_project
            run_tests
            ;;
        *)
            echo "Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run the script
main "$@"
