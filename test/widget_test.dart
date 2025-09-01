// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:habit_tracker/app.dart';

void main() {
  testWidgets('Habit Tracker smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that our app shows the welcome message.
    expect(find.text('Welcome to Habit Tracker!'), findsOneWidget);
    expect(find.text('Your journey to better habits starts here'), findsOneWidget);
  });
}
