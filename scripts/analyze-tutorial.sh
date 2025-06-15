#!/bin/bash

# Interactive Flutter Analyze Tutorial
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
    echo -e "${BLUE}🔍 === $1 ===${NC}"
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
    print_header "Welcome to Flutter Analyze Tutorial"
    echo ""
    echo "This interactive tutorial will teach you everything about Flutter's static analysis."
    echo "Think of it as having a super-smart code reviewer that never gets tired!"
    echo ""
    echo "🎯 What you'll learn:"
    echo "  • What Flutter Analyze does (and why it's awesome)"
    echo "  • How to run analysis and understand results"
    echo "  • How to fix common issues like a pro"
    echo "  • How to customize rules for your needs"
    echo "  • Daily workflow integration"
    echo ""
    echo "⏱️ Time needed: 20-25 minutes"
    echo "🎓 Skill level: Complete beginner"
    echo ""
    
    if ask_yes_no "Ready to become a Flutter analysis expert?"; then
        echo ""
        print_success "Excellent! Let's dive in! 🚀"
        wait_for_user
    else
        echo "Come back when you're ready to level up your Flutter skills! 👋"
        exit 0
    fi
}

# Step 1: Explain what analyzer does
explain_analyzer() {
    clear
    print_header "Step 1: What is Flutter Analyze?"
    echo ""
    echo "🤔 Let me explain this with a simple analogy:"
    echo ""
    echo "Imagine you're writing an important email to your boss."
    echo "Before you send it, you use spell-check and grammar-check to catch:"
    echo ""
    echo "📝 Spelling mistakes → Code syntax errors"
    echo "📖 Grammar issues → Code style problems"
    echo "🎨 Style inconsistencies → Naming conventions"
    echo "💡 Better word suggestions → Performance improvements"
    echo ""
    echo "Flutter Analyze is like having the world's best grammar checker"
    echo "for your Dart/Flutter code!"
    echo ""
    wait_for_user
    
    echo "🎯 Real example of what it catches:"
    echo ""
    cat << 'EOF'
// BEFORE (problematic code):
import 'package:http/http.dart';  // Unused import
class myWidget extends StatelessWidget {  // Bad naming
  Widget build(context) {  // Missing type annotation
    return Text("Hello");  // Should use single quotes + const
  }
}

// AFTER (analyzer suggestions applied):
class MyWidget extends StatelessWidget {  // Fixed naming
  @override
  Widget build(BuildContext context) {  // Added type
    return const Text('Hello');  // Added const + single quotes
  }
}
EOF
    echo ""
    print_success "See how much better the code became? That's the power of analysis!"
    wait_for_user
}

# Step 2: Check environment
check_environment() {
    clear
    print_header "Step 2: Checking Your Environment"
    echo ""
    print_info "Let's make sure everything is set up correctly..."
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
    
    # Check analysis options
    print_step "Checking analysis configuration..."
    if [ -f "analysis_options.yaml" ]; then
        rules_count=$(grep -c "rules:" analysis_options.yaml || echo "0")
        print_success "Analysis configuration found with custom rules"
    else
        print_warning "No analysis_options.yaml found. I'll help you create one."
    fi
    
    echo ""
    print_success "Environment check complete! 🎉"
    wait_for_user
}

# Step 3: First analysis run
first_analysis() {
    clear
    print_header "Step 3: Your First Analysis Run"
    echo ""
    print_info "Time to run Flutter Analyze and see what it finds!"
    echo ""
    echo "📝 What's about to happen:"
    echo "  1. Flutter will scan all your Dart files"
    echo "  2. It will check for errors, warnings, and style issues"
    echo "  3. It will give you a detailed report"
    echo ""
    
    if ask_yes_no "Ready to run your first analysis?"; then
        echo ""
        print_step "Running: flutter analyze"
        echo ""
        
        # Capture the exit code
        if flutter analyze; then
            analysis_exit_code=0
        else
            analysis_exit_code=1
        fi
        
        echo ""
        if [ $analysis_exit_code -eq 0 ]; then
            print_success "🎉 Congratulations! No issues found!"
            echo "Your code follows Dart/Flutter best practices."
            echo "This is the goal we want to maintain every day."
        else
            print_info "Found some issues - this is totally normal!"
            echo "Even experienced developers see analyzer warnings."
            echo "The important thing is learning how to fix them."
        fi
    fi
    
    echo ""
    wait_for_user
}

