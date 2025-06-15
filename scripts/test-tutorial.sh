#!/bin/bash
# Flutter Test Tutorial and Helper Script
# Interactive tutorial for learning Flutter testing with BDD/Gherkin

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

# Helper functions
wait_for_user() {
    echo ""
    echo -e "${CYAN}Press Enter to continue...${NC}"
    read -r
}

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

# Check if we're in a Flutter project
check_flutter_project() {
    if [ ! -f "pubspec.yaml" ]; then
        print_error "This doesn't appear to be a Flutter project (no pubspec.yaml found)"
        echo "Please run this script from your Flutter project root directory."
        exit 1
    fi
    
    if [ ! -d "test" ]; then
        print_warning "No test directory found. Creating one..."
        mkdir -p test
    fi
}

# Introduction
introduction() {
    clear
    print_header "🧪 Flutter Testing Tutorial"
    echo ""
    echo "Welcome to your comprehensive Flutter testing guide!"
    echo "This tutorial will teach you:"
    echo ""
    echo "  🎯 Widget testing basics"
    echo "  📝 Unit testing fundamentals"
    echo "  🥒 BDD/Gherkin testing approach"
    echo "  📊 Test coverage analysis"
    echo "  🛠️ Daily testing workflow"
    echo ""
    echo "⏱️  Estimated time: 20-30 minutes"
    echo "📚 Skill level: Beginner to Intermediate"
    echo ""
    wait_for_user
}

# Check environment
check_environment() {
    clear
    print_header "Step 1: Environment Check"
    echo ""
    print_info "Checking your Flutter testing environment..."
    echo ""
    
    # Check Flutter
    if command -v flutter &> /dev/null; then
        flutter_version=$(flutter --version | head -1)
        print_success "Flutter found: $flutter_version"
    else
        print_error "Flutter not found. Please install Flutter first."
        exit 1
    fi
    
    # Check Dart
    if command -v dart &> /dev/null; then
        dart_version=$(dart --version | head -1)
        print_success "Dart found: $dart_version"
    else
        print_error "Dart not found. This should come with Flutter."
        exit 1
    fi
    
    # Check if in Flutter project
    check_flutter_project
    print_success "Flutter project detected"
    
    # Check for test dependencies
    if grep -q "flutter_test:" pubspec.yaml; then
        print_success "flutter_test dependency found"
    else
        print_warning "flutter_test dependency not found in pubspec.yaml"
    fi
    
    # Check for BDD dependencies
    if grep -q "flutter_gherkin:" pubspec.yaml; then
        print_success "flutter_gherkin dependency found"
    else
        print_info "BDD/Gherkin dependencies not found (we'll add them later)"
    fi
    
    echo ""
    print_success "Environment check complete!"
    wait_for_user
}

# Explain testing concepts
explain_testing() {
    clear
    print_header "Step 2: Understanding Flutter Testing"
    echo ""
    print_info "Let me explain the three types of Flutter tests:"
    echo ""
    
    echo "🧪 1. UNIT TESTS"
    echo "   • Test individual functions and classes"
    echo "   • Like testing a calculator's add function"
    echo "   • Fast and focused"
    echo ""
    
    echo "🎨 2. WIDGET TESTS"
    echo "   • Test UI components and user interactions"
    echo "   • Like testing if a button tap increases a counter"
    echo "   • Test widgets in isolation"
    echo ""
    
    echo "🥒 3. BDD/GHERKIN TESTS"
    echo "   • Test user scenarios in plain English"
    echo "   • Like 'Given app is open, When I tap +, Then counter shows 1'"
    echo "   • Bridge between business and technical teams"
    echo ""
    
    if ask_yes_no "Want to see examples of each type?"; then
        echo ""
        print_step "Unit Test Example:"
        echo ""
        cat << 'EOF'
test('Calculator adds numbers correctly', () {
  final calculator = Calculator();
  final result = calculator.add(2, 3);
  expect(result, equals(5));
});
EOF
        echo ""
        
        print_step "Widget Test Example:"
        echo ""
        cat << 'EOF'
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  expect(find.text('0'), findsOneWidget);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('1'), findsOneWidget);
});
EOF
        echo ""
        
        print_step "BDD/Gherkin Example:"
        echo ""
        cat << 'EOF'
