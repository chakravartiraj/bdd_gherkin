import 'package:bdd_gherkin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('Golden Tests', () {
    testGoldens('Counter App - Initial State', (tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidgetBuilder(
        const MyApp(),
        surfaceSize: const Size(400, 800),
      );

      await screenMatchesGolden(tester, 'counter_app_initial');
    });

    testGoldens('Counter App - After Increment', (tester) async {
      await tester.pumpWidgetBuilder(
        const MyApp(),
        surfaceSize: const Size(400, 800),
      );

      // Tap the increment button
      await tester.tap(find.byTooltip('Increment'));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'counter_app_incremented');
    });

    testGoldens('Counter App - Multiple Device Sizes', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: [Device.phone, Device.iphone11, Device.tabletPortrait],
        )
        ..addScenario(widget: const MyApp(), name: 'counter_initial')
        ..addScenario(
          widget: Builder(
            builder: (context) {
              return MaterialApp(
                home: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    title: const Text('Flutter BDD Gherkin'),
                  ),
                  body: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('You have pushed the button this many times:'),
                        Text('5', style: TextStyle(fontSize: 25)),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {},
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  ),
                ),
              );
            },
          ),
          name: 'counter_with_value',
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'counter_app_devices');
    });
  });
}
