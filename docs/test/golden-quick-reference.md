# ⚡ Golden Testing Quick Reference

## 🚀 Script Commands

```bash
# Run all golden tests
./scripts/golden-test.sh run

# Generate/update golden master images
./scripts/golden-test.sh update

# Check golden test setup status
./scripts/golden-test.sh status

# Remove all golden files
./scripts/golden-test.sh clean

# Show help
./scripts/golden-test.sh help
```

## 🔧 Flutter Commands

```bash
# Run golden tests directly
flutter test test/golden_test.dart

# Update golden files
flutter test test/golden_test.dart --update-goldens

# Run with detailed output
flutter test test/golden_test.dart --verbose

# Update specific test
flutter test --update-goldens --plain-name "test name"
```

## 📝 Basic Test Template

```dart
testGoldens('Widget Test', (tester) async {
  await tester.pumpWidgetBuilder(
    const MyWidget(),
    surfaceSize: const Size(400, 800),
  );
  await screenMatchesGolden(tester, 'widget_test');
});
```

## 📱 Multi-Device Template

```dart
testGoldens('Multi Device', (tester) async {
  final builder = DeviceBuilder()
    ..overrideDevicesForAllScenarios(
      devices: [Device.phone, Device.tabletPortrait],
    )
    ..addScenario(widget: MyWidget(), name: 'scenario');
  await tester.pumpDeviceBuilder(builder);
  await screenMatchesGolden(tester, 'multi_device');
});
```

## 🎯 Available Devices

```dart
Device.phone            // Generic phone (375x812)
Device.iphone11         // iPhone 11 size
Device.smallPhone       // Small phone
Device.tabletPortrait   // Tablet portrait (768x1024)
Device.tabletLandscape  // Tablet landscape
Device.desktop          // Desktop size (1366x768)

// Custom device
Device(
  name: 'custom',
  size: Size(390, 844),
  devicePixelRatio: 3.0,
)
```

## ⚙️ Test Configuration

```dart
// test/flutter_test_config.dart
import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      defaultDevices: const [Device.phone],
    ),
  );
}
```

## 🔍 Debugging Tips

```dart
// Wait for animations to complete
await tester.pumpAndSettle();

// Set explicit widget size
surfaceSize: const Size(400, 800)

// Load fonts for consistent rendering
await loadAppFonts();

// Enable shadows in golden tests
enableRealShadows: true

// Handle async operations
await tester.pump(Duration(milliseconds: 100));
```

## 📁 File Locations

- **test/golden_test.dart** - Golden test definitions
- **test/flutter_test_config.dart** - Test configuration
- **test/goldens/** - Generated golden images
- **scripts/golden-test.sh** - Golden test helper script

## 🎨 Best Practices

### ✅ Test Multiple States
- Initial/empty states
- Loading states  
- Success states with data
- Error states
- Edge cases (long text, etc.)

### ✅ Use Descriptive Names
```dart
// ❌ Bad
await screenMatchesGolden(tester, 'test1');

// ✅ Good  
await screenMatchesGolden(tester, 'login_form_validation_error');
```

### ✅ Test Multiple Devices
```dart
devices: [
  Device.phone,        // 375x812
  Device.tabletPortrait, // 768x1024  
  Device.desktop,      // 1366x768
]
```

### ✅ Group Related Tests
```dart
group('Counter App Golden Tests', () {
  testGoldens('initial state', ...);
  testGoldens('after increment', ...);
  testGoldens('error state', ...);
});
```

## 🚨 Common Issues

### Font Loading Problems
```dart
// Ensure fonts are loaded
await loadAppFonts();
```

### Platform Differences  
```dart
// Use consistent test environment
skipGoldenAssertion: () => Platform.isWindows,
```

### Timing Issues
```dart
// Wait for animations
await tester.pumpAndSettle();

// Or specific duration
await tester.pump(Duration(milliseconds: 500));
```

### Size Inconsistencies
```dart
// Always specify surface size
await tester.pumpWidgetBuilder(
  widget,
  surfaceSize: const Size(400, 800),
);
```

## 🎯 Advanced Patterns

### Custom Wrapper
```dart
Widget materialAppWrapper({ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
    home: Material(child: widget),
  );
}
```

### Animation Testing
```dart
testGoldens('animation frames', (tester) async {
  await tester.pumpWidgetBuilder(AnimatedWidget());
  
  // Frame 1
  await tester.pump(Duration(milliseconds: 100));
  await screenMatchesGolden(tester, 'animation_frame_1');
  
  // Frame 2
  await tester.pump(Duration(milliseconds: 200));
  await screenMatchesGolden(tester, 'animation_frame_2');
});
```

### Theme Testing
```dart
testGoldens('light and dark themes', (tester) async {
  final builder = DeviceBuilder()
    ..addScenario(
      widget: MyApp(theme: ThemeData.light()),
      name: 'light_theme',
    )
    ..addScenario(
      widget: MyApp(theme: ThemeData.dark()),
      name: 'dark_theme',
    );
    
  await tester.pumpDeviceBuilder(builder);
  await screenMatchesGolden(tester, 'theme_comparison');
});
```

---

**⚡ Quick and efficient golden testing!**
