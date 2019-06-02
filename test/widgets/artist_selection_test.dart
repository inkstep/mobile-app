import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkstep/ui/components/artist_selection.dart';

void main() {
  group('Artist Selection', ()
  {
    testWidgets('renders text properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: ArtistProfileRow(
                name: 'Ricky Williams',
                studioName: 'South City Market',
                imagePath: 'assets/ricky.png',
              )
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Ricky Williams'), findsOneWidget);
      expect(find.text('South City Market'), findsOneWidget);
    });

    testWidgets('Can build with invalid image path', (WidgetTester tester)
    async {
      final ArtistProfileRow artistProfileRow = ArtistProfileRow(
        name: 'Ricky Williams',
        studioName: 'South City Market',
        imagePath: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
              body: artistProfileRow
          ),
        ),
      );

      await tester.pumpAndSettle();
    });
  });
}