# 🎯 Flutter BDD Gherkin Testing Framework

> **A comprehensive Flutter project demonstrating Behavior-Driven Development (BDD) with Gherkin syntax, complete testing workflows, and educational documentation.**

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

## 🌟 Overview

This project serves as a **complete learning resource** for Flutter developers who want to master:
- **Behavior-Driven Development (BDD)** with Gherkin syntax
- **Comprehensive testing strategies** (Unit, Widget, BDD)
- **Test coverage analysis** and reporting
- **Code quality analysis** with Flutter tools
- **Professional development workflows**

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 2.17+
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/chakravartiraj/bdd_gherkin.git
cd bdd_gherkin

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 🎮 Interactive Development Hub

This project includes a **powerful script-based development environment**:

```bash
# Start the interactive development hub
./scripts/dev.sh

# Or use quick commands
./scripts/dev.sh test           # Run all tests
./scripts/dev.sh coverage      # Generate coverage reports  
./scripts/dev.sh analyze       # Analyze code quality
./scripts/dev.sh bdd status    # Check BDD setup
```

## 📚 Comprehensive Documentation

### 🎓 Learning Resources

| Resource | Description | Best For |
|----------|-------------|----------|
| **[📖 Testing Learning Center](docs/test-README.html)** | Complete testing guide with 7+ week curriculum | Beginners to Advanced |
| **[📊 Coverage Documentation](docs/coverage-README.html)** | Master test coverage analysis | Intermediate+ |
| **[🔍 Analysis Documentation](docs/analyze-README.html)** | Code quality and static analysis | All levels |

### 🛠️ Quick References

- **[⚡ Test Quick Reference](docs/test-quick-reference.html)** - Essential testing commands
- **[📋 Coverage Quick Reference](docs/coverage-quick-reference.html)** - Coverage analysis commands  
- **[🔧 Analysis Quick Reference](docs/analyze-quick-reference.html)** - Code analysis commands

### 🏋️ Hands-On Practice

- **[🧪 Testing Exercises](docs/hands-on-test-exercise.html)** - 7 practical testing exercises
- **[📈 Coverage Exercises](docs/hands-on-coverage-exercise.html)** - Coverage analysis practice
- **[🔍 Analysis Exercises](docs/hands-on-analyze-exercise.html)** - Code quality exercises

## 🧪 BDD with Gherkin

### What is BDD?
**Behavior-Driven Development** focuses on:
1. **Collaboration** - Business, developers, and testers work together
2. **Specification** - Write requirements in plain English
3. **Automation** - Convert specifications into automated tests

### Gherkin Syntax Example

```gherkin
Feature: Counter App
  As a user
  I want to increment and decrement a counter
  So that I can track a count

  Scenario: Increment counter
    Given the app is running
    When I tap the increment button
    Then I see 1
```

### Implementation

```dart
import 'package:bdd_widget_test/bdd_widget_test.dart';

void main() {
  bddWidgetTest(
    'Counter increments correctly',
    'test/counter.feature',
    (tester) async {
      await tester.pumpWidget(const MyApp());
    },
    steps: [
      given1('the app is running', (step, tester) async {
        // App setup
      }),
      when1('I tap the increment button', (step, tester) async {
        await tester.tap(find.byTooltip('Increment'));
        await tester.pump();
      }),
      then1('I see {int}', (step, tester, count) async {
        expect(find.text(count.toString()), findsOneWidget);
      }),
    ],
  );
}
```

## 🗂️ Project Structure

```
📦 bdd_gherkin/
├── 📂 docs/                   # Comprehensive documentation
│   ├── 🌐 *.html              # Ready-to-view HTML guides
│   ├── 📂 test/               # Testing documentation sources
│   ├── 📂 coverage/           # Coverage documentation sources
│   └── 📂 analyze/            # Analysis documentation sources
├── 📂 scripts/                # Development automation (13 scripts)
│   ├── 🎛️ dev.sh              # Interactive development hub
│   ├── 🧪 test-*.sh           # Testing automation
│   ├── 🎯 golden-test.sh      # Golden UI testing
│   ├── 📊 coverage-*.sh       # Coverage automation
│   └── 🔍 analyze-*.sh        # Analysis automation
├── 📂 test/                   # Test files
│   ├── 📄 *.feature           # Gherkin feature files
│   ├── 🧪 *_test.dart         # Test files
│   ├── 🎯 golden_test.dart    # Golden UI tests
│   ├── 📂 goldens/            # Golden master images
│   └── 📂 step/               # BDD step definitions
├── 📂 lib/                    # App source code
└── 📂 coverage/               # Coverage reports (auto-generated)
```