# Step 4: Understanding results
understand_results() {
    clear
    print_header "Step 4: Understanding Analysis Results"
    echo ""
    
    echo "📊 Let me teach you how to read analyzer output:"
    echo ""
    echo "Example output format:"
    echo "info • Prefer single quotes • lib/main.dart:15:20 • prefer_single_quotes"
    echo "│    │  │                   │               │   │   │"
    echo "│    │  │                   │               │   │   └── Rule name"
    echo "│    │  │                   │               │   └──── Column number"
    echo "│    │  │                   │               └────── Line number"
    echo "│    │  │                   └────────────────────── File path"
    echo "│    │  └────────────────────────────────────────── Description"
    echo "│    └───────────────────────────────────────────── Issue type"
    echo "└────────────────────────────────────────────────── Severity level"
    echo ""
    
    wait_for_user
    
    echo "🚦 Severity levels you'll see:"
    echo ""
    echo "🔴 error   - Code won't compile or will crash"
    echo "🟡 warning - Potential runtime problems"
    echo "🔵 info    - Style suggestions and best practices"
    echo ""
    echo "💡 Priority order: Fix errors first, then warnings, then info."
    echo ""
    
    wait_for_user
    
    echo "🎯 Let's analyze what these mean in real code:"
    echo ""
    echo "🔴 ERROR Example:"
    echo "   int number = 'hello';  // Can't assign String to int"
    echo ""
    echo "🟡 WARNING Example:"
    echo "   String? name;"
    echo "   print(name.length);    // name might be null!"
    echo ""
    echo "🔵 INFO Example:"
    echo "   return Text(\"Hello\");  // Should use single quotes"
    echo ""
    
    wait_for_user
}

# Step 5: Demonstrate issue fixing
demonstrate_fixing() {
    clear
    print_header "Step 5: Learning to Fix Issues"
    echo ""
    print_info "Let's create a file with some issues and fix them together!"
    echo ""
    
    if ask_yes_no "Ready to practice fixing analyzer issues?"; then
        echo ""
        print_step "Creating a demo file with intentional issues..."
        
        # Create demo file with issues
        cat > lib/demo_fix_example.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class demoWidget extends StatelessWidget {
  demoWidget({Key? key}) : super(key: key);
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body: Center(child: Text("Hello World")),
    );
  }
}
EOF
        
        print_success "Demo file created: lib/demo_fix_example.dart"
        echo ""
        
        print_step "Running analysis on the demo file..."
        echo ""
        flutter analyze lib/demo_fix_example.dart || true
        echo ""
        
        print_info "Now let's fix these issues one by one!"
        wait_for_user
        
        # Fix 1: Remove unused import
        print_step "Fix 1: Removing unused import..."
        sed -i '/import.*http/d' lib/demo_fix_example.dart
        print_success "Removed unused http import"
        echo ""
        
        # Fix 2: Fix class naming
        print_step "Fix 2: Fixing class name (PascalCase)..."
        sed -i 's/class demoWidget/class DemoWidget/g' lib/demo_fix_example.dart
        sed -i 's/demoWidget(/DemoWidget(/g' lib/demo_fix_example.dart
        print_success "Fixed class name to DemoWidget"
        echo ""
        
        # Fix 3: Add const keywords
        print_step "Fix 3: Adding const keywords for performance..."
        sed -i 's/Text("Demo")/const Text("Demo")/g' lib/demo_fix_example.dart
        sed -i 's/Text("Hello World")/const Text("Hello World")/g' lib/demo_fix_example.dart
        print_success "Added const keywords"
        echo ""
        
        # Fix 4: Fix quotes
        print_step "Fix 4: Converting to single quotes..."
        sed -i "s/\"Demo\"/'Demo'/g" lib/demo_fix_example.dart
        sed -i "s/\"Hello World\"/'Hello World'/g" lib/demo_fix_example.dart
        print_success "Converted to single quotes"
        echo ""
        
        print_step "Running analysis again to see our progress..."
        echo ""
        flutter analyze lib/demo_fix_example.dart || true
        echo ""
        
        print_success "🎉 Look at that improvement! Much cleaner code!"
        echo ""
        
        if ask_yes_no "Want to see the final cleaned-up code?"; then
            echo ""
            print_info "Final clean code:"
            echo ""
            cat lib/demo_fix_example.dart
        fi
        
        # Clean up
        rm -f lib/demo_fix_example.dart
        print_info "Demo file cleaned up."
    fi
    
    echo ""
    wait_for_user
}

