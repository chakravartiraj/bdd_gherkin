#!/bin/bash
# Flutter Project Development Scripts Hub
# Master script that provides access to all development tools

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print colored output
print_header() {
    echo -e "${BOLD}${BLUE}🎯 === $1 ===${NC}"
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

# Show main menu
show_main_menu() {
    clear
    print_header "Flutter Development Scripts Hub"
    echo ""
    echo -e "${BOLD}Welcome to your Flutter development toolkit!${NC}"
    echo ""
    echo "📚 Choose a category:"
    echo ""
    echo "  🧪 1. Testing Tools"
    echo "  📊 2. Coverage Tools" 
    echo "  🔍 3. Analysis Tools"
    echo "  🥒 4. BDD/Gherkin Tools"
    echo "  📖 5. Documentation"
    echo "  ⚙️  6. Setup & Configuration"
    echo ""
    echo "  📋 0. Show all available scripts"
    echo "  ❌ q. Quit"
    echo ""
}

# Show testing menu
show_testing_menu() {
    clear
    print_header "Testing Tools"
    echo ""
    echo "🧪 Testing scripts and tutorials:"
    echo ""
    echo "  1. 📚 Interactive Testing Tutorial"
    echo "     Learn Flutter testing from scratch with guided examples"
    echo "     → ./scripts/test-tutorial.sh"
    echo ""
    echo "  2. ⚡ Quick Test Runner"
    echo "     Fast test execution with smart output"
    echo "     → ./scripts/test-quick.sh [widget|unit|bdd|watch|coverage]"
    echo ""
    echo "  3. 👀 Test Watch Mode"
    echo "     Auto-run tests when files change"
    echo "     → ./scripts/test-watch.sh"
    echo ""
    echo "  b. ← Back to main menu"
    echo "  q. ❌ Quit"
    echo ""
}

# Show coverage menu
show_coverage_menu() {
    clear
    print_header "Coverage Analysis Tools"
    echo ""
    echo "📊 Coverage scripts and analysis:"
    echo ""
    echo "  1. 📚 Interactive Coverage Tutorial"
    echo "     Learn test coverage with step-by-step guidance"
    echo "     → ./scripts/coverage-tutorial.sh"
    echo ""
    echo "  2. ⚡ Quick Coverage Check"
    echo "     Fast coverage analysis and reporting"
    echo "     → ./scripts/coverage-quick.sh"
    echo ""
    echo "  3. 🛠️  Complete Coverage Setup"
    echo "     Comprehensive coverage configuration and reporting"
    echo "     → ./scripts/coverage-setup.sh"
    echo ""
    echo "  4. 👀 Coverage Watch Mode"
    echo "     Auto-run coverage when files change"
    echo "     → ./scripts/coverage-watch.sh"
    echo ""
    echo "  b. ← Back to main menu"
    echo "  q. ❌ Quit"
    echo ""
}

# Show analysis menu
show_analysis_menu() {
    clear
    print_header "Code Analysis Tools"
    echo ""
    echo "🔍 Analysis scripts and linting:"
    echo ""
    echo "  1. 📚 Interactive Analysis Tutorial"
    echo "     Learn Flutter analyze with examples and explanations"
    echo "     → ./scripts/analyze-tutorial.sh"
    echo ""
    echo "  2. 📈 Daily Analysis Check"
    echo "     Quick code quality analysis with actionable suggestions"
    echo "     → ./scripts/analyze-daily.sh"
    echo ""
    echo "  b. ← Back to main menu"
    echo "  q. ❌ Quit"
    echo ""
}

# Show BDD menu
show_bdd_menu() {
    clear
    print_header "BDD/Gherkin Tools"
    echo ""
    echo "🥒 Behavior-Driven Development tools:"
    echo ""
    echo "  1. 📊 BDD Project Status"
    echo "     Check BDD setup and get recommendations"
    echo "     → ./scripts/bdd-helper.sh status"
    echo ""
    echo "  2. 📝 Create Sample Feature"
    echo "     Generate example .feature file with scenarios"
    echo "     → ./scripts/bdd-helper.sh create-sample"
    echo ""
    echo "  3. 🔧 Generate Test Code"
    echo "     Generate Dart tests from .feature files"
    echo "     → ./scripts/bdd-helper.sh generate"
    echo ""
    echo "  4. 🧪 Run BDD Tests"
    echo "     Execute all BDD/Gherkin tests"
    echo "     → ./scripts/bdd-helper.sh test"
    echo ""
    echo "  5. 👀 BDD Watch Mode"
    echo "     Auto-regenerate tests when .feature files change"
    echo "     → ./scripts/bdd-helper.sh watch"
    echo ""
    echo "  b. ← Back to main menu"
    echo "  q. ❌ Quit"
    echo ""
}

# Show documentation menu
show_documentation_menu() {
    clear
    print_header "Documentation"
    echo ""
    echo "📖 Available documentation and guides:"
    echo ""
    echo "  HTML Documentation:"
    echo "    📄 docs/index.html - Main documentation hub"
    echo "    🧪 docs/flutter-test-walkthrough.html - Complete testing guide"
    echo "    📊 docs/flutter-coverage-walkthrough.html - Coverage tutorial"
    echo "    🔍 docs/flutter-analyze-walkthrough.html - Analysis guide"
    echo ""
    echo "  Quick References:"
    echo "    📋 docs/test-quick-reference.html - Testing commands cheat sheet"
    echo "    📋 docs/coverage-quick-reference.html - Coverage commands"
    echo "    📋 docs/analyze-quick-reference.html - Analysis commands"
    echo ""
    echo "  Hands-On Exercises:"
    echo "    🏋️ docs/hands-on-test-exercise.html - Testing practice"
    echo "    🏋️ docs/hands-on-coverage-exercise.html - Coverage practice"
    echo "    🏋️ docs/hands-on-analyze-exercise.html - Analysis practice"
    echo ""
    echo "  1. 🌐 Open documentation hub in browser"
    echo "  2. 📂 Show documentation structure"
    echo ""
    echo "  b. ← Back to main menu"
    echo "  q. ❌ Quit"
    echo ""
}

# Show all scripts
show_all_scripts() {
    clear
    print_header "All Available Scripts"
    echo ""
    echo "📋 Complete list of development scripts:"
    echo ""
    
    if [ -d "scripts" ]; then
        echo "🧪 TESTING:"
        echo "   ./scripts/test-tutorial.sh         Interactive testing tutorial"
        echo "   ./scripts/test-quick.sh            Fast test runner with options"  
        echo "   ./scripts/test-watch.sh            Auto-run tests on file changes"
        echo ""
        
        echo "📊 COVERAGE:"
        echo "   ./scripts/coverage-tutorial.sh     Interactive coverage tutorial"
        echo "   ./scripts/coverage-quick.sh        Quick coverage analysis"
        echo "   ./scripts/coverage-setup.sh        Complete coverage setup"
        echo "   ./scripts/coverage-watch.sh        Auto-run coverage on changes"
        echo ""
        
        echo "🔍 ANALYSIS:"
        echo "   ./scripts/analyze-tutorial.sh      Interactive analysis tutorial"
        echo "   ./scripts/analyze-daily.sh         Daily code quality check"
        echo ""
        
        echo "🥒 BDD/GHERKIN:"
        echo "   ./scripts/bdd-helper.sh            Complete BDD toolkit"
        echo "     Available commands: status, create-sample, generate, test, watch"
        echo ""
        
        echo "🛠️  UTILITIES:"
        echo "   ./scripts/dev.sh                   This script (development hub)"
        echo ""
    else
        print_warning "Scripts directory not found"
    fi
    
    echo "💡 Pro tip: Most scripts include --help flag for detailed usage"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Open documentation
open_documentation() {
    if [ -f "docs/index.html" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open docs/index.html
            print_success "Opened documentation in browser"
        else
            print_info "Open this file in your browser: $(pwd)/docs/index.html"
        fi
    else
        print_error "Documentation not found at docs/index.html"
    fi
}

# Show documentation structure
show_doc_structure() {
    clear
    print_header "Documentation Structure"
    echo ""
    
    if [ -d "docs" ]; then
        print_info "HTML Documentation (Web Versions):"
        find docs -maxdepth 1 -name "*.html" | sort | while read file; do
            echo "  📄 $file"
        done
        echo ""
        
        print_info "Markdown Sources (Organized by Topic):"
        for dir in docs/*/; do
            if [ -d "$dir" ]; then
                echo "  📁 $dir"
                find "$dir" -name "*.md" | sort | while read file; do
                    echo "    📝 $(basename $file)"
                done
                echo ""
            fi
        done
    else
        print_warning "Documentation directory not found"
    fi
    
    echo "Press Enter to continue..."
    read
}

# Execute script safely
execute_script() {
    local script_path="$1"
    shift
    local script_args="$@"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        echo ""
        print_step "Executing: $script_path $script_args"
        echo ""
        "$script_path" $script_args
    else
        print_error "Script not found or not executable: $script_path"
        echo "Available scripts:"
        ls -la scripts/ | grep ".sh$" || echo "No scripts found"
    fi
}

# Handle menu selection
handle_selection() {
    local menu="$1"
    local choice="$2"
    
    case "$menu" in
        "main")
            case "$choice" in
                1) show_testing_menu && handle_menu "testing" ;;
                2) show_coverage_menu && handle_menu "coverage" ;;
                3) show_analysis_menu && handle_menu "analysis" ;;
                4) show_bdd_menu && handle_menu "bdd" ;;
                5) show_documentation_menu && handle_menu "documentation" ;;
                6) print_info "Setup & Configuration - Use individual tutorials to set up each tool" && sleep 2 ;;
                0) show_all_scripts ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
        "testing")
            case "$choice" in
                1) execute_script "./scripts/test-tutorial.sh" ;;
                2) execute_script "./scripts/test-quick.sh" ;;
                3) execute_script "./scripts/test-watch.sh" ;;
                b|B) return ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
        "coverage")
            case "$choice" in
                1) execute_script "./scripts/coverage-tutorial.sh" ;;
                2) execute_script "./scripts/coverage-quick.sh" ;;
                3) execute_script "./scripts/coverage-setup.sh" ;;
                4) execute_script "./scripts/coverage-watch.sh" ;;
                b|B) return ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
        "analysis")
            case "$choice" in
                1) execute_script "./scripts/analyze-tutorial.sh" ;;
                2) execute_script "./scripts/analyze-daily.sh" ;;
                b|B) return ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
        "bdd")
            case "$choice" in
                1) execute_script "./scripts/bdd-helper.sh" "status" ;;
                2) execute_script "./scripts/bdd-helper.sh" "create-sample" ;;
                3) execute_script "./scripts/bdd-helper.sh" "generate" ;;
                4) execute_script "./scripts/bdd-helper.sh" "test" ;;
                5) execute_script "./scripts/bdd-helper.sh" "watch" ;;
                b|B) return ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
        "documentation")
            case "$choice" in
                1) open_documentation ;;
                2) show_doc_structure ;;
                b|B) return ;;
                q|Q) exit 0 ;;
                *) print_warning "Invalid choice. Try again." && sleep 1 ;;
            esac
            ;;
    esac
}

# Handle menu interaction
handle_menu() {
    local menu_type="$1"
    
    while true; do
        case "$menu_type" in
            "main") show_main_menu ;;
            "testing") show_testing_menu ;;
            "coverage") show_coverage_menu ;;
            "analysis") show_analysis_menu ;;
            "bdd") show_bdd_menu ;;
            "documentation") show_documentation_menu ;;
        esac
        
        read -p "$(echo -e "${CYAN}Enter your choice: ${NC}")" choice
        handle_selection "$menu_type" "$choice"
        
        if [[ "$choice" == "b" || "$choice" == "B" ]]; then
            break
        fi
    done
}

# Quick command execution (non-interactive mode)
execute_quick_command() {
    local command="$1"
    shift
    local args="$@"
    
    case "$command" in
        "test")
            execute_script "./scripts/test-quick.sh" $args
            ;;
        "coverage")
            execute_script "./scripts/coverage-quick.sh" $args
            ;;
        "analyze")
            execute_script "./scripts/analyze-daily.sh" $args
            ;;
        "bdd")
            execute_script "./scripts/bdd-helper.sh" $args
            ;;
        "watch-test")
            execute_script "./scripts/test-watch.sh" $args
            ;;
        "watch-coverage")
            execute_script "./scripts/coverage-watch.sh" $args
            ;;
        "tutorial-test")
            execute_script "./scripts/test-tutorial.sh" $args
            ;;
        "tutorial-coverage")
            execute_script "./scripts/coverage-tutorial.sh" $args
            ;;
        "tutorial-analyze")
            execute_script "./scripts/analyze-tutorial.sh" $args
            ;;
        "docs")
            open_documentation
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Show help
show_help() {
    cat << EOF
Flutter Development Scripts Hub

Usage: $0 [command] [args...]

Interactive Mode:
  $0                    Show interactive menu

Quick Commands:
  $0 test [args]        Run quick tests
  $0 coverage [args]    Run coverage analysis  
  $0 analyze [args]     Run code analysis
  $0 bdd [args]         Run BDD helper
  $0 watch-test         Start test watch mode
  $0 watch-coverage     Start coverage watch mode
  $0 tutorial-test      Start testing tutorial
  $0 tutorial-coverage  Start coverage tutorial
  $0 tutorial-analyze   Start analysis tutorial
  $0 docs               Open documentation

Examples:
  $0                    # Interactive menu
  $0 test              # Run all tests
  $0 test widget       # Run only widget tests
  $0 coverage          # Quick coverage check
  $0 analyze           # Daily analysis
  $0 bdd status        # Check BDD setup
  $0 docs              # Open documentation hub

EOF
}

# Main execution
main() {
    # Check if we're in a Flutter project
    check_flutter_project
    
    # Handle command line arguments
    if [ $# -eq 0 ]; then
        # Interactive mode
        handle_menu "main"
    elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_help
    else
        # Quick command mode
        execute_quick_command "$@"
    fi
}

# Run the script
main "$@"
