// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_see_text.dart';
import './step/i_see_icon.dart';
import './step/i_tap_icon.dart';
import './step/i_tap_icon_twice.dart';

void main() {
  group('''Counter''', () {
    Future<void> bddSetUp(WidgetTester tester) async {
      await theAppIsRunning(tester);
    }

    testWidgets('''The counter just started''', (tester) async {
      await bddSetUp(tester);
      await iSeeText(tester, 'You have pushed the button this many times:');
      await iSeeText(tester, '0');
      await iSeeIcon(tester, Icons.add);
    });
    testWidgets('''The counter should increase''', (tester) async {
      await bddSetUp(tester);
      await iTapIcon(tester, Icons.add);
      await iSeeText(tester, '1');
    });
    testWidgets('''The counter should show "two" instead of 2''', (
      tester,
    ) async {
      await bddSetUp(tester);
      await iTapIconTwice(tester, Icons.add);
      await iSeeText(tester, 'two');
    });
  });
}
