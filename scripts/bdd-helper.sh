#!/bin/bash
# BDD Test Generator and Runner
# Handles Gherkin feature files and generates corresponding test code

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

# Check BDD dependencies
check_bdd_dependencies() {
    print_header "Checking BDD Dependencies"
    echo ""
    
    local missing_deps=()
    
    if ! grep -q "bdd_widget_test:" pubspec.yaml; then
        missing_deps+=("bdd_widget_test")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing BDD dependencies: ${missing_deps[*]}"
        echo ""
        echo "Add these to your pubspec.yaml dev_dependencies:"
        echo ""
        for dep in "${missing_deps[@]}"; do
            case $dep in
                bdd_widget_test)
                    echo "  bdd_widget_test: ^1.8.1"
                    ;;
            esac
        done
        echo ""
        
        if ask_yes_no "Want me to add these dependencies for you?"; then
            add_bdd_dependencies
        else
            print_info "Please add the dependencies manually and run this script again"
            exit 1
        fi
    else
        print_success "All BDD dependencies found"
    fi
}

# Helper function for yes/no questions
ask_yes_no() {
    while true; do
        read -p "$(echo -e "${CYAN}$1 (y/n): ${NC}")" yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Add BDD dependencies
add_bdd_dependencies() {
    print_step "Adding BDD dependencies..."
    
    # Create backup
    cp pubspec.yaml pubspec.yaml.backup
    
    # Add dependencies if dev_dependencies section exists
    if grep -q "dev_dependencies:" pubspec.yaml; then
        # Add after dev_dependencies line
        if ! grep -q "bdd_widget_test:" pubspec.yaml; then
            sed -i '/dev_dependencies:/a\  bdd_widget_test: ^1.8.1' pubspec.yaml
        fi
    else
        # Add dev_dependencies section
        echo "" >> pubspec.yaml
        echo "dev_dependencies:" >> pubspec.yaml
        echo "  flutter_test:" >> pubspec.yaml
        echo "    sdk: flutter" >> pubspec.yaml
        echo "  bdd_widget_test: ^1.8.1" >> pubspec.yaml
    fi
    
    print_success "Dependencies added to pubspec.yaml"
    
    print_step "Running flutter pub get..."
    flutter pub get
    
    print_success "Dependencies installed"
}

# Show feature files
show_feature_files() {
    print_header "Feature Files Overview"
    echo ""
    
    local feature_files=$(find test -name "*.feature" 2>/dev/null)
    
    if [ -z "$feature_files" ]; then
        print_warning "No .feature files found"
        echo ""
        echo "Feature files contain your BDD scenarios in plain English."
        echo "They should be placed in the test/ directory."
        return 1
    fi
    
    echo "📝 Found feature files:"
    echo ""
    
    local count=1
    for file in $feature_files; do
        echo "  $count. $file"
        
        # Show first scenario from each file
        if [ -f "$file" ]; then
            local first_scenario=$(grep -n "Scenario:" "$file" | head -1)
            if [ -n "$first_scenario" ]; then
                echo "     📖 $(echo $first_scenario | cut -d: -f3-)"
            fi
        fi
        echo ""
        count=$((count + 1))
    done
    
    return 0
}

# Create sample feature file
create_sample_feature() {
    print_header "Creating Sample Feature File"
    echo ""
    
    local feature_file="test/sample.feature"
    
    if [ -f "$feature_file" ]; then
        print_info "Sample feature file already exists: $feature_file"
        return 0
    fi
    
    cat > "$feature_file" << 'EOF'
Feature: Counter App
  As a user
  I want to increment and decrement a counter
  So that I can track a count

  Scenario: Increment counter
    Given the app is running
    When I tap the increment button
    Then I see 1

  Scenario: Decrement counter  
    Given the app is running
    When I tap the increment button
    And I tap the decrement button
    Then I see 0

  Scenario: Multiple increments
    Given the app is running
    When I tap the increment button
    And I tap the increment button
    And I tap the increment button
    Then I see 3
EOF
    
    print_success "Created sample feature file: $feature_file"
    echo ""
    print_info "This file demonstrates basic BDD scenarios for a counter app."
    
    if ask_yes_no "Want to see the contents of the feature file?"; then
        echo ""
        print_step "Contents of $feature_file:"
        echo ""
        cat "$feature_file"
        echo ""
    fi
}

# Create BDD test templates for bdd_widget_test
create_bdd_test_templates() {
    local test_files=("$@")
    
    for test_file in "${test_files[@]}"; do
        local feature_file="${test_file%_test.dart}.feature"
        local feature_name=$(basename "$feature_file" .feature)
        
        print_step "Creating test template: $test_file"
        
        cat > "$test_file" << EOF
import 'package:flutter_test/flutter_test.dart';
import 'package:bdd_widget_test/bdd_widget_test.dart';
import 'package:${feature_name}/main.dart'; // Update this import

void main() {
  group('${feature_name^} BDD Tests', () {
    bddWidgetTest(
      'Run BDD scenarios from ${feature_name}.feature',
      '${feature_file}',
      (tester) async {
        await tester.pumpWidget(const MyApp());
      },
      steps: [
        // Add your step definitions here
        given1('the app is running', (step, tester) async {
          // App is already pumped in setUp
        }),
        when1('I tap the increment button', (step, tester) async {
          await tester.tap(find.byTooltip('Increment'));
          await tester.pump();
        }),
        when1('I tap the decrement button', (step, tester) async {
          await tester.tap(find.byTooltip('Decrement'));
          await tester.pump();
        }),
        then1('I see {int}', (step, tester, count) async {
          expect(find.text(count.toString()), findsOneWidget);
        }),
      ],
    );
  });
}
EOF
        
        print_success "Created: $test_file"
    done
    
    echo ""
    print_info "Template test files created!"
    print_warning "Remember to:"
    echo "  1. Update the import paths for your app"
    echo "  2. Customize step definitions for your specific UI"
    echo "  3. Add more steps as needed for your scenarios"
}

# Generate test code from feature files
generate_test_code() {
    print_header "Generating Test Code from Feature Files"
    echo ""
    
    # Check if feature files exist
    if ! find test -name "*.feature" >/dev/null 2>&1; then
        print_warning "No .feature files found"
        echo ""
        if ask_yes_no "Want to create a sample feature file?"; then
            create_sample_feature
        else
            print_info "Create .feature files in test/ directory first"
            return 1
        fi
    fi
    
    print_info "With bdd_widget_test, you write regular Dart test files that read .feature files"
    echo ""
    print_step "Checking for corresponding test files..."
    echo ""
    
    local feature_files=$(find test -name "*.feature" 2>/dev/null)
    local missing_tests=()
    
    for feature_file in $feature_files; do
        local test_file="${feature_file%.feature}_test.dart"
        
        if [ ! -f "$test_file" ]; then
            missing_tests+=("$test_file")
            print_warning "Missing test file: $test_file"
        else
            print_success "Found test file: $test_file"
        fi
    done
    
    if [ ${#missing_tests[@]} -gt 0 ]; then
        echo ""
        if ask_yes_no "Want to create template test files for missing features?"; then
            create_bdd_test_templates "${missing_tests[@]}"
        fi
    else
        print_success "All feature files have corresponding test files!"
    fi
}

# Run BDD tests
run_bdd_tests() {
    print_header "Running BDD Tests"
    echo ""
    
    # Find BDD test files (either bddWidgetTest or step-based approach)
    local bdd_test_files=$(find test -name "*_test.dart" 2>/dev/null | xargs grep -l "bdd_widget_test\|bddWidgetTest\|step/" 2>/dev/null)
    
    if [ -z "$bdd_test_files" ]; then
        print_warning "No BDD test files found"
        echo ""
        print_info "Create test files that use bdd_widget_test package or step definitions"
        print_info "Run: $0 generate to create template test files"
        return 1
    fi
    
    print_step "Running BDD tests..."
    echo ""
    
    local test_count=0
    local passed_count=0
    local failed_count=0
    
    for test_file in $bdd_test_files; do
        echo "🧪 Testing: $(basename $test_file)"
        
        if flutter test "$test_file" --reporter=compact; then
            print_success "✅ $(basename $test_file) - PASSED"
            passed_count=$((passed_count + 1))
        else
            print_error "❌ $(basename $test_file) - FAILED"
            failed_count=$((failed_count + 1))
        fi
        
        test_count=$((test_count + 1))
        echo ""
    done
    
    # Summary
    print_header "BDD Test Summary"
    echo ""
    echo "📊 Total test files: $test_count"
    echo "✅ Passed: $passed_count"
    echo "❌ Failed: $failed_count"
    
    if [ $failed_count -eq 0 ]; then
        print_success "🎉 All BDD tests passed!"
    else
        print_warning "Some BDD tests failed - check the output above"
    fi
}

# Watch mode for BDD
watch_bdd() {
    print_header "BDD Watch Mode"
    echo ""
    print_info "Watching for changes in .feature and test files..."
    echo ""
    print_warning "Press Ctrl+C to stop"
    echo ""
    
    if command -v inotifywait &> /dev/null; then
        while true; do
            echo "👀 Waiting for file changes..."
            
            if inotifywait -e modify test/*.feature test/*_test.dart 2>/dev/null; then
                echo ""
                print_step "Files changed! Running BDD tests..."
                echo ""
                
                run_bdd_tests
                
                echo ""
                echo "========================================"
                echo ""
            fi
        done
    else
        print_warning "inotifywait not found. Install inotify-tools for watch mode:"
        echo "sudo apt install inotify-tools"
        echo ""
        print_info "Manual workflow:"
        echo "1. Edit your .feature files or test files"
        echo "2. Run: flutter test"
    fi
}

# Show BDD status
show_bdd_status() {
    print_header "BDD Project Status"
    echo ""
    
    # Check feature files
    local feature_count=$(find test -name "*.feature" 2>/dev/null | wc -l)
    echo "📝 Feature files: $feature_count"
    
    if [ $feature_count -gt 0 ]; then
        local scenario_count=$(grep -r "Scenario:" test/*.feature 2>/dev/null | wc -l)
        echo "🎭 Scenarios: $scenario_count"
        
        # Show recent feature files
        echo ""
        echo "Recent feature files:"
        find test -name "*.feature" -exec ls -la {} \; 2>/dev/null | tail -3 | while read line; do
            echo "  📄 $(echo $line | awk '{print $9, $6, $7, $8}')"
        done
    fi
    
    echo ""
    
    # Check BDD test files (either bddWidgetTest or step-based approach)
    local bdd_test_files=$(find test -name "*_test.dart" 2>/dev/null | xargs grep -l "bdd_widget_test\|bddWidgetTest\|step/" 2>/dev/null | wc -l)
    echo "🧪 BDD test files: $bdd_test_files"
    
    # Check step definitions
    local step_files=$(find test/step -name "*.dart" 2>/dev/null | wc -l)
    if [ $step_files -gt 0 ]; then
        echo "📋 Step definition files: $step_files"
    fi
    
    # Check dependencies
    echo ""
    if grep -q "bdd_widget_test:" pubspec.yaml; then
        print_success "bdd_widget_test dependency ✓"
    else
        print_warning "bdd_widget_test dependency missing"
    fi
    
    echo ""
    
    # Recommendations
    print_header "Recommendations"
    echo ""
    
    if [ $feature_count -eq 0 ]; then
        echo "📝 Create your first .feature file with user scenarios"
        echo "💡 Run: $0 create-sample"
    elif [ $bdd_test_files -eq 0 ]; then
        echo "🔧 Create test files that use your feature files"
        echo "💡 Run: $0 generate"
    else
        echo "🚀 Run BDD tests"
        echo "💡 Run: $0 test"
        echo ""
        echo "👀 Watch for changes"
        echo "💡 Run: $0 watch"
    fi
}

# Usage help
show_help() {
    cat << EOF
BDD Test Generator and Runner for Flutter Projects (using bdd_widget_test)

Usage: $0 [command]

Commands:
  status          Show BDD project status and recommendations
  check-deps      Check and install BDD dependencies
  create-sample   Create a sample .feature file
  generate        Create template test files for .feature files
  test            Run BDD tests
  watch           Watch .feature and test files for changes
  
Examples:
  $0 status           # Check current BDD setup
  $0 create-sample    # Create example .feature file
  $0 generate         # Create template test files
  $0 test             # Run all BDD tests
  $0 watch            # Auto-run when files change

Workflow (bdd_widget_test):
  1. Create .feature files with your scenarios
  2. Run 'generate' to create template test files
  3. Customize the test files with your step definitions
  4. Run 'test' to execute BDD tests
  5. Use 'watch' for continuous development

EOF
}

# Main execution
main() {
    case "${1:-status}" in
        -h|--help)
            show_help
            ;;
        status)
            check_flutter_project
            show_bdd_status
            ;;
        check-deps)
            check_flutter_project
            check_bdd_dependencies
            ;;
        create-sample)
            check_flutter_project
            create_sample_feature
            ;;
        generate)
            check_flutter_project
            check_bdd_dependencies
            generate_test_code
            ;;
        test)
            check_flutter_project
            run_bdd_tests
            ;;
        watch)
            check_flutter_project
            watch_bdd
            ;;
        features|show)
            check_flutter_project
            show_feature_files
            ;;
        -h|--help)
            show_help
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
