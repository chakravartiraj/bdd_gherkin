#!/bin/bash

# Interactive Flutter Coverage Tutorial
# A step-by-step guided walkthrough for beginners

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
    echo -e "${PURPLE}📝 $1${NC}"
}

# Wait for user input
wait_for_user() {
    echo ""
    read -p "Press Enter to continue..." -r
    echo ""
}

# Ask yes/no question
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " -r
        case $REPLY in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Introduction
introduction() {
    clear
    print_header "Welcome to Flutter Coverage Tutorial"
    echo ""
    echo "This interactive tutorial will teach you everything about Flutter test coverage."
    echo "We'll use simple explanations and hands-on practice."
    echo ""
    echo "🎯 What you'll learn:"
    echo "  • What test coverage means (in simple terms)"
    echo "  • How to run coverage analysis"
    echo "  • How to read and understand reports"
    echo "  • How to improve your coverage"
    echo "  • Daily workflow and best practices"
    echo ""
    echo "⏱️ Time needed: 15-20 minutes"
    echo "🎓 Skill level: Complete beginner"
    echo ""
    
    if ask_yes_no "Ready to start your coverage journey?"; then
        echo ""
        print_success "Great! Let's begin! 🚀"
        wait_for_user
    else
        echo "Come back when you're ready to improve your Flutter skills! 👋"
        exit 0
    fi
}

# Step 1: Explain coverage
explain_coverage() {
    clear
    print_header "Step 1: What is Test Coverage?"
    echo ""
    echo "🤔 Let me explain this simply:"
    echo ""
    echo "Imagine you're a food safety inspector at a restaurant."
    echo "Your job is to check that all the food is safe to eat."
    echo ""
    echo "🍕 Restaurant = Your Flutter app"
    echo "🔍 Your inspections = Your tests"
    echo "📊 Coverage percentage = How much food you actually checked"
    echo ""
    echo "If you only check 50% of the food, there's a 50% chance"
    echo "customers might get sick from untested food!"
    echo ""
    echo "Same with your app - untested code can have bugs! 🐛"
    echo ""
    wait_for_user
    
    echo "📈 Coverage Goals (Industry Standards):"
    echo ""
    echo "🔴 Below 70%: Risky (like checking only half the food)"
    echo "🟡 70-80%: Acceptable (getting better)"
    echo "🟢 80-90%: Good (customers trust you)"
    echo "⭐ 90%+: Excellent (food safety expert!)"
    echo ""
    wait_for_user
}

# Step 2: Check environment
check_environment() {
    clear
    print_header "Step 2: Checking Your Environment"
    echo ""
    print_info "Let's make sure you have everything needed..."
    echo ""
    
    # Check Flutter
    print_step "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        flutter_version=$(flutter --version | head -1)
        print_success "Flutter found: $flutter_version"
    else
        print_error "Flutter not found! Please install Flutter first."
        echo "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    # Check project
    print_step "Checking if you're in a Flutter project..."
    if [ -f "pubspec.yaml" ]; then
        project_name=$(grep "name:" pubspec.yaml | cut -d' ' -f2)
        print_success "Flutter project found: $project_name"
    else
        print_error "No Flutter project found!"
        echo "Make sure you're in a Flutter project directory."
        exit 1
    fi
    
    # Check LCOV
    print_step "Checking LCOV (for pretty reports)..."
    if command -v lcov &> /dev/null; then
        print_success "LCOV found"
    else
        print_warning "LCOV not found. Let me install it for you..."
        if ask_yes_no "Install LCOV now?"; then
            sudo apt update && sudo apt install -y lcov
            print_success "LCOV installed!"
        else
            print_warning "You can install it later with: sudo apt install lcov"
        fi
    fi
    
    echo ""
    print_success "Environment check complete! 🎉"
    wait_for_user
}

