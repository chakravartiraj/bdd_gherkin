# 🚀 Flutter Test Quick Reference

> Quick commands and patterns for Flutter testing. Bookmark this page for instant access to testing essentials!

## ⚡ Essential Commands

### Basic Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with detailed output
flutter test --verbose

# Run tests in watch mode
flutter test --watch
```

### Coverage Testing
```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
xdg-open coverage/html/index.html
```

### BDD Testing
```bash
# Generate BDD test code from .feature files
dart run build_runner build

# Watch for changes and regenerate
dart run build_runner watch

# Run only BDD tests
flutter test test/counter_test.dart
```

## 📝 Common Test Patterns

### Widget Test Template
```dart
testWidgets('description of what is being tested', (WidgetTester tester) async {
  // Arrange: Set up the widget
  await tester.pumpWidget(const MyApp());

  // Act: Perform user actions
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Assert: Verify expected results
  expect(find.text('1'), findsOneWidget);
});
```

### Unit Test Template
```dart
test('description of what is being tested', () {
  // Arrange
  final calculator = Calculator();
  
  // Act
  final result = calculator.add(2, 3);
  
  // Assert
  expect(result, equals(5));
});
```

### BDD Scenario Template
```gherkin
Scenario: User performs an action
  Given the app is running
  When I tap {Icons.add} icon
  Then I see {1} text
```

## 🔍 Finding Widgets

### By Text
```dart
find.text('Hello')              // Find exact text
find.textContaining('Hello')    // Find text containing substring
```

### By Widget Type
```dart
find.byType(FloatingActionButton)  // Find by widget class
find.byIcon(Icons.add)            // Find by icon
find.byKey(const Key('my-key'))   // Find by key
```

### By Semantics
```dart
find.bySemanticsLabel('Increment')  // Find by accessibility label
find.byTooltip('Add item')          // Find by tooltip
```

## ✅ Common Expectations

### Widget Existence
```dart
expect(find.text('Hello'), findsOneWidget);     // Exactly one
expect(find.text('Item'), findsNWidgets(3));    // Exactly N
expect(find.text('Hidden'), findsNothing);      // None found
expect(find.text('Maybe'), findsAny);           // At least one
```

### Widget Properties
```dart
final textWidget = tester.widget<Text>(find.text('Hello'));
expect(textWidget.style!.color, equals(Colors.red));

final buttonWidget = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
expect(buttonWidget.enabled, isTrue);
```

### Navigation
```dart
// Verify route navigation
await tester.tap(find.text('Next Page'));
await tester.pumpAndSettle();
expect(find.text('Second Page'), findsOneWidget);
```

## 🎭 User Interactions

### Tapping
```dart
await tester.tap(find.text('Button'));          // Tap widget
await tester.tap(find.byIcon(Icons.add));       // Tap icon
await tester.longPress(find.text('Hold me'));   // Long press
```

### Text Input
```dart
await tester.enterText(find.byType(TextField), 'Hello');
await tester.pump();
```

### Scrolling
```dart
await tester.scroll(
  find.byType(ListView),
  const Offset(0, -300),  // Scroll up 300 pixels
);
await tester.pump();
```

### Gestures
```dart
await tester.drag(find.text('Draggable'), const Offset(300, 0));
await tester.fling(find.byType(ListView), const Offset(0, -200), 1000);
```

## ⏰ Timing and Animation

### Waiting for Updates
```dart
await tester.pump();                    // Single frame
await tester.pumpAndSettle();          // Wait for animations
await tester.pump(Duration(seconds: 1)); // Wait specific duration
```

### Testing Animations
```dart
await tester.pumpWidget(MyAnimatedWidget());
await tester.pump();                    // Start animation
await tester.pump(Duration(milliseconds: 100)); // Mid-animation
await tester.pumpAndSettle();          // Animation complete
```

## 🐛 Debugging Tests

### Print Widget Tree
```dart
debugDumpApp();  // Print entire widget tree
```

### Find All Widgets
```dart
final allButtons = find.byType(ElevatedButton);
print('Found ${allButtons.evaluate().length} buttons');
```

### Screenshot Testing
```dart
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('my_widget.png'),
);
```

## 🏗️ Test Setup & Teardown

### Group Tests
```dart
group('Counter tests', () {
  testWidgets('increments', (tester) async { /* test */ });
  testWidgets('decrements', (tester) async { /* test */ });
});
```

### Setup and Cleanup
```dart
group('Database tests', () {
  late Database db;
  
  setUp(() async {
    db = await Database.create();
  });
  
  tearDown(() async {
    await db.close();
  });
  
  test('can insert data', () async {
    // Test uses db created in setUp
  });
});
```

## 🎯 BDD Step Definitions

### Common Step Patterns
```dart
// Given steps (setup)
Given('the app is running', () async {
  await tester.pumpWidget(const MyApp());
});

