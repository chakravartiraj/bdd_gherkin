# 🏋️ Hands-On Coverage Exercise

## Before You Start
This exercise uses your BDD Gherkin project. Follow along step by step!

---

## Exercise 1: Your First Coverage Run

### Step 1: Check Your Starting Point
```bash
# Open terminal in your project folder
cd /home/io/StudioProjects/bdd_gherkin

# Run your first coverage analysis
./scripts/quick-coverage.sh
```

**📝 Write down your results:**
- Current coverage percentage: ____%
- Number of lines tested: ____
- Number of total lines: ____

### Step 2: Open the Visual Report
```bash
# Open the HTML report
xdg-open coverage/html/index.html
```

**🔍 Exploration tasks:**
1. Click on `lib/main.dart` in the report
2. Look for red lines (untested code)
3. Count how many red lines you see: ____

---

## Exercise 2: Understanding Your Code

### Step 3: Analyze main.dart
Open `lib/main.dart` in your editor and the coverage report side by side.

**🤔 Questions to answer:**
1. Which function has red lines? ________________
2. What do you think these lines do? ________________
3. Why might they not be tested? ________________

### Step 4: Look at Your Tests
```bash
# See what tests you have
ls test/
```

**📁 You should see:**
- `counter_test.dart` - BDD/Gherkin tests
- `widget_test.dart` - Regular Flutter tests
- `counter.feature` - Gherkin feature file

---

## Exercise 3: Improve Your Coverage

### Step 5: Run Tests Individually
```bash
# Run just the widget tests
flutter test test/widget_test.dart --coverage

# Check what this covers
./scripts/quick-coverage.sh
```

**📊 Compare results:**
- Coverage with all tests: ____%
- Coverage with just widget tests: ____%

### Step 6: Identify Missing Tests
Looking at your coverage report, the untested lines are probably:
- Error handling code
- Edge cases
- Less common user flows

**🎯 Your mission:** Write a test for one untested line

### Step 7: Write a New Test
Add this test to `test/widget_test.dart`:

```dart
testWidgets('App shows correct title', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // Verify the app title appears
  expect(find.text('Flutter Demo Home Page'), findsOneWidget);
});
```

### Step 8: Check Your Improvement
```bash
# Run coverage again
./scripts/quick-coverage.sh
```

**📈 Results:**
- New coverage percentage: ____%
- Did it improve? Yes/No: ____
- How many lines improved: ____

---

## Exercise 4: Reading Reports Like a Pro

### Step 9: Detailed Analysis
Open the HTML report again and click on `lib/main.dart`.

**🔍 Detective work:**
1. Find the line with `theme: ThemeData(` - is it green or red?
2. Find the line with `primarySwatch: Colors.blue` - is it green or red?
3. What about the `floatingActionButton` section?

**💡 Pattern recognition:**
- Lines that are executed during app startup: Usually ____
- Lines that require user interaction: Usually ____
- Lines that handle special cases: Usually ____

### Step 10: Coverage Quality Assessment

Based on your current coverage:

**If 90%+ coverage:**
🟢 **Excellent!** You have great test coverage. Focus on:
- Maintaining this level
- Testing edge cases
- Adding integration tests

**If 80-90% coverage:**
🟡 **Good!** You're on the right track. Consider:
- Adding tests for error scenarios
- Testing user interactions more thoroughly
- Adding widget tests for UI components

**If below 80% coverage:**
🔴 **Needs improvement.** Priority actions:
- Test your main app functions
- Add basic widget tests
- Test happy path scenarios first

---

## Exercise 5: Daily Workflow Practice

### Step 11: Make a Small Change
1. Open `lib/main.dart`
2. Change the app title from 'Flutter Demo Home Page' to 'My Awesome App'
3. Save the file

### Step 12: Check Impact on Tests
```bash
# Run tests to see what breaks
flutter test
```

**🚨 What happened?**
- Did any tests fail? Yes/No: ____
- Which test failed? ________________
- Why did it fail? ________________

### Step 13: Fix the Test
1. Open `test/widget_test.dart`
2. Find the line that looks for 'Flutter Demo Home Page'
3. Change it to 'My Awesome App'
4. Save the file

### Step 14: Verify Fix
```bash
# Run tests again
flutter test --coverage
```

**✅ Success checklist:**
- [ ] All tests pass
- [ ] Coverage percentage maintained or improved
- [ ] No new red lines in coverage report

---

## Exercise 6: Advanced Coverage Exploration

### Step 15: Explore BDD Coverage
```bash
# Run only BDD tests
flutter test test/counter_test.dart --coverage
```

**🤓 BDD vs Unit Test Coverage:**
- BDD test coverage: ____%
- Regular test coverage: ____%
- Which covers more code? ________________

### Step 16: Create a Coverage Goal
Based on your analysis, set a realistic goal:

**My coverage goal:** ____% by _______ (date)

**To achieve this, I need to:**
1. ________________________________
2. ________________________________
3. ________________________________

---

## 🎯 Challenge Mode

### Challenge 1: Find the Uncovered Code
Without looking at the coverage report:
1. Guess which parts of your app aren't tested
2. Write down your guesses
3. Check the coverage report
4. How accurate were you?

### Challenge 2: Write a Failing Test
1. Write a test that you think should pass but doesn't
2. Run it and see what happens
3. Fix either the test or the code
4. Re-run coverage

### Challenge 3: Coverage Detective
Look at the coverage report and find:
1. The file with the highest coverage
2. The file with the lowest coverage
3. One line that's tested but probably shouldn't need to be
4. One line that's not tested but probably should be

---

## 📝 Reflection Questions

After completing the exercises:

1. **What surprised you most about your coverage results?**
   ________________________________________________

2. **Which parts of your app do you now realize need more testing?**
   ________________________________________________

3. **What's one testing habit you want to start?**
   ________________________________________________

4. **On a scale of 1-10, how confident are you now in your app's quality?**
   Before: ____  After: ____

5. **What's the next area you want to add tests for?**
   ________________________________________________

---

## 🏆 Completion Checklist

Mark off each item as you complete it:

**Understanding:**
- [ ] I understand what coverage percentages mean
- [ ] I can read the HTML coverage report
- [ ] I know the difference between green and red lines

**Practical Skills:**
- [ ] I can run coverage analysis
- [ ] I can identify untested code
- [ ] I can write tests to improve coverage

**Workflow:**
- [ ] I know how to check coverage before committing code
- [ ] I understand how tests can break when code changes
- [ ] I can fix broken tests

**Next Steps:**
- [ ] I have a coverage goal for my project
- [ ] I know which areas need more tests
- [ ] I'm ready to make testing part of my daily routine

---

## 🎉 Congratulations!

You've completed the hands-on coverage exercise! You now have practical experience with:

✅ Running coverage analysis
✅ Reading coverage reports  
✅ Writing tests to improve coverage
✅ Understanding the relationship between code changes and tests
✅ Setting up a testing workflow

**Your homework:** Run coverage analysis once a day for the next week and try to improve your percentage by 5% each day.

Remember: **Quality over quantity!** It's better to have 80% coverage with good, meaningful tests than 95% coverage with shallow tests that don't catch real bugs.

---

*Ready for the next level? Check out integration testing, golden tests, and mocking in Flutter!*