# Step 3: First coverage run
first_coverage_run() {
    clear
    print_header "Step 3: Your First Coverage Analysis"
    echo ""
    print_info "Now let's run your first coverage analysis!"
    echo ""
    echo "📝 What's about to happen:"
    echo "  1. Flutter will run all your tests"
    echo "  2. It will track which lines of code were executed"
    echo "  3. It will create a coverage report"
    echo ""
    
    if ask_yes_no "Ready to run your first coverage analysis?"; then
        echo ""
        print_step "Running: flutter test --coverage"
        echo ""
        
        if flutter test --coverage; then
            print_success "Coverage analysis complete!"
            echo ""
            
            if [ -f "coverage/lcov.info" ]; then
                print_success "Coverage data created: coverage/lcov.info"
                
                # Show basic summary
                if command -v lcov &> /dev/null; then
                    print_info "Your coverage summary:"
                    echo ""
                    lcov --summary coverage/lcov.info 2>/dev/null || echo "Coverage data available"
                fi
            else
                print_warning "No coverage data found. You might not have any tests yet."
            fi
        else
            print_error "Tests failed! Don't worry, this is normal when learning."
            echo "The error messages above tell you what's wrong."
        fi
    fi
    
    echo ""
    wait_for_user
}

# Step 4: Understanding results
understand_results() {
    clear
    print_header "Step 4: Understanding Your Results"
    echo ""
    
    if [ ! -f "coverage/lcov.info" ]; then
        print_warning "No coverage data found. Let's understand what results look like:"
        echo ""
        echo "📊 Example coverage summary:"
        echo "  source files: 3"
        echo "  lines.......: 85.7% (24 of 28 lines)"
        echo "  functions...: 90.0% (9 of 10 functions)"
        echo ""
    else
        print_info "Let's understand your actual results:"
        echo ""
        if command -v lcov &> /dev/null; then
            lcov --summary coverage/lcov.info 2>/dev/null || echo "Coverage data available"
        fi
        echo ""
    fi
    
    echo "🔍 What each number means:"
    echo ""
    echo "📁 Source files: How many code files were analyzed"
    echo "📏 Lines: What % of code lines were tested"
    echo "🔧 Functions: What % of functions were tested"
    echo ""
    echo "💡 The 'Lines' percentage is most important!"
    echo ""
    
    wait_for_user
    
    echo "📊 How to interpret your score:"
    echo ""
    if [ -f "coverage/lcov.info" ] && command -v lcov &> /dev/null; then
        coverage=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | grep -o '[0-9.]*%' | head -1)
        if [ ! -z "$coverage" ]; then
            number=$(echo "$coverage" | grep -o '[0-9.]*' | head -1)
            echo "Your current coverage: $coverage"
            echo ""
            
            if (( $(echo "$number >= 90" | bc -l 2>/dev/null) )); then
                print_success "🟢 EXCELLENT! You're testing almost everything!"
            elif (( $(echo "$number >= 80" | bc -l 2>/dev/null) )); then
                print_success "🟡 GOOD! You have solid coverage."
            elif (( $(echo "$number >= 70" | bc -l 2>/dev/null) )); then
                print_warning "🟠 ACCEPTABLE, but could be better."
            else
                print_warning "🔴 NEEDS WORK. Add more tests for safety."
            fi
            echo ""
        fi
    fi
    
    echo "🎯 Remember: Quality over quantity!"
    echo "   Better to have 80% good coverage than 95% meaningless coverage."
    echo ""
    
    wait_for_user
}