## 🔧 Development Scripts

This project includes **13 powerful development scripts**:

### Core Scripts
- **`dev.sh`** - Interactive development hub with menus
- **`test-quick.sh`** - Fast test execution with smart filtering
- **`coverage-quick.sh`** - Quick coverage analysis
- **`analyze-daily.sh`** - Code quality analysis
- **`golden-test.sh`** - Golden UI testing automation

### Watch Scripts  
- **`test-watch.sh`** - Auto-run tests on file changes
- **`coverage-watch.sh`** - Auto-generate coverage on changes

### Setup Scripts
- **`coverage-setup.sh`** - Complete coverage environment setup
- **`bdd-helper.sh`** - BDD project management

### Tutorial Scripts
- **`test-tutorial.sh`** - Interactive testing tutorial
- **`coverage-tutorial.sh`** - Interactive coverage tutorial  
- **`analyze-tutorial.sh`** - Interactive analysis tutorial

All scripts include **comprehensive help**: `./scripts/SCRIPT_NAME.sh --help`

## 📈 Testing Strategy

### Test Types
1. **🔬 Unit Tests** - Test individual functions and classes
2. **🖼️ Widget Tests** - Test UI components in isolation  
3. **🎭 BDD Tests** - Test user scenarios with Gherkin syntax
4. **🎯 Golden Tests** - Test UI consistency with pixel-perfect screenshots
5. **🔗 Integration Tests** - Test complete user workflows

### Coverage Goals
- **Minimum**: 80% line coverage
- **Target**: 90% line coverage
- **Focus**: Critical business logic paths

### Commands
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test types
./scripts/test-quick.sh unit      # Unit tests only
./scripts/test-quick.sh widget    # Widget tests only  
./scripts/test-quick.sh bdd       # BDD tests only

# Run golden tests
./scripts/golden-test.sh run      # Golden UI tests
./scripts/golden-test.sh update   # Update golden images

# Generate coverage reports
./scripts/coverage-quick.sh
```

## 🎯 Getting Started - Learning Path

### Week 1-2: Foundation
1. 📖 Read [Testing Walkthrough](docs/flutter-test-walkthrough.html)
2. 🏋️ Complete Testing Exercises 1-3
3. 🎮 Practice with development scripts

### Week 3-4: Practice  
1. 🏋️ Complete Testing Exercises 4-7
2. 📊 Learn [Coverage Analysis](docs/coverage-README.html)
3. ✍️ Write tests for your own projects

### Week 5-6: Quality
1. 🔍 Master [Code Analysis](docs/analyze-README.html)
2. 🎯 Implement coverage goals
3. 📈 Practice test-driven development

### Week 7+: Mastery
1. 🤝 Contribute to open source projects
2. 👥 Mentor other developers  
3. 🚀 Explore advanced testing patterns

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Setup
```bash
# Install dependencies
flutter pub get

# Run tests
./scripts/test-quick.sh

# Check code quality
./scripts/analyze-daily.sh

# Generate documentation
./scripts/coverage-setup.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **BDD Community** - For Gherkin and behavior-driven practices
- **Open Source Contributors** - For the tools and packages used

## 📞 Support

- **📖 Documentation**: [Full Documentation Hub](docs/index.html)
- **🐛 Issues**: [GitHub Issues](https://github.com/chakravartiraj/bdd_gherkin/issues)
- **💬 Discussions**: [GitHub Discussions](https://github.com/chakravartiraj/bdd_gherkin/discussions)

---

**⭐ Star this repository if it helped you learn Flutter testing!**

*"Testing is not about finding bugs, it's about building confidence in your software."* 