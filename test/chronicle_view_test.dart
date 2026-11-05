import 'package:daybreak_chronicles/chronicle_view.dart';
import 'package:daybreak_chronicles/progression.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final width in [360.0, 1024.0]) {
    testWidgets('battle and journal navigation fit at width $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 740));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime(2026, 11, 6);
      final profile = Profile(now)
        ..logQuest(LifeQuest.walk, now.subtract(const Duration(days: 1)))
        ..logQuest(LifeQuest.walk, now);
      LifeQuest? logged;
      Awakening? awakened;

      await tester.pumpWidget(
        MaterialApp(
          theme: daybreakTheme,
          home: ChronicleView(
            profile: profile,
            now: now,
            battle: const ColoredBox(key: Key('battle'), color: Colors.blue),
            trailNote: 'Follow the lanterns.',
            idleNote: 'While away, you and Miri each earned 12 XP.',
            saveError: false,
            onQuest: (quest) => logged = quest,
            onAwaken: (path) => awakened = path,
          ),
        ),
      );
      expect(find.text('Lantern Meadow'), findsOneWidget);
      expect(find.text('MAIN PARTY'), findsOneWidget);
      await tester.ensureVisible(find.text('Away Rewards'));
      await tester.tap(find.text('Away Rewards'));
      await tester.pumpAndSettle();
      expect(
        find.text('While away, you and Miri each earned 12 XP.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Life Quests'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 3 logged today'), findsOneWidget);
      expect(find.text('LOGGED'), findsOneWidget);
      final log = find.widgetWithText(FilledButton, 'Log').first;
      await tester.ensureVisible(log);
      await tester.tap(log);
      expect(logged, LifeQuest.study);

      await tester.tap(find.text('Party'));
      await tester.pumpAndSettle();
      expect(find.text('Your party'), findsOneWidget);
      expect(find.byKey(const Key('battle')), findsOneWidget);

      await tester.tap(find.text('Skills'));
      await tester.pumpAndSettle();
      final chip = find.widgetWithText(ChoiceChip, 'Sunwarden');
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      expect(awakened, Awakening.sunwarden);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('MAIN PARTY'), findsOneWidget);
      expect(find.byKey(const Key('battle')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