# Step 5: Visual report
show_visual_report() {
    clear
    print_header "Step 5: The Visual Coverage Report"
    echo ""
    
    if [ -f "coverage/lcov.info" ]; then
        print_info "Let's create a beautiful HTML report you can click through!"
        echo ""
        
        if command -v genhtml &> /dev/null; then
            print_step "Generating HTML report..."
            
            mkdir -p coverage/html
            if genhtml coverage/lcov.info --output-directory coverage/html --title "Your Flutter Coverage Report" 2>/dev/null; then
                print_success "HTML report created!"
                echo ""
                echo "📱 Your report is ready at: coverage/html/index.html"
                echo ""
                
                if ask_yes_no "Open the visual report in your browser?"; then
                    if command -v xdg-open &> /dev/null; then
                        xdg-open coverage/html/index.html
                        print_success "Report opened in browser!"
                    else
                        echo "Open this file in your browser: $(pwd)/coverage/html/index.html"
                    fi
                fi
            else
                print_warning "Could not generate HTML report, but that's okay!"
            fi
        else
            print_info "HTML report generation needs genhtml (part of lcov)"
            echo "Your coverage data is still available in coverage/lcov.info"
        fi
    else
        print_info "No coverage data yet. When you have it, here's how to read the visual report:"
        echo ""
        echo "🎨 In the HTML report you'll see:"
        echo "  🟢 Green lines = Tested code (good!)"
        echo "  🔴 Red lines = Untested code (needs tests!)"
        echo "  ⚪ White lines = Comments (ignore these)"
        echo ""
        echo "📊 Click on any file name to see detailed line-by-line coverage"
    fi
    
    echo ""
    wait_for_user
}

# Step 6: Improving coverage
improve_coverage() {
    clear
    print_header "Step 6: How to Improve Your Coverage"
    echo ""
    print_info "Here's the simple process to improve coverage:"
    echo ""
    echo "🔍 Step 1: Find untested code (red lines in report)"
    echo "✍️ Step 2: Write tests for that code"
    echo "🔄 Step 3: Run coverage again"
    echo "📈 Step 4: See your improvement!"
    echo ""
    
    echo "💡 Smart strategy - Test these first:"
    echo "  1. 🎯 Main features (what users do most)"
    echo "  2. 🚨 Error conditions (what could go wrong)"
    echo "  3. 🎢 Edge cases (empty lists, null values, etc.)"
    echo ""
    
    echo "⚡ Quick wins - Easy tests to write:"
    echo "  • Test that widgets can be created"
    echo "  • Test button clicks"
    echo "  • Test simple calculations"
    echo "  • Test text displays correctly"
    echo ""
    
    if [ -d "test" ]; then
        echo "🔍 You have tests in your test/ directory:"
        ls test/ | head -5
        if [ $(ls test/ | wc -l) -gt 5 ]; then
            echo "... and more"
        fi
        echo ""
        
        if ask_yes_no "Want to see an example test you could add?"; then
            echo ""
            echo "📝 Example test to improve coverage:"
            echo ""
            cat << 'EOF'
testWidgets('App displays welcome message', (WidgetTester tester) async {
  // Build the app
  await tester.pumpWidget(MyApp());
  
  // Check that welcome text appears
  expect(find.text('Welcome'), findsOneWidget);
  
  // This test will cover the lines that display the welcome message!
});
EOF
            echo ""
            echo "💡 Copy this pattern and change 'Welcome' to text in your app!"
        fi
    else
        print_info "You don't have a test/ directory yet."
        if ask_yes_no "Want me to show you how to create your first test?"; then
            echo ""
            echo "📝 Create a file called test/widget_test.dart with this content:"
            echo ""
            cat << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/main.dart'; // Replace 'your_app' with your app name

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    
    // Verify that our app doesn't crash
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
EOF
            echo ""
            print_success "This simple test will give you some basic coverage!"
        fi
    fi
    
    echo ""
    wait_for_user
}

