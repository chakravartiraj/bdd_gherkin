import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'i_tap_icon.dart';

/// Usage: I tap {Icons.add} icon twice
Future<void> iTapIconTwice(WidgetTester tester, IconData icon) async {
  await iTapIcon(tester, icon);
  await iTapIcon(tester, icon);
}
