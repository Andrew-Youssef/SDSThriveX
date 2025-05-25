import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';
import 'package:thrivex/providers/user_provider.dart';

/// Pumps a minimal widget tree and gives you a BuildContext
Future<BuildContext> getTestContext(WidgetTester tester) async {
  late BuildContext context;

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext ctx) {
            context = ctx;
            return const Placeholder();
          },
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
  return context;
}