# Step 7: Daily workflow
daily_workflow() {
    clear
    print_header "Step 7: Making Coverage Part of Your Daily Routine"
    echo ""
    print_info "Here's how to use coverage every day:"
    echo ""
    
    echo "🌅 Morning (2 minutes):"
    echo "   ./scripts/quick-coverage.sh"
    echo "   👀 Check your starting coverage"
    echo ""
    
    echo "💻 While coding (30 seconds):"
    echo "   flutter test --coverage"
    echo "   👀 See what your new code covers"
    echo ""
    
    echo "🌙 Before committing (1 minute):"
    echo "   ./scripts/quick-coverage.sh"
    echo "   👀 Make sure coverage didn't drop"
    echo ""
    
    if ask_yes_no "Want me to create these helper scripts for you?"; then
        echo ""
        print_step "Creating helper scripts..."
        
        # Ensure scripts directory exists
        mkdir -p scripts
        
        # Create quick coverage script if it doesn't exist
        if [ ! -f "scripts/quick-coverage.sh" ]; then
            cat > scripts/quick-coverage.sh << 'EOF'
#!/bin/bash
echo "🧪 Running quick coverage check..."
flutter test --coverage
if [ -f "coverage/lcov.info" ]; then
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
            print_success "Created scripts/quick-coverage.sh"
        fi
        
        # Create watch script if it doesn't exist
        if [ ! -f "scripts/watch-coverage.sh" ]; then
            cat > scripts/watch-coverage.sh << 'EOF'
#!/bin/bash
echo "👀 Watching for changes... Press Ctrl+C to stop"
if command -v inotifywait &> /dev/null; then
    while inotifywait -r -e modify lib/ test/ 2>/dev/null; do
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
            print_success "Created scripts/watch-coverage.sh"
        fi
        
        echo ""
        print_success "Helper scripts ready! Try them out:"
        echo "  ./scripts/quick-coverage.sh    - Quick coverage check"
        echo "  ./scripts/watch-coverage.sh    - Auto-run when files change"
    fi
    
    echo ""
    wait_for_user
}

# Step 8: Best practices
best_practices() {
    clear
    print_header "Step 8: Coverage Best Practices"
    echo ""
    print_info "🎓 Professional tips for success:"
    echo ""
    
    echo "✅ DO:"
    echo "  • Focus on testing important functionality first"
    echo "  • Use coverage to find gaps, not as a score to maximize"
    echo "  • Write meaningful tests that catch real bugs"
    echo "  • Check coverage before committing code"
    echo "  • Aim for 80-90% coverage on important files"
    echo ""
    
    echo "❌ DON'T:"
    echo "  • Chase 100% coverage (it's often not worth it)"
    echo "  • Write tests just to increase the percentage"
    echo "  • Test every single getter/setter method"
    echo "  • Ignore coverage drops when adding new code"
    echo "  • Skip testing error conditions"
    echo ""
    
    echo "🎯 Smart testing priorities:"
    echo "  1. 🚀 Core app functionality"
    echo "  2. 👤 User interaction flows"
    echo "  3. 🚨 Error handling"
    echo "  4. 🎲 Edge cases"
    echo "  5. 🔧 Utility functions"
    echo ""
    
    echo "💡 Remember: Good coverage gives you confidence to change code!"
    echo "   When you refactor, your tests will tell you if you broke anything."
    echo ""
    
    wait_for_user
}

