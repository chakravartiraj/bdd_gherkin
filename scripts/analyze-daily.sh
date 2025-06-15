#!/bin/bash
# Daily Analysis Script for Flutter Projects
# Quick and comprehensive code analysis with user-friendly output

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

# Show analysis summary
show_summary() {
    local issues_file="$1"
    local total_issues=$(wc -l < "$issues_file" 2>/dev/null || echo "0")
    
    if [ "$total_issues" -eq 0 ]; then
        print_success "🎉 No issues found! Your code follows all analysis rules."
        return 0
    fi
    
    # Count different types of issues
    local errors=$(grep -c "error •" "$issues_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "warning •" "$issues_file" 2>/dev/null || echo "0")
    local lints=$(grep -c "info •" "$issues_file" 2>/dev/null || echo "0")
    
    echo ""
    print_header "Analysis Summary"
    echo ""
    echo "📊 Total Issues: $total_issues"
    
    if [ "$errors" -gt 0 ]; then
        print_error "🔴 Errors: $errors (Must fix - code won't compile)"
    fi
    
    if [ "$warnings" -gt 0 ]; then
        print_warning "🟡 Warnings: $warnings (Should fix - potential problems)"
    fi
    
    if [ "$lints" -gt 0 ]; then
        print_info "🔵 Lints: $lints (Style suggestions)"
    fi
    
    echo ""
    
    # Provide guidance based on issue count
    if [ "$total_issues" -le 5 ]; then
        print_success "Great! Only a few issues to address."
    elif [ "$total_issues" -le 20 ]; then
        print_warning "Moderate number of issues. Consider fixing them gradually."
    else
        print_info "Many issues found. Focus on errors and warnings first."
    fi
    
    return 1
}

# Show top issues
show_top_issues() {
    local issues_file="$1"
    
    if [ ! -f "$issues_file" ] || [ ! -s "$issues_file" ]; then
        return
    fi
    
    echo ""
    print_header "Top Issues to Fix"
    echo ""
    
    # Show first 10 issues with better formatting
    head -10 "$issues_file" | while IFS= read -r line; do
        if [[ "$line" == *"error •"* ]]; then
            echo -e "${RED}🔴 $line${NC}"
        elif [[ "$line" == *"warning •"* ]]; then
            echo -e "${YELLOW}🟡 $line${NC}"
        elif [[ "$line" == *"info •"* ]]; then
            echo -e "${CYAN}🔵 $line${NC}"
        else
            echo "$line"
        fi
    done
    
    local total_issues=$(wc -l < "$issues_file" 2>/dev/null || echo "0")
    if [ "$total_issues" -gt 10 ]; then
        echo ""
        print_info "... and $((total_issues - 10)) more issues"
        echo ""
        print_info "💡 Tip: Run 'flutter analyze' to see all issues"
        echo "💡 Tip: Use your IDE for detailed issue navigation"
    fi
}

# Quick fix suggestions
suggest_quick_fixes() {
    local issues_file="$1"
    
    if [ ! -f "$issues_file" ] || [ ! -s "$issues_file" ]; then
        return
    fi
    
    echo ""
    print_header "Quick Fix Suggestions"
    echo ""
    
    # Check for common issues and provide fixes
    if grep -q "prefer_const_constructors" "$issues_file"; then
        echo "🔧 prefer_const_constructors:"
        echo "   Add 'const' keyword: Widget() → const Widget()"
        echo ""
    fi
    
    if grep -q "prefer_single_quotes" "$issues_file"; then
        echo "🔧 prefer_single_quotes:"
        echo "   Use single quotes: \"text\" → 'text'"
        echo ""
    fi
    
    if grep -q "unused_import" "$issues_file"; then
        echo "🔧 unused_import:"
        echo "   Remove unused import statements"
        echo "   Most IDEs can do this automatically"
        echo ""
    fi
    
    if grep -q "dead_code" "$issues_file"; then
        echo "🔧 dead_code:"
        echo "   Remove unreachable code"
        echo ""
    fi
    
    if grep -q "missing_return" "$issues_file"; then
        echo "🔧 missing_return:"
        echo "   Add return statement to functions"
        echo ""
    fi
    
    if grep -q "prefer_final_fields" "$issues_file"; then
        echo "🔧 prefer_final_fields:"
        echo "   Make fields final if they're never reassigned"
        echo ""
    fi
    
    echo "💡 Pro tip: Many IDEs can auto-fix these issues!"
    echo "   • VS Code: Ctrl+Shift+P → 'Fix All'"
    echo "   • Android Studio: Code → Reformat Code"
}

# Performance check
performance_check() {
    echo ""
    print_header "Performance Quick Check"
    echo ""
    
    local has_performance_issues=false
    
    # Check for common performance issues in code
    if find lib -name "*.dart" -exec grep -l "print(" {} \; 2>/dev/null | head -1 >/dev/null; then
        print_warning "Found print() statements - remove for production"
        has_performance_issues=true
    fi
    
    if find lib -name "*.dart" -exec grep -l "setState(() {" {} \; 2>/dev/null | head -1 >/dev/null; then
        if find lib -name "*.dart" -exec grep -c "setState" {} \; 2>/dev/null | awk '{sum += $1} END {if(sum > 20) exit 0; else exit 1}'; then
            print_info "Many setState calls found - consider state management solutions"
            has_performance_issues=true
        fi
    fi
    
    # Check file sizes
    if find lib -name "*.dart" -size +50k 2>/dev/null | head -1 >/dev/null; then
        print_info "Large files found - consider breaking them into smaller modules"
        has_performance_issues=true
    fi
    
    if [ "$has_performance_issues" = false ]; then
        print_success "No obvious performance issues detected"
    fi
}

# Security check
security_check() {
    echo ""
    print_header "Security Quick Check"
    echo ""
    
    local has_security_issues=false
    
    # Check for hardcoded secrets (basic check)
    if find lib -name "*.dart" -exec grep -l "password\|secret\|api_key\|token" {} \; 2>/dev/null | head -1 >/dev/null; then
        print_warning "Potential hardcoded secrets found - review carefully"
        echo "   💡 Use environment variables or secure storage"
        has_security_issues=true
    fi
    
    # Check for HTTP URLs in production code
    if find lib -name "*.dart" -exec grep -l "http://" {} \; 2>/dev/null | head -1 >/dev/null; then
        print_warning "HTTP URLs found - use HTTPS for production"
        has_security_issues=true
    fi
    
    # Check for debug code
    if find lib -name "*.dart" -exec grep -l "debugPrint\|kDebugMode" {} \; 2>/dev/null | head -1 >/dev/null; then
        print_info "Debug code found - ensure it's properly conditional"
        has_security_issues=true
    fi
    
    if [ "$has_security_issues" = false ]; then
        print_success "No obvious security issues detected"
    fi
}

# Code quality metrics
quality_metrics() {
    echo ""
    print_header "Code Quality Metrics"
    echo ""
    
    local dart_files=$(find lib -name "*.dart" 2>/dev/null | wc -l)
    local total_lines=$(find lib -name "*.dart" -exec wc -l {} \; 2>/dev/null | awk '{sum += $1} END {print sum}')
    local avg_file_size=$((total_lines / dart_files))
    
    echo "📁 Dart files: $dart_files"
    echo "📝 Total lines: $total_lines"
    echo "📊 Average file size: $avg_file_size lines"
    
    if [ "$avg_file_size" -lt 100 ]; then
        print_success "Good file sizes - easy to maintain"
    elif [ "$avg_file_size" -lt 200 ]; then
        print_info "Moderate file sizes - still manageable"
    else
        print_warning "Large average file size - consider breaking into smaller files"
    fi
    
    # Check for TODO/FIXME comments
    local todos=$(find lib -name "*.dart" -exec grep -c "TODO\|FIXME\|HACK" {} \; 2>/dev/null | awk '{sum += $1} END {print sum}')
    
    if [ "$todos" -gt 0 ]; then
        echo "📝 TODOs/FIXMEs: $todos"
        if [ "$todos" -gt 10 ]; then
            print_warning "Many TODOs found - consider prioritizing them"
        else
            print_info "Some TODOs found - track them in your issue tracker"
        fi
    else
        print_success "No TODOs found - clean codebase"
    fi
}

# Main analysis function
run_daily_analysis() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local analysis_file="/tmp/flutter_analysis_$$.txt"
    
    print_header "Daily Flutter Analysis - $timestamp"
    echo ""
    print_info "Analyzing your Flutter project..."
    echo ""
    
    # Run flutter analyze and capture output
    print_step "Running flutter analyze..."
    if flutter analyze --no-congratulate --no-preamble > "$analysis_file" 2>&1; then
        print_success "Analysis completed with no issues!"
        
        # Still show metrics and checks
        quality_metrics
        performance_check
        security_check
        
        echo ""
        print_success "🎉 Excellent! Your code is clean and follows best practices."
        
    else
        print_warning "Analysis found some issues to address"
        
        # Show summary and top issues
        show_summary "$analysis_file"
        show_top_issues "$analysis_file"
        suggest_quick_fixes "$analysis_file"
        
        # Show additional metrics
        quality_metrics
        performance_check
        security_check
        
        echo ""
        print_header "Recommendations"
        echo ""
        echo "1. 🎯 Focus on errors first (red issues)"
        echo "2. ⚠️  Address warnings that affect functionality"
        echo "3. 💅 Fix style issues when you have time"
        echo "4. 📚 Use the quick reference guide: docs/analyze-quick-reference.md"
        echo "5. 🔧 Consider setting up pre-commit hooks for analysis"
    fi
    
    # Save analysis to file
    local report_dir="analysis_reports"
    mkdir -p "$report_dir"
    local report_file="$report_dir/analysis_$(date '+%Y%m%d_%H%M%S').txt"
    
    {
        echo "Flutter Analysis Report - $timestamp"
        echo "========================================"
        echo ""
        cat "$analysis_file"
    } > "$report_file"
    
    echo ""
    print_info "📄 Full analysis saved to: $report_file"
    
    # Cleanup
    rm -f "$analysis_file"
}

# Usage help
show_help() {
    echo "Daily Flutter Analysis Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -q, --quiet    Quiet mode (less output)"
    echo "  -v, --verbose  Verbose mode (more details)"
    echo ""
    echo "This script runs flutter analyze with user-friendly output and"
    echo "provides actionable suggestions for improving your code quality."
    echo ""
}

# Main execution
main() {
    local quiet_mode=false
    local verbose_mode=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -q|--quiet)
                quiet_mode=true
                shift
                ;;
            -v|--verbose)
                verbose_mode=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check if we're in a Flutter project
    check_flutter_project
    
    # Run the analysis
    if [ "$quiet_mode" = true ]; then
        # Just run flutter analyze
        flutter analyze
    else
        run_daily_analysis
    fi
}

# Run the script
main "$@"