# Step 6: Auto-fix demonstration
auto_fix_demo() {
    clear
    print_header "Step 6: The Magic of Auto-Fix"
    echo ""
    print_info "Dart has a superpower: it can fix many issues automatically!"
    echo ""
    
    echo "🎩 The auto-fix command: dart fix --apply"
    echo ""
    echo "What it can fix automatically:"
    echo "  ✅ Add missing const keywords"
    echo "  ✅ Replace deprecated widgets"
    echo "  ✅ Fix simple syntax issues"
    echo "  ✅ Update import statements"
    echo ""
    echo "What it can't fix (needs human judgment):"
    echo "  ❌ Complex logic errors"
    echo "  ❌ API design decisions"
    echo "  ❌ Variable naming"
    echo ""
    
    if ask_yes_no "Want to see auto-fix in action on your project?"; then
        echo ""
        print_step "Running: dart fix --apply"
        echo ""
        
        dart fix --apply || true
        
        echo ""
        print_step "Checking what changed..."
        flutter analyze
        
        echo ""
        print_success "Auto-fix complete! Many issues can be resolved this easily."
    fi
    
    echo ""
    wait_for_user
}

# Step 7: IDE integration
ide_integration() {
    clear
    print_header "Step 7: IDE Integration (Real-Time Analysis)"
    echo ""
    print_info "The best way to use Flutter Analyze is through your IDE!"
    echo ""
    
    echo "🎨 What you'll see in VS Code or Android Studio:"
    echo ""
    echo "🔴 Red squiggly lines → Errors (fix immediately)"
    echo "🟡 Yellow squiggly lines → Warnings (fix soon)"
    echo "🔵 Blue squiggly lines → Info/style suggestions"
    echo "💡 Light bulb icon → Quick fixes available"
    echo ""
    
    echo "⚡ Pro tips for IDE usage:"
    echo ""
    echo "1. Hover over squiggly lines to see details"
    echo "2. Click the light bulb for automatic fixes"
    echo "3. Use Ctrl+Shift+P → 'Dart: Restart Language Server' if issues"
    echo "4. Enable 'Format on Save' to auto-fix formatting"
    echo ""
    
    if ask_yes_no "Do you have VS Code or Android Studio installed?"; then
        echo ""
        print_success "Great! Make sure you have the Dart/Flutter extensions installed."
        echo ""
        echo "📚 Next time you code:"
        echo "  • Watch for squiggly lines as you type"
        echo "  • Use quick fixes (💡) when available"
        echo "  • Your code quality will improve automatically!"
    else
        print_info "Consider installing VS Code with the Flutter extension for the best experience."
    fi
    
    echo ""
    wait_for_user
}

# Step 8: Customization
customization() {
    clear
    print_header "Step 8: Customizing Rules for Your Needs"
    echo ""
    print_info "You can adjust analyzer rules to fit your project's needs!"
    echo ""
    
    echo "📝 Your analysis_options.yaml file controls:"
    echo "  • Which rules are enabled/disabled"
    echo "  • Severity levels (error/warning/info)"
    echo "  • Which files to exclude"
    echo ""
    
    if ask_yes_no "Want to see your current analysis configuration?"; then
        echo ""
        print_step "Your current analysis_options.yaml:"
        echo ""
        if [ -f "analysis_options.yaml" ]; then
            head -20 analysis_options.yaml
            echo ""
            echo "... (showing first 20 lines)"
        else
            print_warning "No analysis_options.yaml found."
        fi
    fi
    
    echo ""
    echo "🔧 Common customizations:"
    echo ""
    echo "Disable a rule you don't like:"
    echo "  prefer_single_quotes: false"
    echo ""
    echo "Make a warning into an error:"
    echo "  analyzer:"
    echo "    errors:"
    echo "      unused_import: error"
    echo ""
    echo "Exclude generated files:"
    echo "  analyzer:"
    echo "    exclude:"
    echo "      - '**/*.g.dart'"
    echo ""
    
    wait_for_user
}

