# 🏋️ Hands-On Flutter Testing Exercises
## Practice What You Just Learned!

> **Goal**: Turn theory into practice with step-by-step exercises using your BDD Gherkin project.

---

## 🎯 Exercise Setup

Before starting, make sure you're in the right place:

```bash
cd /home/io/StudioProjects/bdd_gherkin
```

Check that you have the basic test files:
```bash
ls test/
# You should see: counter_test.dart, counter.feature, widget_test.dart
```

---

## 🥇 Exercise 1: Your First Test Run (Beginner)

**Goal**: Get comfortable running tests and reading results.

### Step 1: Run the Existing Tests
```bash
flutter test
```

**Questions to Answer:**
1. How many tests passed? ___
2. How long did the tests take? ___
3. Did you see any warnings or errors? ___

### Step 2: Run Individual Test Files
```bash
# Run only widget tests
flutter test test/widget_test.dart

# Run only BDD tests
flutter test test/counter_test.dart
```

**Questions to Answer:**
1. Which test file has more tests? ___
2. Which runs faster? ___
3. What's the difference in output? ___

### Step 3: Break a Test (Learning from Failure)
1. Open `lib/main.dart`
2. Change the app title from `'Flutter Demo Home Page'` to `'My Awesome App'`
3. Save the file
4. Run tests again: `flutter test`

**What happened?**
- Which test failed? ___
- What was the error message? ___
- Why did it fail? ___

### Step 4: Fix the Test
1. Open `test/widget_test.dart`  
2. Find the line that looks for `'Flutter Demo Home Page'`
3. Change it to `'My Awesome App'`
4. Run tests again: `flutter test`

**Success Check:**
- [ ] All tests pass
- [ ] You understand why the test failed
- [ ] You know how to fix test failures

---

## 🥈 Exercise 2: Write Your First Test (Intermediate)

**Goal**: Create a test from scratch.

### Step 1: Understand What to Test
Your app has a counter that:
- Starts at 0
- Increases when you tap "+"
- The title says "Flutter Demo Home Page" (or whatever you changed it to)

### Step 2: Write a Test for the Minus Button
The app has a minus button, but no test for it yet!

Add this test to `test/widget_test.dart`:

```dart
testWidgets('Counter decrements when minus button is tapped', (WidgetTester tester) async {
  // Build our app and trigger a frame
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
```

### Step 3: Run Your New Test
```bash
flutter test test/widget_test.dart
```

**Questions:**
1. Did your test pass? ___
2. If it failed, what was the error? ___
3. What does this test prove about your app? ___

### Step 4: Test Edge Cases
What happens if you try to decrement below 0? Let's test it!

```dart
testWidgets('Counter does not go below zero', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  // Counter starts at 0, try to decrement
  await tester.tap(find.byIcon(Icons.remove));
  await tester.pump();

  // Should still be 0 (or maybe -1? Let's find out!)
  expect(find.text('0'), findsOneWidget);
});
```

**Discovery Questions:**
1. What number does the counter show when you decrement from 0? ___
2. Is this the behavior you expected? ___
3. Should the app prevent going below 0? ___

---

## 🥉 Exercise 3: Understanding BDD Tests (Advanced)

**Goal**: Connect plain English requirements to test code.

### Step 1: Read the Feature File
Open `test/counter.feature` and read it out loud. 

**Questions:**
1. How many scenarios are defined? ___
2. What user actions are tested? ___
3. What outcomes are verified? ___

### Step 2: Add a New Scenario
Add this scenario to your `counter.feature` file:

```gherkin
Scenario: Decrement counter
  Given the app is running
  When I tap {Icons.remove} icon
  Then I see {-1} text
```

### Step 3: Generate the Test Code
```bash
dart run build_runner build
```

**Check:** Look at `test/counter_test.dart` - did it add a new test?

### Step 4: Run the BDD Tests
```bash
flutter test test/counter_test.dart
```

**Questions:**
1. Did the new test pass or fail? ___
2. What does this tell you about how your app handles negative numbers? ___
3. Compare the BDD test to the widget test you wrote - which is easier to understand? ___

---

## 🏆 Exercise 4: Test-Driven Development (Expert)

**Goal**: Write a test first, then make it pass.

### Step 1: Define a New Requirement
Let's say you want to add a "Reset" button that sets the counter back to 0.

### Step 2: Write the Test First (Before Adding the Feature)
Add this test to `test/widget_test.dart`:

```dart
testWidgets('Reset button sets counter to zero', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());

  // First, increment counter to 5
  for (int i = 0; i < 5; i++) {
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  }
  
  // Verify we're at 5
  expect(find.text('5'), findsOneWidget);

  // Tap the reset button (doesn't exist yet!)
  await tester.tap(find.byIcon(Icons.refresh));
  await tester.pump();

  // Should be back to 0
  expect(find.text('0'), findsOneWidget);
});
```

### Step 3: Run the Test (It Should Fail)
```bash
flutter test test/widget_test.dart
```

**Expected Result**: Test fails because there's no reset button yet.

### Step 4: Add the Reset Button to Your App
Edit `lib/main.dart` to add a reset button in the `floatingActionButton` area:

