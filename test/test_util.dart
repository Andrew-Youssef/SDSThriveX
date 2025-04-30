import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a minimal widget tree and gives you a BuildContext
Future<BuildContext> getTestContext(WidgetTester tester) async {
  late BuildContext context;

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (BuildContext ctx) {
          context = ctx;
          return const Placeholder(); // We only need a context
        },
      ),
    ),
  );

  return context;
}