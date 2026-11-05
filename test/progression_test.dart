import 'dart:convert';

import 'package:daybreak_chronicles/progression.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final morning = DateTime(2026, 1, 10, 9);
  final tomorrow = DateTime(2026, 1, 11, 9);

  Profile meadowCleared() {
    final profile = Profile(morning);
    for (var second = 0; second < 5; second++) {
      profile.battleSecond();
    }
    return profile;
  }

  test('life quests award skill XP once per day and reveal matching paths', () {
    final profile = Profile(morning);
    expect(profile.awaken(Awakening.sunwarden), isFalse);
    expect(profile.logQuest(LifeQuest.walk, morning), isTrue);
    expect(profile.logQuest(LifeQuest.walk, morning), isFalse);
    expect(profile.xp(Skill.vitality), 10);
    expect(profile.attack, 5);
    expect(profile.discoverable, isEmpty);

    expect(profile.logQuest(LifeQuest.walk, tomorrow), isTrue);
    expect(profile.discoverable, [Awakening.sunwarden]);
    expect(profile.awaken(Awakening.sunwarden), isTrue);
    expect(profile.attack, 8);
  });

  test('exploration recruits Miri and subsequent clears level both heroes', () {
    final profile = meadowCleared();
    expect(profile.hasCompanion, isTrue);
    expect(profile.stage, Stage.copperwood);
    expect(profile.companionXp, 0);
    for (var second = 0; second < 5; second++) {
      profile.battleSecond();
    }
    expect(profile.stage, Stage.copperwood);
    expect(profile.enemyHp, Stage.copperwood.hp);

    for (final quest in LifeQuest.values) {
      profile.logQuest(quest, morning);
    }
    for (var second = 0; second < 5; second++) {
      profile.battleSecond();
    }
    expect(profile.stage, Stage.dawnspire);
    expect(profile.level, 2);
    expect(profile.companionXp, 20);
  });

  test('a quest increases future damage without rewriting earlier hits', () {
    final profile = Profile(morning);
    profile.battleSecond();
    expect(profile.enemyHp, 16);
    profile.logQuest(LifeQuest.walk, morning);
    expect(profile.enemyHp, 16);
    profile.battleSecond();
    expect(profile.enemyHp, 11);
  });

  test('idle rewards require a clear and cap each absence at eight hours', () {
    final later = morning.add(const Duration(hours: 24));
    expect(Profile(morning).settleIdle(later), 0);

    final profile = meadowCleared();
    expect(profile.settleIdle(later), 480);
    expect(profile.settleIdle(later), 0);
    expect(profile.settleIdle(morning), 0);
    expect(profile.checkpoint, later.toUtc());
    expect(profile.stage, Stage.copperwood);
    expect(profile.playerXp, 490);
    expect(profile.companionXp, 480);
  });

  test('partial idle minutes, combat and quest claims survive serialization', () {
    final profile = meadowCleared();
    profile.logQuest(LifeQuest.walk, morning);
    profile.battleSecond();
    expect(profile.settleIdle(morning.add(const Duration(seconds: 40))), 0);
    final decoded = jsonDecode(jsonEncode(profile.toJson())) as Map<String, dynamic>;
    final restored = Profile.fromJson(decoded);
    expect(restored.toJson(), profile.toJson());
    expect(restored.loggedToday(LifeQuest.walk, morning), isTrue);
    expect(restored.settleIdle(morning.add(const Duration(seconds: 65))), 1);
    expect(restored.farmRemainderMs, 5000);
  });

  test('unknown save versions are rejected', () {
    final data = Profile(morning).toJson()..['version'] = 999;
    expect(() => Profile.fromJson(data), throwsFormatException);
  });
}