# Step 9: Daily workflow
daily_workflow() {
    clear
    print_header "Step 9: Making Analysis Part of Your Daily Routine"
    echo ""
    print_info "Here's how to use Flutter Analyze every day like a pro:"
    echo ""
    
    echo "🌅 Morning (2 minutes):"
    echo "   flutter analyze"
    echo "   👀 Check if any issues crept in overnight"
    echo ""
    
    echo "💻 While coding (continuous):"
    echo "   Watch IDE squiggly lines"
    echo "   👀 Fix issues as you type"
    echo ""
    
    echo "🔧 Before testing (30 seconds):"
    echo "   dart fix --apply"
    echo "   👀 Auto-fix simple issues"
    echo ""
    
    echo "🌙 Before committing (1 minute):"
    echo "   flutter analyze"
    echo "   👀 Ensure clean code before sharing"
    echo ""
    
    if ask_yes_no "Want me to create a helper script for your daily workflow?"; then
        echo ""
        print_step "Creating daily analysis script..."
        
        cat > scripts/daily-analyze.sh << 'EOF'
#!/bin/bash
echo "🔍 Daily Flutter Analysis Check"
echo "==============================="

echo ""
echo "🧹 Step 1: Auto-fixing common issues..."
dart fix --apply

echo ""
echo "📊 Step 2: Running full analysis..."
flutter analyze

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All good! Your code is clean and ready. 🎉"
else
    echo ""
    echo "📝 Found some issues to fix. Use your IDE or manual fixes."
    echo "💡 Tip: Many issues can be fixed with IDE quick fixes (💡 icon)"
fi

echo ""
echo "🎯 Keep up the great work! Clean code = happy developers."
EOF
        
        chmod +x scripts/daily-analyze.sh
        print_success "Created scripts/daily-analyze.sh"
        echo ""
        print_info "Usage: ./scripts/daily-analyze.sh"
    fi
    
    echo ""
    wait_for_user
}

