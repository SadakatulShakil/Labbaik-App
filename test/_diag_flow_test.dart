import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:labbaik_project/main.dart';

void main() {
  testWidgets('diagnostic: splash -> language flow renders visible content', (tester) async {
    await GetStorage.init();
    final box = GetStorage();
    await box.erase();

    await tester.pumpWidget(const LabbaikApp());

    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 1));
      final err = tester.takeException();
      if (err != null) {
        debugPrint('!!! EXCEPTION at tick $i: $err');
      }
    }

    debugPrint('--- texts: ${tester.allWidgets.whereType<Text>().map((t) => t.data).toList()}');
    debugPrint('--- scaffolds: ${tester.widgetList(find.byType(Scaffold)).length}');
    debugPrint('--- isFirstLaunch after run: ${box.read<bool>('firstLaunch')}');
  });
}
