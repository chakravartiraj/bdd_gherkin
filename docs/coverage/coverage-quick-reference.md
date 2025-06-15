# 🚀 Flutter Coverage Quick Reference

## 📋 Commands Cheat Sheet

```bash
# Essential Commands (Copy & Paste Ready)

# Run basic coverage
flutter test --coverage

# Quick coverage with our script  
./scripts/quick-coverage.sh

# View visual report
xdg-open coverage/html/index.html

# Get text summary
lcov --summary coverage/lcov.info

# Watch for changes (auto-run tests)
./scripts/watch-coverage.sh
```

---

## 🎯 Coverage Interpretation Guide

| Coverage % | Status | What to Do |
|------------|--------|------------|
| 95%+ | ⭐ **Outstanding** | Maintain quality, focus on edge cases |
| 90-94% | 🟢 **Excellent** | You're doing great! Minor improvements |
| 80-89% | 🟡 **Good** | Solid foundation, add more tests |
| 70-79% | 🟠 **Acceptable** | Need improvement, focus on main features |
| Below 70% | 🔴 **Risky** | Urgent: Add tests for core functionality |

---

## 🚦 Visual Report Legend

| Color | Meaning | Action Needed |
|-------|---------|---------------|
| 🟢 **Green Lines** | Code is tested | ✅ Good to go! |
| 🔴 **Red Lines** | Code NOT tested | ❌ Write tests for these |
| ⚪ **No Color** | Comments/whitespace | ➖ Ignore these |

---

## 📁 Important Files

| File | What It Contains | When to Use |
|------|------------------|-------------|
| `coverage/lcov.info` | Raw coverage data | For tools/scripts |
| `coverage/html/index.html` | Visual report | Daily review |
| `coverage/detailed_summary.md` | Text summary | Quick check |
| `scripts/quick-coverage.sh` | Fast coverage run | Multiple times per day |

---

## 🔄 Daily Workflow

### ☀️ **Morning** (2 minutes)
```bash
./scripts/quick-coverage.sh
```
*Check current status before starting work*

### 💻 **While Coding** (30 seconds)
```bash
flutter test --coverage && xdg-open coverage/html/index.html
```
*After writing new features*

### 🌙 **Before Commit** (1 minute)
```bash
./scripts/quick-coverage.sh
# If coverage dropped, write more tests!
```

---

## 🆘 Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| "No tests found" | Check files end with `_test.dart` in `test/` folder |
| "lcov command not found" | `sudo apt install lcov` |
| "Permission denied" | `chmod +x scripts/quick-coverage.sh` |
| Tests fail | Read error message, fix the failing test |
| Coverage drops | Check what code you added, write tests for it |

---

## 🎯 Smart Testing Strategy

### ✅ **Test These First** (High Priority)
- Main app features (login, core functionality)
- User interactions (button clicks, form submissions)
- Data processing (calculations, transformations)
- Error conditions (network failures, invalid input)

### ⚡ **Can Skip These** (Low Priority)
- Simple getters/setters
- Print/log statements
- Generated code
- Trivial constructors

### 🧠 **Think Like a User**
1. What would a user do with this feature?
2. What could go wrong?
3. What edge cases exist?
4. How would this break?

---

## 📊 Coverage Goals by Project Type

| Project Type | Minimum | Target | Excellent |
|--------------|---------|--------|-----------|
| **Personal/Learning** | 60% | 75% | 85%+ |
| **Professional** | 75% | 85% | 90%+ |
| **Critical Systems** | 85% | 90% | 95%+ |
| **Open Source** | 80% | 85% | 90%+ |

---

## 🏃‍♂️ 5-Minute Coverage Boost

Need to quickly improve coverage? Try these:

### 1. **Test Constructor** (Easy win)
```dart
test('creates widget', () {
  final widget = MyWidget();
  expect(widget, isNotNull);
});
```

### 2. **Test Simple Methods** (Easy win)
```dart
test('getter returns correct value', () {
  final counter = Counter();
  expect(counter.value, equals(0));
});
```

### 3. **Test User Interactions** (Medium effort)
```dart
testWidgets('button tap increases counter', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
});
```

### 4. **Test Error Cases** (High value)
```dart
test('throws exception on invalid input', () {
  expect(() => divide(10, 0), throwsException);
});
```

---

## 🎨 Making Reports Pretty

### Custom Coverage Badge
Add to your README.md:
```markdown
![Coverage](https://img.shields.io/badge/coverage-92%25-brightgreen)
```

### CI/CD Integration
```yaml
# In .github/workflows/ci.yml
- name: Test Coverage
  run: |
    flutter test --coverage
    lcov --summary coverage/lcov.info
```

---

## 🧪 Advanced Tricks

### Filter Unimportant Files
```bash
lcov --remove coverage/lcov.info \
  '*/generated/*' \
  '*/build/*' \
  '*/test/*' \
  --output-file coverage/clean.info
```

### Set Coverage Thresholds
```bash
# Fail CI if coverage < 80%
COVERAGE=$(lcov --summary coverage/lcov.info | grep -o '[0-9.]*%' | head -1 | tr -d '%')
if (( $(echo "$COVERAGE < 80" | bc -l) )); then
  echo "Coverage too low: $COVERAGE%"
  exit 1
fi
```

### Track Coverage Over Time
```bash
echo "$(date): $(lcov --summary coverage/lcov.info | grep 'lines' | grep -o '[0-9.]*%')" >> coverage_history.txt
```

---

## 💡 Pro Tips

### 🎯 **Focus on Value**
- 80% good coverage > 95% meaningless coverage
- Test behavior, not implementation
- One test that catches real bugs > Ten tests that don't

### 🚀 **Speed Up Testing**
- Use `--no-sound-null-safety` for faster test runs
- Run specific test files: `flutter test test/specific_test.dart`
- Use `flutter test --coverage --reporter=github` for CI

### 🔄 **Maintain Quality**
- Review coverage reports weekly
- Set team coverage goals
- Make coverage part of code reviews

---

## 📱 Mobile-Friendly Commands

For quick terminal access:
```bash
# Ultra-short commands
alias fcov='flutter test --coverage'
alias vcov='xdg-open coverage/html/index.html'
alias qcov='./scripts/quick-coverage.sh'
```

Add these to your `~/.bashrc` for instant access!

---

## 🎓 Remember

> **"Coverage is not about the number - it's about confidence"**

- ✅ 80% with good tests > 95% with bad tests  
- ✅ Test what matters most first
- ✅ Use coverage to find untested areas
- ✅ Make it part of your daily routine
- ✅ Focus on quality over quantity

---

*Print this page and keep it next to your monitor for quick reference!*