# Final quiz
final_quiz() {
    clear
    print_header "Step 10: Quick Knowledge Check"
    echo ""
    print_info "Let's see what you learned! (Don't worry, this is just for fun)"
    echo ""
    
    score=0
    total=5
    
    # Question 1
    echo "❓ Question 1: What does Flutter Analyze primarily help you with?"
    echo "   a) Running your app faster"
    echo "   b) Finding code issues before runtime"
    echo "   c) Creating better UI designs"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! It finds issues during development, not runtime."
        score=$((score + 1))
    else
        print_error "Not quite. The answer is 'b' - it finds code issues early."
    fi
    echo ""
    
    # Question 2
    echo "❓ Question 2: Which severity level should you fix first?"
    echo "   a) Info (blue squiggly lines)"
    echo "   b) Warnings (yellow squiggly lines)"
    echo "   c) Errors (red squiggly lines)"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "c" || "$answer" == "C" ]]; then
        print_success "Correct! Errors can prevent your code from compiling."
        score=$((score + 1))
    else
        print_error "Not quite. Fix errors (red) first, then warnings, then info."
    fi
    echo ""
    
    # Question 3
    echo "❓ Question 3: What command can automatically fix many issues?"
    echo "   a) flutter fix"
    echo "   b) dart fix --apply"
    echo "   c) flutter analyze --fix"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! 'dart fix --apply' is the magic auto-fix command."
        score=$((score + 1))
    else
        print_error "Not quite. The command is 'dart fix --apply'."
    fi
    echo ""
    
    # Question 4
    echo "❓ Question 4: What file controls analyzer rules?"
    echo "   a) pubspec.yaml"
    echo "   b) analysis_options.yaml"
    echo "   c) flutter_options.yaml"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! analysis_options.yaml is the analyzer's rule book."
        score=$((score + 1))
    else
        print_error "Not quite. The file is 'analysis_options.yaml'."
    fi
    echo ""
    
    # Question 5
    echo "❓ Question 5: When should you run 'flutter analyze'?"
    echo "   a) Only when something is broken"
    echo "   b) Daily, as part of your development routine"
    echo "   c) Only before releasing to production"
    echo ""
    read -p "Your answer (a/b/c): " answer
    if [[ "$answer" == "b" || "$answer" == "B" ]]; then
        print_success "Correct! Daily analysis keeps your code healthy."
        score=$((score + 1))
    else
        print_error "Not quite. Run analysis daily for best results."
    fi
    echo ""
    
    # Show results
    print_header "Quiz Results"
    echo "You got $score out of $total questions correct!"
    echo ""
    
    if [ $score -eq 5 ]; then
        print_success "🎉 Perfect score! You're ready to be an analysis pro!"
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
    print_success "You've mastered Flutter Analyze from the ground up!"
    echo ""
    
    echo "🎓 What you now know:"
    echo "  ✅ What Flutter Analyze does and why it's important"
    echo "  ✅ How to run analysis and interpret results"
    echo "  ✅ How to fix issues manually and automatically"
    echo "  ✅ How to customize rules for your needs"
    echo "  ✅ How to integrate analysis into your daily workflow"
    echo "  ✅ How to use IDE integration effectively"
    echo ""
    
    echo "🚀 Your next steps:"
    echo "  1. Run ./scripts/daily-analyze.sh every morning"
    echo "  2. Watch for squiggly lines in your IDE and fix them"
    echo "  3. Use 'dart fix --apply' before committing code"
    echo "  4. Customize analysis_options.yaml for your team"
    echo "  5. Help teammates understand analyzer benefits"
    echo ""
    
    echo "📚 Documentation created for you:"
    echo "  • docs/flutter-analyze-walkthrough.md - Complete guide"
    echo "  • docs/hands-on-analyze-exercise.md - Practice exercises"
    echo "  • scripts/daily-analyze.sh - Daily workflow script"
    echo ""
    
    if ask_yes_no "Want to run a final analysis check on your project?"; then
        echo ""
        print_step "Running final analysis check..."
        flutter analyze
        echo ""
        
        if [ $? -eq 0 ]; then
            print_success "🎉 Perfect! Your project has no analyzer issues!"
        else
            print_info "Found some issues - now you know how to fix them!"
        fi
    fi
    
    echo ""
    print_success "🔍 You're now equipped to write clean, professional Flutter code!"
    echo ""
    echo "Remember: The analyzer is your coding partner, not your critic!"
    echo "Every issue it finds is a chance to improve your skills."
    echo ""
    print_success "Happy analyzing! 🚀"
    echo ""
}

# Show help
show_help() {
    cat << EOF
Flutter Analyze Tutorial - Interactive Code Analysis Tutorial

Usage: $0 [options]

This interactive tutorial teaches Flutter static code analysis from
scratch with guided examples and hands-on practice. Perfect for beginners!

Options:
  -h, --help     Show this help message
  --skip-intro   Skip the introduction and environment check

Tutorial Coverage:
  • Understanding static code analysis
  • Running your first flutter analyze
  • Reading and interpreting analysis results
  • Fixing common code issues
  • Auto-fix capabilities
  • IDE integration tips
  • Customizing analysis rules
  • Daily analysis workflow

Duration: 20-30 minutes

Examples:
  $0             # Start the full interactive tutorial
  $0 --skip-intro # Skip introduction and start with analysis

The tutorial is interactive and will guide you step by step through
Flutter code analysis concepts with practical examples.

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
        explain_analyzer
        check_environment
    fi
    
    first_analysis
    understand_results
    demonstrate_fixing
    auto_fix_demo
    ide_integration
    customization
    daily_workflow
    final_quiz
    conclusion
}

# Run the tutorial
main "$@"
