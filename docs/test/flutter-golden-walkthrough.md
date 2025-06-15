# 🎯 Golden Testing with golden_toolkit

## 📖 Overview

Golden testing (also known as snapshot testing) is a powerful technique for ensuring your Flutter UI remains consistent across code changes. The `golden_toolkit` package provides the best golden testing experience for Flutter.

## ✨ Why golden_toolkit?

### **Advantages over Flutter's built-in golden tests:**

| Feature                        | Built-in Golden Tests | golden_toolkit         |
|--------------------------------|-----------------------|------------------------|
| **Cross-platform consistency** | ❌ OS-dependent       | ✅ Identical across OS |
| **Device simulation**          | ⚠️ Basic              | ✅ Multiple devices    |
| **Font loading**               | ❌ Manual setup       | ✅ Automatic           |
| **Loading states**             | ❌ Manual handling    | ✅ Built-in support    |
| **Multi-widget testing**       | ❌ Single widget      | ✅ Multiple scenarios  |
| **Failure debugging**          | ⚠️ Basic              | ✅ Advanced diff tools |

## 🚀 Getting Started

### 1. Dependencies

Already added to your `pubspec.yaml`:
```yaml
dev_dependencies:
  golden_toolkit: ^0.15.0
```

### 2. Test Configuration

Configuration file: `test/flutter_test_config.dart`
```dart
import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      skipGoldenAssertion: () => false,
      enableRealShadows: true,
      defaultDevices: const [Device.phone],
    ),
  );
}
```

## 📝 Writing Golden Tests

### Basic Single-Device Test
```dart
testGoldens('Counter App - Initial State', (tester) async {
  await tester.pumpWidgetBuilder(
    const MyApp(),
    surfaceSize: const Size(400, 800),
  );

  await screenMatchesGolden(tester, 'counter_app_initial');
});
```

### Multi-Device Test
```dart
testGoldens('Counter App - Multiple Devices', (tester) async {
  final builder = DeviceBuilder()
    ..overrideDevicesForAllScenarios(
      devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
      ],
    )
    ..addScenario(
      widget: const MyApp(),
      name: 'counter_initial',
    );

  await tester.pumpDeviceBuilder(builder);
  await screenMatchesGolden(tester, 'counter_app_devices');
});
```

### Testing User Interactions
```dart
testGoldens('Counter App - After Increment', (tester) async {
  await tester.pumpWidgetBuilder(const MyApp());

  // Simulate user interaction
  await tester.tap(find.byTooltip('Increment'));
  await tester.pumpAndSettle();

  await screenMatchesGolden(tester, 'counter_app_incremented');
});
```

## 🛠️ Available Commands

Use the provided script for easy management:

### Basic Commands
```bash
# Run golden tests
./scripts/golden-test.sh run

# Generate/update golden files
./scripts/golden-test.sh update

# Check status
./scripts/golden-test.sh status

# Clean golden files
./scripts/golden-test.sh clean
```

### Direct Flutter Commands
```bash
# Run golden tests
flutter test test/golden_test.dart

# Update golden files
flutter test test/golden_test.dart --update-goldens

# Run with verbose output
flutter test test/golden_test.dart --verbose
```

## 📊 Available Devices

golden_toolkit provides predefined devices:

```dart
// Phones
Device.phone            // Generic phone
Device.iphone11         // iPhone 11
Device.smallPhone       // Small phone

// Tablets
Device.tabletPortrait   // Tablet in portrait
Device.tabletLandscape  // Tablet in landscape

// Desktop
Device.desktop          // Desktop size

// Custom device
Device(
  name: 'custom',
  size: Size(390, 844),
  devicePixelRatio: 3.0,
)
```

## 🎨 Best Practices

### 1. **Organize Tests by Feature**
```dart
group('Counter App Golden Tests', () {
  testGoldens('initial state', ...);
  testGoldens('after increment', ...);
  testGoldens('error state', ...);
});
```

### 2. **Test Multiple States**
- ✅ Initial/empty states
- ✅ Loading states
- ✅ Success states with data
- ✅ Error states
- ✅ Edge cases (long text, etc.)

### 3. **Use Descriptive Names**
```dart
// ❌ Bad
await screenMatchesGolden(tester, 'test1');

// ✅ Good
await screenMatchesGolden(tester, 'login_form_validation_error');
```

### 4. **Test Multiple Screen Sizes**
```dart
// Test responsive design
devices: [
  Device.phone,        // 375x812
  Device.tabletPortrait, // 768x1024
  Device.desktop,      // 1366x768
]
```

## 🔧 Configuration Options

### Test Configuration
```dart
GoldenToolkitConfiguration(
  // Skip golden tests (useful for CI)
  skipGoldenAssertion: () => Platform.isWindows,
  
  // Enable real shadows
  enableRealShadows: true,
  
  // Default devices for single-device tests
  defaultDevices: const [Device.phone],
  
  // Threshold for pixel differences
  threshold: 0.5,
)
```

### Device Builder Options
```dart
DeviceBuilder()
  // Override devices for all scenarios
  ..overrideDevicesForAllScenarios(devices: [...])
  
  // Add scenarios
  ..addScenario(widget: widget, name: 'scenario_name')
  
  // Wrap widgets
  ..wrap(materialAppWrapper())
```

## 🚦 CI/CD Integration

### GitHub Actions Example
```yaml
name: Golden Tests
on: [push, pull_request]

jobs:
  golden-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/golden_test.dart
```

### Handling Failures in CI
```dart
// Skip golden tests in CI
skipGoldenAssertion: () => Platform.environment['CI'] == 'true',
```

## 🔍 Debugging Failed Tests

### 1. **Visual Diff Tools**
When tests fail, golden_toolkit generates helpful diff images:
- `failure_*.png` - Shows differences highlighted

### 2. **Common Failure Causes**
- **Font loading issues**: Ensure `loadAppFonts()` is called
- **Platform differences**: Use consistent test environment
- **Timing issues**: Use `pumpAndSettle()` for animations
- **Size differences**: Specify explicit `surfaceSize`

### 3. **Updating Golden Files**
```bash
# Update all golden files
./scripts/golden-test.sh update

# Update specific test
flutter test test/golden_test.dart --update-goldens --plain-name "specific test name"
```

## 📁 File Structure

```
test/
├── flutter_test_config.dart    # Global test configuration
├── golden_test.dart            # Golden test definitions
└── goldens/                    # Generated golden images
    ├── counter_app_initial.png
    ├── counter_app_incremented.png
    └── counter_app_devices.png
```

## 🎯 Next Steps

1. **Add more scenarios** to `golden_test.dart`
2. **Test different themes** (light/dark mode)
3. **Test error states** and loading states
4. **Add accessibility testing** with golden tests
5. **Integrate with your CI/CD pipeline**

## 📚 Advanced Topics

### Custom Wrapper Functions
```dart
Widget materialAppWrapper({ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
    home: Material(child: Builder(builder: (context) => widget)),
  );
}
```

### Testing Animations
```dart
testGoldens('loading animation', (tester) async {
  await tester.pumpWidgetBuilder(LoadingWidget());
  
  // Test different animation frames
  await tester.pump(Duration(milliseconds: 100));
  await screenMatchesGolden(tester, 'loading_frame_1');
  
  await tester.pump(Duration(milliseconds: 200));
  await screenMatchesGolden(tester, 'loading_frame_2');
});
```

---

**Happy Golden Testing! 🎯✨**
