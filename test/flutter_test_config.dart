import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Enables golden tests to run on CI/CD
      skipGoldenAssertion: () => false,
      // Enables golden file generation
      enableRealShadows: true,
      // Default device for single-device tests
      defaultDevices: const [Device.phone],
    ),
  );
}
