import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hyfata_music_app/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HyfataMusicApp()));

    // Verify the app builds (Home title or similar)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