# Final quiz
final_quiz() {
    clear
    print_header "Step 9: Quick Knowledge Check"
    echo ""
    print_info "Let's see what you learned! (Don't worry, this is just for fun)"
    echo ""
    
    score=0
    total=5
    
    # Question 1
    echo "❓ Question 1: What does 85% line coverage mean?"
    echo "   a) 85% of your app works correctly"
    echo "   b) 85% of your code lines were tested"
    echo "   c) Your app is 85% complete"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! 85% of code lines were executed during testing."
        score=$((score + 1))
    else
        print_error "Not quite. The answer is 'b' - percentage of lines tested."
    fi
    echo ""
    
    # Question 2
    echo "❓ Question 2: What color represents untested code in coverage reports?"
    echo "   a) Green"
    echo "   b) Red"
    echo "   c) Blue"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! Red means untested code that needs attention."
        score=$((score + 1))
    else
        print_error "Not quite. Red lines = untested code."
    fi
    echo ""
    
    # Question 3
    echo "❓ Question 3: What's a good coverage target for most projects?"
    echo "   a) 60-70%"
    echo "   b) 80-90%"
    echo "   c) 100%"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! 80-90% is an excellent target for most projects."
        score=$((score + 1))
    else
        print_error "Not quite. 80-90% is the sweet spot for most projects."
    fi
    echo ""
    
    # Question 4
    echo "❓ Question 4: When should you check coverage?"
    echo "   a) Only when you're done with the project"
    echo "   b) Daily, as part of your development workflow"
    echo "   c) Never, tests are enough"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! Coverage should be part of your daily routine."
        score=$((score + 1))
    else
        print_error "Not quite. Check coverage daily for best results."
    fi
    echo ""
    
    # Question 5
    echo "❓ Question 5: What's the main purpose of test coverage?"
    echo "   a) To get a high percentage score"
    echo "   b) To find untested areas that might have bugs"
    echo "   c) To slow down development"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! Coverage helps you find potentially buggy untested areas."
        score=$((score + 1))
    else
        print_error "Not quite. Coverage helps find areas that need testing."
    fi
    echo ""
    
    # Show results
    print_header "Quiz Results"
    echo "You got $score out of $total questions correct!"
    echo ""
    
    if [ $score -eq 5 ]; then
        print_success "🎉 Perfect score! You're ready to be a coverage pro!"
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
    print_success "You've learned everything about Flutter test coverage!"
    echo ""
    
    echo "🎓 What you now know:"
    echo "  ✅ What test coverage means and why it matters"
    echo "  ✅ How to run coverage analysis"
    echo "  ✅ How to read and interpret coverage reports"
    echo "  ✅ How to improve your coverage systematically"
    echo "  ✅ How to make coverage part of your daily workflow"
    echo "  ✅ Best practices for professional development"
    echo ""
    
    echo "🚀 Your next steps:"
    echo "  1. Run ./scripts/quick-coverage.sh on your current project"
    echo "  2. Open the HTML report and explore it"
    echo "  3. Find 2-3 untested areas and write tests for them"
    echo "  4. Set a coverage goal (suggest: 80%+)"
    echo "  5. Make coverage checks part of your daily routine"
    echo ""
    
    echo "📚 Documentation created for you:"
    echo "  • docs/flutter-coverage-walkthrough.md - Complete guide"
    echo "  • docs/hands-on-coverage-exercise.md - Practice exercises"
    echo "  • docs/coverage-quick-reference.md - Quick reference"
    echo "  • scripts/quick-coverage.sh - Daily coverage script"
    echo "  • scripts/watch-coverage.sh - Auto-run script"
    echo ""
    
    if ask_yes_no "Want to run a quick coverage check on your project now?"; then
        echo ""
        print_step "Running final coverage check..."
        ./scripts/quick-coverage.sh || flutter test --coverage
        echo ""
        print_success "Coverage analysis complete!"
        echo ""
        
        if [ -f "coverage/html/index.html" ]; then
            if ask_yes_no "Open the visual report to explore?"; then
                xdg-open coverage/html/index.html 2>/dev/null || echo "Open: $(pwd)/coverage/html/index.html"
            fi
        fi
    fi
    
    echo ""
    print_success "🎯 You're now equipped to write high-quality, well-tested Flutter apps!"
    echo ""
    echo "Remember: Coverage isn't about the number - it's about confidence!"
    echo "Happy coding! 🚀"
    echo ""
}

# Show help
show_help() {
    cat << EOF
Flutter Coverage Tutorial - Interactive Coverage Analysis Tutorial

Usage: $0 [options]

This interactive tutorial teaches Flutter test coverage analysis from
scratch with guided examples and hands-on practice. Perfect for beginners!

Options:
  -h, --help     Show this help message
  --skip-intro   Skip the introduction and environment check

Tutorial Coverage:
  • Understanding what test coverage means
  • Running your first coverage analysis
  • Reading and interpreting coverage reports
  • Generating visual HTML reports
  • Improving coverage effectively
  • Daily coverage workflow
  • Best practices and tips

Duration: 20-30 minutes

Examples:
  $0             # Start the full interactive tutorial
  $0 --skip-intro # Skip introduction and start with coverage

The tutorial is interactive and will guide you step by step through
Flutter test coverage concepts with practical examples.

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
        explain_coverage
        check_environment
    fi
    
    first_coverage_run
    understand_results
    show_visual_report
    improve_coverage
    daily_workflow
    best_practices
    final_quiz
    conclusion
}

# Run the tutorial
main "$@"