```dart
// In the Scaffold, change floatingActionButton to:
floatingActionButton: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      onPressed: () {
        setState(() {
          _counter = 0;  // Reset to zero
        });
      },
      tooltip: 'Reset',
      child: const Icon(Icons.refresh),
    ),
    const SizedBox(width: 10),
    FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  ],
),
```

### Step 5: Run the Test Again
```bash
flutter test test/widget_test.dart
```

**Questions:**
1. Does your test pass now? ___
2. What did you have to add to make it pass? ___
3. How does it feel to write the test before the feature? ___

---

## 🧠 Exercise 5: Debugging Failed Tests (Problem Solving)

**Goal**: Learn to diagnose and fix test problems.

### Step 1: Intentionally Break Something
1. In `lib/main.dart`, change `_counter++` to `_counter += 2`
2. Run tests: `flutter test`

**Questions:**
1. Which tests fail? ___
2. What are the error messages? ___
3. Why do they fail? ___

### Step 2: Use Print Debugging in Tests
Add this test that helps you see what's happening:

```dart
testWidgets('Debug test - see what values we get', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  print('Starting counter value');
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  // Find all text widgets and print their values
  final textWidgets = find.byType(Text);
  final textCount = textWidgets.evaluate().length;
  print('Found $textCount text widgets');
  
  // This test doesn't check anything, just helps us debug
});
```

Run this test and look at the output.

### Step 3: Fix the Problem
1. Change `_counter += 2` back to `_counter++`
2. Run tests again to confirm they pass

---

## 🎭 Exercise 6: Advanced BDD Scenarios (Creative)

**Goal**: Write complex user scenarios in plain English.

### Step 1: Write a Complex Scenario
Add this to your `counter.feature` file:

```gherkin
Scenario: User increments then decrements
  Given the app is running
  When I tap {Icons.add} icon
  And I tap {Icons.add} icon
  And I tap {Icons.remove} icon
  Then I see {1} text

Scenario: Multiple operations result in correct value
  Given the app is running
  When I tap {Icons.add} icon
  And I tap {Icons.add} icon
  And I tap {Icons.add} icon
  And I tap {Icons.remove} icon
  Then I see {2} text
```

### Step 2: Generate and Run Tests
```bash
dart run build_runner build
flutter test test/counter_test.dart
```

### Step 3: Create Your Own Scenario
Think of a real user workflow and write it in Gherkin:

```gherkin
Scenario: [Your scenario name here]
  Given [starting condition]
  When [user action]
  And [another action]
  Then [expected result]
```

**Challenge**: Write a scenario that tests the reset button using Gherkin syntax!

---

## 📊 Exercise 7: Test Coverage (Quality Check)

**Goal**: Understand how much of your code is tested.

### Step 1: Run Tests with Coverage
```bash
flutter test --coverage
```

### Step 2: View Coverage Report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (Linux)
xdg-open coverage/html/index.html
```

### Step 3: Analyze Your Coverage
Look at the coverage report and answer:

1. What percentage of your code is covered? ___%
2. Which files have the lowest coverage? ___
3. Which lines in `main.dart` are not tested? ___

### Step 4: Improve Coverage
Write a test for an untested line. For example, if the app title isn't tested:

```dart
testWidgets('App has correct title in app bar', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  expect(find.text('Flutter Demo Home Page'), findsOneWidget);
});
```

---

## 🎯 Final Challenge: Build a Feature with Tests

**Goal**: Apply everything you've learned to build something new.

### The Challenge
Add a "Double" button that multiplies the counter by 2.

### Requirements
1. Write the BDD scenario first (in plain English)
2. Write the widget test first (before implementing)
3. Implement the feature
4. Make sure all tests pass
5. Check that coverage doesn't decrease

### Success Criteria
- [ ] Feature works in the app
- [ ] Widget test passes
- [ ] BDD test passes  
- [ ] All existing tests still pass
- [ ] Code coverage maintains or improves

---

## 🏁 Completion Checklist

Mark off each exercise as you complete it:

**Beginner Level:**
- [ ] Exercise 1: Successfully ran tests and fixed a failure
- [ ] Exercise 2: Wrote and ran your first test

**Intermediate Level:**
- [ ] Exercise 3: Created and ran BDD scenarios
- [ ] Exercise 4: Practiced test-driven development

**Advanced Level:**
- [ ] Exercise 5: Debugged failed tests
- [ ] Exercise 6: Wrote complex BDD scenarios
- [ ] Exercise 7: Analyzed test coverage

**Expert Level:**
- [ ] Final Challenge: Built a complete feature with tests

---

## 🎉 Congratulations!

You've completed the hands-on Flutter testing exercises! You now have practical experience with:

- ✅ Running and interpreting test results
- ✅ Writing widget tests from scratch
- ✅ Understanding BDD/Gherkin syntax
- ✅ Test-driven development workflow
- ✅ Debugging test failures
- ✅ Measuring and improving test coverage

## 📚 What's Next?

1. **Practice daily**: Write one test every day for your current project
2. **Learn advanced topics**: Mocking, integration tests, golden tests
3. **Join the community**: Share your testing experiences
4. **Teach others**: The best way to solidify your knowledge

Remember: Good tests are not about having 100% coverage, but about having confidence that your app works as intended! 🚀

---

*"The goal of testing is not to find bugs, but to design software that is less likely to have bugs."*
