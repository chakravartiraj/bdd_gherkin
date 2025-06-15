#!/bin/bash

# Flutter Test Coverage Setup and Analysis Script
# This script sets up comprehensive test coverage analysis for your Flutter project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        print_error "This doesn't appear to be a Flutter project (no pubspec.yaml found)"
        exit 1
    fi
    
    if ! grep -q "flutter:" pubspec.yaml; then
        print_error "This doesn't appear to be a Flutter project (no flutter section in pubspec.yaml)"
        exit 1
    fi
    
    print_success "Flutter project detected"
}

# Check required tools
check_tools() {
    print_header "Checking Required Tools"
    
    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    else
        flutter_version=$(flutter --version | head -1)
        print_success "Flutter found: $flutter_version"
    fi
    
    # Check Dart
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed or not in PATH"
        exit 1
    else
        dart_version=$(dart --version)
        print_success "Dart found: $dart_version"
    fi
    
    # Check LCOV
    if ! command -v lcov &> /dev/null; then
        print_warning "LCOV not found. Installing..."
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y lcov
        elif command -v brew &> /dev/null; then
            brew install lcov
        else
            print_error "Please install LCOV manually"
            exit 1
        fi
    else
        lcov_version=$(lcov --version | head -1)
        print_success "LCOV found: $lcov_version"
    fi
    
    # Check Dart coverage tools
    if ! command -v format_coverage &> /dev/null; then
        print_warning "Dart coverage tools not found. Installing..."
        dart pub global activate coverage
        export PATH="$PATH":"$HOME/.pub-cache/bin"
    else
        print_success "Dart coverage tools found"
    fi
}