Scenario: User increments counter
  Given the app is running
  When I tap {Icons.add} icon
  Then I see {1} text
EOF
        echo ""
    fi
    
    wait_for_user
}

# Run first tests
run_first_tests() {
    clear
    print_header "Step 3: Running Your First Tests"
    echo ""
    print_info "Let's run the existing tests in your project..."
    echo ""
    
    if ask_yes_no "Ready to run flutter test?"; then
        echo ""
        print_step "Running: flutter test"
        echo ""
        
        if flutter test; then
            print_success "All tests passed! 🎉"
            echo ""
            print_info "Great! Your testing environment is working correctly."
        else
            print_warning "Some tests failed. Don't worry - this is normal!"
            echo ""
            print_info "Failed tests show us what needs to be fixed."
            echo "The error messages above tell you exactly what's wrong."
        fi
    fi
    
    echo ""
    
    if ask_yes_no "Want to run tests with verbose output to see more details?"; then
        echo ""
        print_step "Running: flutter test --verbose"
        echo ""
        flutter test --verbose || print_info "Tests completed (some may have failed)"
    fi
    
    echo ""
    wait_for_user
}

# Write first test
write_first_test() {
    clear
    print_header "Step 4: Writing Your First Test"
    echo ""
    print_info "Let's write a simple test together!"
    echo ""
    
    # Check if main widget test exists
    if [ -f "test/widget_test.dart" ]; then
        print_info "Found existing widget_test.dart file"
        echo ""
        if ask_yes_no "Want to add a new test to this file?"; then
            echo ""
            print_step "Adding a test for the minus button..."
            
            # Create backup
            cp test/widget_test.dart test/widget_test.dart.backup
            
            # Add new test
            cat >> test/widget_test.dart << 'EOF'

testWidgets('Counter decrements when minus button is tapped', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // First, increment to 1 (so we have something to decrement)
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  // Verify we're at 1
  expect(find.text('1'), findsOneWidget);

  // NOW TEST: Tap the minus button
  await tester.tap(find.byIcon(Icons.remove));
  await tester.pump();

  // Verify that our counter has decremented back to 0
  expect(find.text('0'), findsOneWidget);
});
EOF
            
            print_success "Added new test for minus button!"
            echo ""
            
            if ask_yes_no "Want to run the tests to see if our new test works?"; then
                echo ""
                print_step "Running tests with our new test..."
                if flutter test test/widget_test.dart; then
                    print_success "New test passed! 🎉"
                else
                    print_warning "Test failed - that's OK! It tells us something about our app."
                    echo ""
                    print_info "If the test failed, it might mean:"
                    echo "  • The minus button doesn't exist in your app"
                    echo "  • The minus button doesn't work as expected"
                    echo "  • This is valuable information for improving your app!"
                fi
            fi
        fi
    else
        print_warning "No widget_test.dart found. Creating a basic one..."
        cat > test/widget_test.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bdd_gherkin/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
EOF
        print_success "Created basic widget test file"
    fi
    
    echo ""
    wait_for_user
}

