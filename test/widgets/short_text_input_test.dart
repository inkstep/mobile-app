import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkstep/ui/components/short_text_input.dart';

void main() {
  group('Short Text Input', () {
    testWidgets('renders label and hint properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShortTextInput(
                controller: null,
                textController: null,
                label: 'label',
                hint: 'hint'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('label'), findsOneWidget);
      expect(find.text('hint'), findsOneWidget);
    });

    // TODO(matt-malarkey): verify the transition with mock controller
    testWidgets('transitions to next view on enter',
        (WidgetTester tester) async {
      final inputKey = UniqueKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShortTextInput(
                key: inputKey,
                controller: null,
                textController: null,
                label: 'label',
                hint: 'hint'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(inputKey), 'matthew');
    });
  });
}