# Setup coverage configuration
setup_coverage_config() {
    print_header "Setting Up Coverage Configuration"
    
    # Create coverage directory
    mkdir -p coverage
    print_success "Created coverage directory"
    
    # Create coverage configuration file
    cat > coverage/lcov.conf << 'EOF'
# LCOV configuration for Flutter projects
genhtml_branch_coverage = 1
genhtml_function_coverage = 1
genhtml_line_coverage = 1
genhtml_demangle_cpp = 1
genhtml_charset = UTF-8
genhtml_html_prolog = coverage/prolog.html
genhtml_html_epilog = coverage/epilog.html
genhtml_title = "Flutter Test Coverage Report"
genhtml_description_file = coverage/description.txt
genhtml_legend = 1
genhtml_num_spaces = 4
genhtml_sort = 1
genhtml_highlight = 1
EOF
    
    # Create HTML prolog for coverage reports
    cat > coverage/prolog.html << 'EOF'
<style>
  body { font-family: Arial, sans-serif; }
  .header { background-color: #0175C2; color: white; padding: 10px; }
  .summary { background-color: #f5f5f5; padding: 10px; margin: 10px 0; }
  .high-coverage { color: #28a745; }
  .medium-coverage { color: #ffc107; }
  .low-coverage { color: #dc3545; }
</style>
<div class="header">
  <h1>🎯 Flutter Test Coverage Report</h1>
  <p>Generated on: %DATE%</p>
</div>
EOF
    
    # Create HTML epilog
    cat > coverage/epilog.html << 'EOF'
<div class="footer">
  <hr>
  <p><em>Coverage report generated with LCOV and Flutter test tools</em></p>
  <p>🎯 <strong>Coverage Goals:</strong></p>
  <ul>
    <li>🟢 Excellent: ≥ 90%</li>
    <li>🟡 Good: ≥ 80%</li>
    <li>🔴 Needs Improvement: < 80%</li>
  </ul>
</div>
EOF
    
    # Create description
    cat > coverage/description.txt << 'EOF'
This coverage report shows test coverage for the Flutter project.
Coverage is calculated based on unit tests, widget tests, and integration tests.
EOF
    
    print_success "Coverage configuration created"
}

# Run comprehensive tests with coverage
run_tests_with_coverage() {
    print_header "Running Tests with Coverage"
    
    # Clean previous coverage data
    if [ -d "coverage" ]; then
        rm -f coverage/lcov.info coverage/lcov_filtered.info
        rm -rf coverage/html
    fi
    
    print_info "Installing dependencies..."
    flutter pub get
    
    # Generate localizations if needed
    if [ -f "l10n.yaml" ] || [ -d "lib/presentation/l10n" ]; then
        print_info "Generating localizations..."
        flutter gen-l10n --arb-dir lib/presentation/l10n || true
    fi
    
    print_info "Running Flutter tests with coverage..."
    
    # Run tests with coverage
    flutter test --coverage --reporter=expanded
    
    if [ ! -f "coverage/lcov.info" ]; then
        print_error "No coverage data generated. Make sure you have tests in the test/ directory"
        exit 1
    fi
    
    print_success "Tests completed with coverage data"
}

# Process and filter coverage data
process_coverage_data() {
    print_header "Processing Coverage Data"
    
    # Filter out generated files and external packages
    print_info "Filtering coverage data..."
    
    lcov --remove coverage/lcov.info \
        --ignore-errors unused \
        '*/generated/*' \
        '*/generated_plugin_registrant.dart' \
        '*/test/*' \
        '*/test_driver/*' \
        '*/build/*' \
        '*/coverage/*' \
        '*/.dart_tool/*' \
        '*/lib/presentation/l10n/*' \
        '*/lib/firebase_options.dart' \
        --output-file coverage/lcov_filtered.info
    
    print_success "Coverage data filtered"
    
    # Generate detailed coverage summary
    print_info "Generating coverage summary..."
    
    lcov --list coverage/lcov_filtered.info > coverage/coverage_summary.txt
    
    # Extract key metrics
    local line_coverage=$(lcov --summary coverage/lcov_filtered.info 2>/dev/null | grep "lines" | grep -o '[0-9.]*%' | head -1)
    local function_coverage=$(lcov --summary coverage/lcov_filtered.info 2>/dev/null | grep "functions" | grep -o '[0-9.]*%' | head -1)
    local branch_coverage=$(lcov --summary coverage/lcov_filtered.info 2>/dev/null | grep "branches" | grep -o '[0-9.]*%' | head -1)
    
    # Create a detailed summary report
    cat > coverage/detailed_summary.md << EOF
# 🎯 Test Coverage Report

**Generated:** $(date)
**Project:** $(basename "$(pwd)")

## 📊 Coverage Summary

| Metric | Coverage | Status |
|--------|----------|--------|
| Lines | ${line_coverage:-N/A} | $(get_coverage_status "${line_coverage:-0}") |
| Functions | ${function_coverage:-N/A} | $(get_coverage_status "${function_coverage:-0}") |
| Branches | ${branch_coverage:-N/A} | $(get_coverage_status "${branch_coverage:-0}") |

## 📈 Coverage Goals

- 🎯 **Target:** ≥ 80% line coverage
- 🚀 **Excellent:** ≥ 90% line coverage
- ⭐ **Outstanding:** ≥ 95% line coverage

## 📝 Coverage Details

See the HTML report for detailed file-by-file coverage information.

## 🚨 Low Coverage Files

Files with less than 80% coverage need attention:
EOF
    
    # Find low coverage files
    if [ -f "coverage/lcov_filtered.info" ]; then
        print_info "Analyzing low coverage files..."
        
        # Parse LCOV file to find low coverage files
        awk '
        BEGIN { file=""; lines_found=0; lines_hit=0 }
        /^SF:/ { 
            if (file != "" && lines_found > 0) {
                coverage = (lines_hit / lines_found) * 100
                if (coverage < 80) {
                    printf "- %s: %.1f%%\n", file, coverage
                }
            }
            file = substr($0, 4); lines_found=0; lines_hit=0 
        }
        /^LF:/ { lines_found = substr($0, 4) }
        /^LH:/ { lines_hit = substr($0, 4) }
        END {
            if (file != "" && lines_found > 0) {
                coverage = (lines_hit / lines_found) * 100
                if (coverage < 80) {
                    printf "- %s: %.1f%%\n", file, coverage
                }
            }
        }' coverage/lcov_filtered.info >> coverage/detailed_summary.md
    fi
    
    print_success "Coverage data processed"
}

# Generate HTML coverage report
generate_html_report() {
    print_header "Generating HTML Coverage Report"
    
    if [ ! -f "coverage/lcov_filtered.info" ]; then
        print_error "No filtered coverage data found"
        return 1
    fi
    
    # Create HTML directory
    mkdir -p coverage/html
    
    # Generate HTML report with custom styling
    genhtml coverage/lcov_filtered.info \
        --output-directory coverage/html \
        --title "Flutter Coverage Report" \
        --show-details \
        --legend \
        --branch-coverage \
        --function-coverage \
        --demangle-cpp \
        --sort \
        --num-spaces 2 \
        --highlight \
        --frames \
        --show-navigation
    
    if [ $? -eq 0 ]; then
        print_success "HTML coverage report generated in coverage/html/"
        print_info "Open coverage/html/index.html in your browser to view the report"
    else
        print_error "Failed to generate HTML coverage report"
        return 1
    fi
}

# Get coverage status emoji
get_coverage_status() {
    local coverage=$1
    local number=$(echo "$coverage" | grep -o '[0-9.]*' | head -1)
    
    if [ -z "$number" ]; then
        echo "❓ Unknown"
    elif (( $(echo "$number >= 90" | bc -l) )); then
        echo "🟢 Excellent"
    elif (( $(echo "$number >= 80" | bc -l) )); then
        echo "🟡 Good"
    else
        echo "🔴 Needs Improvement"
    fi
}

# Display coverage summary
display_summary() {
    print_header "Coverage Summary"
    
    if [ -f "coverage/lcov_filtered.info" ]; then
        echo ""
        print_info "Coverage Summary:"
        lcov --summary coverage/lcov_filtered.info 2>/dev/null || echo "Unable to generate summary"
        echo ""
        
        if [ -f "coverage/detailed_summary.md" ]; then
            echo ""
            print_info "Detailed summary saved to: coverage/detailed_summary.md"
        fi
        
        if [ -d "coverage/html" ]; then
            echo ""
            print_success "📊 HTML Coverage Report Available!"
            echo "Open this file in your browser:"
            echo "$(pwd)/coverage/html/index.html"
            echo ""
            
            # Try to open in browser (Linux)
            if command -v xdg-open &> /dev/null; then
                read -p "Open coverage report in browser? (y/n): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    xdg-open "$(pwd)/coverage/html/index.html"
                fi
            fi
        fi
    else
        print_error "No coverage data available"
    fi
}

# Setup coverage in CI/CD
setup_ci_coverage() {
    print_header "Setting Up CI/CD Coverage Integration"
    
    # Update the CI workflow to include better coverage handling
    if [ -f ".github/workflows/ci.yml" ]; then
        print_info "Updating CI/CD workflow for better coverage handling..."
        
        # Create a backup
        cp .github/workflows/ci.yml .github/workflows/ci.yml.backup
        
        # Update the test step in ci.yml to use our coverage setup
        cat > .github/workflows/coverage-step.yml << 'EOF'
      - name: Run tests with comprehensive coverage
        run: |
          flutter test --coverage --reporter=github
          
      - name: Process coverage data
        run: |
          # Install LCOV if not available
          sudo apt-get update && sudo apt-get install -y lcov
          
          # Filter coverage data
          lcov --remove coverage/lcov.info \
            --ignore-errors unused \
            '*/generated/*' \
            '*/generated_plugin_registrant.dart' \
            '*/test/*' \
            '*/test_driver/*' \
            '*/build/*' \
            '*/coverage/*' \
            '*/.dart_tool/*' \
            '*/lib/presentation/l10n/*' \
            '*/lib/firebase_options.dart' \
            --output-file coverage/lcov_filtered.info
            
          # Generate summary
          lcov --summary coverage/lcov_filtered.info
          
      - name: Generate coverage badge
        run: |
          # Extract coverage percentage
          COVERAGE=$(lcov --summary coverage/lcov_filtered.info | grep "lines" | grep -o '[0-9.]*%' | head -1)
          echo "Coverage: $COVERAGE"
          echo "COVERAGE_PERCENTAGE=$COVERAGE" >> $GITHUB_ENV
          
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov_filtered.info
          fail_ci_if_error: true
          verbose: true
        env:
          CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
          
      - name: Upload coverage reports
        uses: actions/upload-artifact@v4
        with:
          name: coverage-reports
          path: |
            coverage/lcov_filtered.info
            coverage/detailed_summary.md
          retention-days: 30
EOF
        
        print_success "CI/CD coverage integration template created"
        print_info "Review .github/workflows/coverage-step.yml and integrate into your CI workflow"
    else
        print_warning "No CI/CD workflow found. Coverage integration skipped."
    fi
}

# Create coverage scripts
create_coverage_scripts() {
    print_header "Creating Coverage Helper Scripts"
    
    # Create a quick coverage script
    cat > scripts/quick-coverage.sh << 'EOF'
#!/bin/bash

# Quick coverage check script
echo "🧪 Running quick coverage check..."

# Run tests with coverage
flutter test --coverage

if [ -f "coverage/lcov.info" ]; then
    # Quick summary
    echo ""
    echo "📊 Coverage Summary:"
    if command -v lcov &> /dev/null; then
        lcov --summary coverage/lcov.info
    else
        echo "Install LCOV for detailed coverage analysis: sudo apt install lcov"
    fi
else
    echo "❌ No coverage data generated"
fi
EOF

    chmod +x scripts/quick-coverage.sh
    
    # Create a coverage watch script
    cat > scripts/watch-coverage.sh << 'EOF'
#!/bin/bash

# Watch for file changes and run coverage
echo "👀 Watching for changes... Press Ctrl+C to stop"

if command -v inotifywait &> /dev/null; then
    while inotifywait -r -e modify lib/ test/; do
        echo "🔄 Files changed, running tests..."
        ./scripts/quick-coverage.sh
        echo "✅ Coverage check complete"
        echo ""
    done
else
    echo "Install inotify-tools for file watching: sudo apt install inotify-tools"
fi
EOF

    chmod +x scripts/watch-coverage.sh
    
    print_success "Coverage helper scripts created:"
    print_info "  - scripts/quick-coverage.sh (quick coverage check)"
    print_info "  - scripts/watch-coverage.sh (watch for changes)"
}

# Show help
show_help() {
    cat << EOF
Flutter Test Coverage Setup Script

Usage: $0 [options]

This script sets up comprehensive test coverage analysis for your Flutter
project including configuration, HTML reports, and helper scripts.

Options:
  -h, --help     Show this help message
  --skip-tests   Skip running tests during setup
  --config-only  Only create configuration files

Features:
  • Installs and configures LCOV tools
  • Sets up coverage configuration files
  • Runs initial coverage analysis
  • Generates HTML coverage reports
  • Creates helper scripts for daily use
  • Sets up coverage workflow

Examples:
  $0             # Full coverage setup
  $0 --skip-tests # Setup without running tests
  $0 --config-only # Only create config files

The script will create:
  - coverage/ directory with reports
  - coverage/lcov.conf configuration
  - HTML reports in coverage/html/
  - Helper scripts in scripts/

EOF
}

# Main execution
main() {
    # Parse command line arguments
    local skip_tests=false
    local config_only=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --skip-tests)
                skip_tests=true
                shift
                ;;
            --config-only)
                config_only=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    print_header "Flutter Test Coverage Setup"
    
    echo "This script will set up comprehensive test coverage analysis for your Flutter project."
    echo ""
    
    # Check if we're in the right directory
    check_flutter_project
    
    # Check required tools
    check_tools
    
    # Setup coverage configuration
    setup_coverage_config
    
    # Run tests with coverage
    run_tests_with_coverage
    
    # Process coverage data
    process_coverage_data
    
    # Generate HTML report
    generate_html_report
    
    # Display summary
    display_summary
    
    # Setup CI integration
    setup_ci_coverage
    
    # Create helper scripts
    create_coverage_scripts
    
    echo ""
    print_success "🎉 Coverage setup complete!"
    echo ""
    print_info "Next steps:"
    echo "1. Review the HTML coverage report: coverage/html/index.html"
    echo "2. Check coverage/detailed_summary.md for analysis"
    echo "3. Use ./scripts/quick-coverage.sh for quick checks"
    echo "4. Consider setting up coverage goals in your CI/CD pipeline"
    echo ""
    print_info "Coverage Goals:"
    echo "🎯 Target: ≥ 80% line coverage"
    echo "🚀 Excellent: ≥ 90% line coverage"
    echo "⭐ Outstanding: ≥ 95% line coverage"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