# Introduce BDD
introduce_bdd() {
    clear
    print_header "Step 5: Introduction to BDD/Gherkin Testing"
    echo ""
    print_info "BDD (Behavior Driven Development) lets you write tests in plain English!"
    echo ""
    
    echo "Instead of this (traditional test):"
    echo ""
    cat << 'EOF'
testWidgets('Counter increments', (tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
EOF
    echo ""
    
    echo "You write this (BDD/Gherkin):"
    echo ""
    cat << 'EOF'
Scenario: User increments counter
  Given the app is running
  When I tap {Icons.add} icon
  Then I see {1} text
EOF
    echo ""
    
    print_info "Benefits of BDD:"
    echo "  ✅ Non-technical people can understand and write tests"
    echo "  ✅ Tests serve as living documentation"
    echo "  ✅ Focus on user behavior, not technical implementation"
    echo "  ✅ Better communication between teams"
    echo ""
    
    if ask_yes_no "Want to create a BDD test for your project?"; then
        echo ""
        print_step "Creating a simple BDD feature file..."
        
        # Create feature file
        mkdir -p test
        cat > test/counter.feature << 'EOF'
Feature: Counter App
  As a user
  I want to increment and decrement a counter
  So that I can track a count

  Scenario: Increment counter
    Given the app is running
    When I tap {Icons.add} icon
    Then I see {1} text

  Scenario: Decrement counter
    Given the app is running
    When I tap {Icons.add} icon
    And I tap {Icons.remove} icon
    Then I see {0} text
EOF
        
        print_success "Created test/counter.feature"
        echo ""
        print_info "This file describes your app's behavior in plain English!"
        echo ""
        
        if ask_yes_no "Want to see the feature file?"; then
            echo ""
            print_step "Contents of test/counter.feature:"
            echo ""
            cat test/counter.feature
            echo ""
        fi
    fi
    
    wait_for_user
}

# Setup BDD dependencies
setup_bdd() {
    clear
    print_header "Step 6: Setting Up BDD Testing"
    echo ""
    print_info "To use BDD/Gherkin tests, we need to add some dependencies..."
    echo ""
    
    if ask_yes_no "Want to add BDD dependencies to your project?"; then
        echo ""
        print_step "Adding BDD dependencies to pubspec.yaml..."
        
        # Check if dev_dependencies section exists
        if grep -q "dev_dependencies:" pubspec.yaml; then
            # Add after dev_dependencies line if not already present
            if ! grep -q "flutter_gherkin:" pubspec.yaml; then
                # Create a backup
                cp pubspec.yaml pubspec.yaml.backup
                
                # Add dependencies
                sed -i '/dev_dependencies:/a\  flutter_gherkin: ^3.0.0\n  build_runner: ^2.4.0' pubspec.yaml
                print_success "Added BDD dependencies"
            else
                print_info "BDD dependencies already present"
            fi
        else
            print_warning "No dev_dependencies section found in pubspec.yaml"
            echo "You may need to add this manually:"
            echo ""
            cat << 'EOF'
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_gherkin: ^3.0.0
  build_runner: ^2.4.0
EOF
        fi
        
        echo ""
        print_step "Running: flutter pub get"
        flutter pub get
        
        echo ""
        print_success "BDD setup complete!"
        
        if [ -f "test/counter.feature" ]; then
            echo ""
            if ask_yes_no "Want to generate test code from your feature file?"; then
                echo ""
                print_step "Generating BDD test code..."
                print_info "This creates Dart test files from your .feature files"
                
                if dart run build_runner build; then
                    print_success "BDD test code generated!"
                    echo ""
                    print_info "Look for new files in the test/ directory"
                    ls -la test/ | grep -E "\.(dart|feature)$" || true
                else
                    print_warning "Code generation failed. This is normal for new BDD setups."
                    print_info "You may need to create step definition files manually."
                fi
            fi
        fi
    fi
    
    echo ""
    wait_for_user
}

# Test coverage intro
coverage_intro() {
    clear
    print_header "Step 7: Understanding Test Coverage"
    echo ""
    print_info "Test coverage shows you how much of your code is tested."
    echo ""
    
    echo "Think of it like a safety inspector checking a building:"
    echo "  🟢 Green areas = Tested code (safe)"
    echo "  🔴 Red areas = Untested code (potentially risky)"
    echo ""
    
    echo "Coverage percentages:"
    echo "  📊 95%+ = Outstanding"
    echo "  📊 90%+ = Excellent  "
    echo "  📊 80%+ = Good"
    echo "  📊 70%+ = Acceptable"
    echo "  📊 <70% = Needs work"
    echo ""
    
    if ask_yes_no "Want to check your current test coverage?"; then
        echo ""
        print_step "Running: flutter test --coverage"
        echo ""
        
        if flutter test --coverage; then
            print_success "Coverage analysis complete!"
            echo ""
            
            if [ -f "coverage/lcov.info" ]; then
                if command -v lcov &> /dev/null; then
                    print_info "Your coverage summary:"
                    echo ""
                    lcov --summary coverage/lcov.info 2>/dev/null || echo "Coverage data generated"
                else
                    print_info "Coverage data created in coverage/lcov.info"
                    print_warning "Install lcov for detailed reports: sudo apt install lcov"
                fi
                
                # Generate HTML report if possible
                if command -v genhtml &> /dev/null; then
                    echo ""
                    if ask_yes_no "Want to generate a visual HTML coverage report?"; then
                        print_step "Generating HTML report..."
                        mkdir -p coverage/html
                        genhtml coverage/lcov.info -o coverage/html/ 2>/dev/null || true
                        
                        if [ -f "coverage/html/index.html" ]; then
                            print_success "HTML report created!"
                            echo ""
                            print_info "Report location: $(pwd)/coverage/html/index.html"
                            
                            if ask_yes_no "Want to open the report in your browser?"; then
                                if command -v xdg-open &> /dev/null; then
                                    xdg-open coverage/html/index.html
                                else
                                    echo "Open this file in your browser:"
                                    echo "file://$(pwd)/coverage/html/index.html"
                                fi
                            fi
                        fi
                    fi
                fi
            else
                print_warning "No coverage data generated. You might need some tests first."
            fi
        else
            print_warning "Coverage analysis failed. This is normal if tests are failing."
        fi
    fi
    
    echo ""
    wait_for_user
}

# Daily workflow
daily_workflow() {
    clear
    print_header "Step 8: Daily Testing Workflow"
    echo ""
    print_info "Here's how to make testing part of your daily routine:"
    echo ""
    
    echo "🌅 MORNING (2 minutes):"
    echo "   flutter test                    # Quick check"
    echo ""
    
    echo "💻 WHILE CODING (30 seconds):"
    echo "   flutter test --watch           # Auto-run tests"
    echo "   flutter test --coverage        # Check coverage"
    echo ""
    
    echo "🏁 BEFORE COMMITTING (1 minute):"
    echo "   flutter test                   # Final check"
    echo "   flutter test --coverage        # Coverage check"
    echo ""
    
    if ask_yes_no "Want me to create helper scripts for your daily workflow?"; then
        echo ""
        print_step "Creating helper scripts..."
        
        # Ensure scripts directory exists
        mkdir -p scripts
        
        # Create quick test script
        if [ ! -f "scripts/quick-test.sh" ]; then
            cat > scripts/quick-test.sh << 'EOF'
#!/bin/bash
echo "🧪 Running quick test check..."
flutter test
if [ $? -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed. Check the output above."
fi
EOF
            chmod +x scripts/quick-test.sh
            print_success "Created scripts/quick-test.sh"
        fi
        
        # Create test with coverage script
        if [ ! -f "scripts/test-coverage.sh" ]; then
            cat > scripts/test-coverage.sh << 'EOF'
#!/bin/bash
echo "🧪 Running tests with coverage..."
flutter test --coverage
if [ -f "coverage/lcov.info" ]; then
    echo ""
    echo "📊 Coverage Summary:"
    if command -v lcov &> /dev/null; then
        lcov --summary coverage/lcov.info
    else
        echo "Install LCOV for detailed coverage: sudo apt install lcov"
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
EOF
            chmod +x scripts/test-coverage.sh
            print_success "Created scripts/test-coverage.sh"
        fi
        
        # Create watch script
        if [ ! -f "scripts/test-watch.sh" ]; then
            cat > scripts/test-watch.sh << 'EOF'
#!/bin/bash
echo "👀 Watching for changes... Press Ctrl+C to stop"
if command -v inotifywait &> /dev/null; then
    while inotifywait -r -e modify lib/ test/ 2>/dev/null; do
        echo "🔄 Files changed, running tests..."
        flutter test
        echo "✅ Test check complete"
        echo ""
    done
else
    echo "Install inotify-tools for file watching: sudo apt install inotify-tools"
    echo "Alternative: use 'flutter test --watch'"
fi
EOF
            chmod +x scripts/test-watch.sh
            print_success "Created scripts/test-watch.sh"
        fi
        
        echo ""
        print_success "Helper scripts ready! Try them out:"
        echo "  ./scripts/quick-test.sh         - Quick test run"
        echo "  ./scripts/test-coverage.sh      - Tests with coverage"
        echo "  ./scripts/test-watch.sh         - Auto-run when files change"
    fi
    
    echo ""
    wait_for_user
}

# Best practices
best_practices() {
    clear
    print_header "Step 9: Testing Best Practices"
    echo ""
    print_info "Here are the key principles for effective testing:"
    echo ""
    
    echo "✅ DO:"
    echo "  • Test user behavior, not implementation"
    echo "  • Write descriptive test names"
    echo "  • Keep tests independent (no shared state)"
    echo "  • Test edge cases (empty lists, null values)"
    echo "  • Use BDD for complex user scenarios"
    echo "  • Aim for 80%+ coverage on important code"
    echo ""
    
    echo "❌ DON'T:"
    echo "  • Test framework internals"
    echo "  • Make tests dependent on each other"
    echo "  • Chase 100% coverage blindly"
    echo "  • Test trivial getters/setters"
    echo "  • Ignore failing tests"
    echo "  • Write tests without clear purpose"
    echo ""
    
    echo "🎯 REMEMBER:"
    echo "  • Good tests prevent bugs from reaching users"
    echo "  • Tests are documentation of how your app should work"
    echo "  • Coverage percentage isn't everything - quality matters"
    echo "  • Start small and build testing habits gradually"
    echo ""
    
    wait_for_user
}

# Final quiz
final_quiz() {
    clear
    print_header "Step 10: Knowledge Check"
    echo ""
    print_info "Let's test what you've learned with a quick quiz!"
    echo ""
    
    local score=0
    local total=5
    
    # Question 1
    echo "❓ Question 1: What command runs all Flutter tests?"
    echo "   a) flutter run"
    echo "   b) flutter test"
    echo "   c) dart test"
    read -p "Your answer (a/b/c): " answer
    if [[ $answer == "b" || $answer == "B" ]]; then
        print_success "Correct! 'flutter test' runs all tests."
        score=$((score + 1))
    else
        print_error "Incorrect. The correct answer is 'b) flutter test'"
    fi
    echo ""
    
    # Question 2
    echo "❓ Question 2: What does BDD stand for?"
    echo "   a) Bug Driven Development"
    echo "   b) Behavior Driven Development"
    echo "   c) Basic Dart Development"
    read -p "Your answer (a/b/c): " answer
    if [[ $answer == "b" || $answer == "B" ]]; then
        print_success "Correct! BDD = Behavior Driven Development."
        score=$((score + 1))
    else
        print_error "Incorrect. BDD stands for Behavior Driven Development."
    fi
    echo ""
    
    # Question 3
    echo "❓ Question 3: What's a good test coverage percentage for most projects?"
    echo "   a) 100%"
    echo "   b) 50%"
    echo "   c) 80%+"
    read -p "Your answer (a/b/c): " answer
    if [[ $answer == "c" || $answer == "C" ]]; then
        print_success "Correct! 80%+ is generally considered good coverage."
        score=$((score + 1))
    else
        print_error "Incorrect. 80%+ is generally good - 100% is often overkill."
    fi
    echo ""
    
    # Question 4
    echo "❓ Question 4: Which finds a widget by its displayed text?"
    echo "   a) find.byIcon(Icons.add)"
    echo "   b) find.text('Hello')"
    echo "   c) find.byType(Button)"
    read -p "Your answer (a/b/c): " answer
    if [[ $answer == "b" || $answer == "B" ]]; then
        print_success "Correct! find.text() finds widgets by their text content."
        score=$((score + 1))
    else
        print_error "Incorrect. find.text('Hello') finds widgets containing that text."
    fi
    echo ""
    
    # Question 5
    echo "❓ Question 5: What should you do before committing code?"
    echo "   a) Run all tests"
    echo "   b) Check test coverage"
    echo "   c) Both a and b"
    read -p "Your answer (a/b/c): " answer
    if [[ $answer == "c" || $answer == "C" ]]; then
        print_success "Correct! Always run tests and check coverage before committing."
        score=$((score + 1))
    else
        print_error "Incorrect. You should run tests AND check coverage before committing."
    fi
    echo ""
    
    # Show results
    print_header "Quiz Results"
    echo "You got $score out of $total questions correct!"
    echo ""
    
    if [ $score -eq 5 ]; then
        print_success "🎉 Perfect score! You're ready to be a testing expert!"
    elif [ $score -ge 3 ]; then
        print_success "🎯 Great job! You understand the key concepts."
    else
        print_info "📚 Good effort! Review the tutorial to strengthen your understanding."
    fi
    
    echo ""
    wait_for_user
}

# Conclusion
conclusion() {
    clear
    print_header "🎉 Congratulations! Tutorial Complete!"
    echo ""
    print_success "You've learned the fundamentals of Flutter testing!"
    echo ""
    
    echo "🎓 What you now know:"
    echo "  ✅ How to run and write Flutter tests"
    echo "  ✅ Widget testing fundamentals"
    echo "  ✅ BDD/Gherkin testing approach"
    echo "  ✅ Test coverage analysis and interpretation"
    echo "  ✅ Daily testing workflow and best practices"
    echo ""
    
    echo "🚀 Your next steps:"
    echo "  1. Practice writing tests for your current features"
    echo "  2. Set up a daily testing routine"
    echo "  3. Explore advanced testing topics (mocking, integration tests)"
    echo "  4. Share your knowledge with your team"
    echo ""
    
    echo "📚 Documentation created for you:"
    echo "  • docs/flutter-test-walkthrough.md - Complete testing guide"
    echo "  • docs/hands-on-test-exercise.md - Practice exercises"
    echo "  • docs/test-quick-reference.md - Daily reference"
    echo "  • scripts/quick-test.sh - Quick test runner"
    echo "  • scripts/test-coverage.sh - Coverage analysis"
    echo "  • scripts/test-watch.sh - Auto-run tests"
    echo ""
    
    if ask_yes_no "Want to run a final test to make sure everything works?"; then
        echo ""
        print_step "Running final test check..."
        if ./scripts/quick-test.sh 2>/dev/null || flutter test; then
            print_success "🎯 Everything looks great!"
        else
            print_info "Some tests failed, but that's OK - now you know how to fix them!"
        fi
        echo ""
        
        if [ -f "scripts/test-coverage.sh" ]; then
            if ask_yes_no "Want to check your final test coverage?"; then
                echo ""
                ./scripts/test-coverage.sh
            fi
        fi
    fi
    
    echo ""
    print_success "🎯 You're now equipped to write high-quality, well-tested Flutter apps!"
    echo ""
    echo "Remember: The best tests prevent bugs and give you confidence to make changes!"
    echo "Happy testing! 🚀"
    echo ""
}

# Show help
show_help() {
    cat << EOF
Flutter Test Tutorial - Interactive Testing Tutorial

Usage: $0 [options]

This interactive tutorial teaches Flutter testing from scratch with
guided examples and hands-on practice. Perfect for beginners!

Options:
  -h, --help     Show this help message
  --skip-intro   Skip the introduction and environment check

Tutorial Coverage:
  • Understanding different types of tests
  • Writing your first unit tests
  • Widget testing basics
  • BDD/Gherkin approach with real examples
  • Test coverage analysis
  • Daily testing workflow
  • Best practices and tips

Duration: 20-30 minutes

Examples:
  $0             # Start the full interactive tutorial
  $0 --skip-intro # Skip introduction and start with testing

The tutorial is interactive and will guide you step by step through
Flutter testing concepts with practical examples.

EOF
}

# Main tutorial flow
main() {
    # Parse command line arguments
    local skip_intro=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --skip-intro)
                skip_intro=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Run tutorial
    if [ "$skip_intro" = false ]; then
        introduction
        check_environment
    fi
    
    explain_testing
    run_first_tests
    write_first_test
    introduce_bdd
    setup_bdd
    coverage_intro
    daily_workflow
    best_practices
    final_quiz
    conclusion
}

# Run the tutorial
main "$@"