// When steps (actions)
When('I tap {string} button', (String buttonText) async {
  await tester.tap(find.text(buttonText));
  await tester.pump();
});

// Then steps (assertions)
Then('I see {string} text', (String text) async {
  expect(find.text(text), findsOneWidget);
});
```

## 📊 Coverage Commands

### Generate Reports
```bash
# Basic coverage
flutter test --coverage

# With custom exclusions
flutter test --coverage --test-randomize-ordering-seed=random

# Generate filtered HTML report
genhtml coverage/lcov.info -o coverage/html --exclude '**/*.g.dart'
```

### Coverage Targets
- **70%+**: Minimum acceptable
- **80%+**: Good coverage
- **90%+**: Excellent coverage
- **95%+**: Very thorough (may be overkill)

## 🚨 Common Errors & Solutions

### "Could not find widget"
```dart
// Problem: Widget not rendered yet
await tester.tap(find.text('Button'));

// Solution: Wait for widget to appear
await tester.pumpAndSettle();
await tester.tap(find.text('Button'));
```

### "Timed out waiting for..."
```dart
// Problem: Animation taking too long
await tester.pumpAndSettle();

// Solution: Increase timeout or pump manually
await tester.pumpAndSettle(Duration(seconds: 10));
```

### "Multiple widgets found"
```dart
// Problem: Multiple widgets with same text
expect(find.text('Submit'), findsOneWidget);

// Solution: Be more specific
expect(find.descendant(
  of: find.byType(Form),
  matching: find.text('Submit'),
), findsOneWidget);
```

## 📁 File Organization

### Recommended Structure
```
test/
├── widget_test.dart           # Basic widget tests
├── unit/
│   ├── models/
│   ├── services/
│   └── utils/
├── widget/
│   ├── pages/
│   ├── components/
│   └── forms/
├── integration/
│   └── app_test.dart
├── bdd/
│   ├── features/
│   │   └── *.feature
│   ├── step/
│   │   └── *.dart
│   └── *_test.dart
└── helpers/
    ├── test_helpers.dart
    └── mocks.dart
```

## 🎨 Testing Best Practices

### ✅ Do
- Test user behavior, not implementation
- Use descriptive test names
- Keep tests independent
- Test one thing at a time
- Use Page Object pattern for complex UIs

### ❌ Don't
- Test private methods directly
- Make tests depend on each other
- Use real network calls
- Test framework internals
- Ignore flaky tests

## 🔧 Useful Utilities

### Custom Matchers
```dart
Matcher hasTextStyle(TextStyle expectedStyle) {
  return predicate<Text>((widget) => widget.style == expectedStyle);
}

// Usage
expect(find.byType(Text), hasTextStyle(TextStyle(color: Colors.red)));
```

### Test Helpers
```dart
Future<void> pumpMyApp(WidgetTester tester, {Widget? home}) async {
  await tester.pumpWidget(MaterialApp(home: home ?? MyHomePage()));
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
```

---

## 🏃‍♂️ Quick Start Checklist

- [ ] Run existing tests: `flutter test`
- [ ] Create your first widget test
- [ ] Add a BDD scenario in `.feature` file
- [ ] Generate BDD tests: `dart run build_runner build`
- [ ] Check coverage: `flutter test --coverage`
- [ ] Open coverage report in browser

## 📚 Learn More

- **[Flutter Test Walkthrough](flutter-test-walkthrough.md)** - Complete beginner guide
- **[Hands-On Exercises](hands-on-test-exercise.md)** - Practice with real examples
- **[Test Learning Center](test-README.md)** - Full learning path

---

*Keep this reference handy while writing tests! 🚀*
