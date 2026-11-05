import 'dart:math';

enum Skill { vitality, focus, craft }

enum LifeQuest {
  walk('Take a 15-minute walk', Skill.vitality),
  study('Spend 20 minutes learning', Skill.focus),
  make('Make something for 15 minutes', Skill.craft);

  const LifeQuest(this.label, this.skill);
  final String label;
  final Skill skill;
  static const xp = 10;
}

enum Awakening {
  sunwarden('Sunwarden', Skill.vitality),
  starreader('Starreader', Skill.focus),
  dawnsmith('Dawnsmith', Skill.craft);

  const Awakening(this.title, this.skill);
  final String title;
  final Skill skill;
  static const requiredXp = 20;
}

enum Stage {
  lanternMeadow('Lantern Meadow', 'Dewbud', 20),
  copperwood('Copperwood', 'Bramblekin', 40),
  dawnspire('Dawnspire', 'Hollow Bell', 70);

  const Stage(this.title, this.enemy, this.hp);
  final String title;
  final String enemy;
  final int hp;
}

String questDay(DateTime time) {
  final local = time.toLocal();
  return '${local.year}-${local.month}-${local.day}';
}

class Profile {
  Profile(DateTime now) : checkpoint = now.toUtc();

  final Map<Skill, int> _skills = {};
  final Map<LifeQuest, String> _logged = {};
  DateTime checkpoint;
  int playerXp = 0;
  int companionXp = 0;
  int cleared = 0;
  int battleTicks = 0;
  int battleDamage = 0;
  int farmRemainderMs = 0;
  Awakening? awakening;

  int xp(Skill skill) => _skills[skill] ?? 0;
  bool loggedToday(LifeQuest quest, DateTime now) => _logged[quest] == questDay(now);
  bool get hasCompanion => cleared > 0;
  int get level => 1 + playerXp ~/ 25;
  int get companionLevel => 1 + companionXp ~/ 25;
  Stage get stage => Stage.values[min(cleared, Stage.values.length - 1)];
  bool get campaignComplete => cleared == Stage.values.length;
  int get attack => 4 + min(level - 1, 4) +
      Skill.values.fold<int>(0, (sum, skill) => sum + xp(skill) ~/ 10) +
      (awakening == null ? 0 : 2) +
      (hasCompanion ? min(companionLevel, 4) : 0);

  Iterable<Awakening> get discoverable =>
      Awakening.values.where((path) => xp(path.skill) >= Awakening.requiredXp);

  bool logQuest(LifeQuest quest, DateTime now) {
    if (loggedToday(quest, now)) return false;
    _logged[quest] = questDay(now);
    _skills[quest.skill] = xp(quest.skill) + LifeQuest.xp;
    return true;
  }

  bool awaken(Awakening path) {
    if (!discoverable.contains(path) || awakening == path) return false;
    awakening = path;
    return true;
  }

  // Each expedition has five seconds to defeat its enemy. Weak parties retry.
  int get enemyHp => max(0, stage.hp - battleDamage);

  String battleSecond() {
    battleTicks++;
    battleDamage += attack;
    if (enemyHp > 0) {
      if (battleTicks < 5) return '';
      battleTicks = 0;
      battleDamage = 0;
      return 'The party regrouped. Life quests raise attack.';
    }
    final defeated = stage;
    final recruit = !hasCompanion;
    if (!campaignComplete) cleared++;
    playerXp += 10 * (defeated.index + 1);
    if (hasCompanion && !recruit) companionXp += 10 * (defeated.index + 1);
    battleTicks = 0;
    battleDamage = 0;
    return recruit
        ? 'Miri the lantern scout joins you at the meadow bridge.'
        : '${defeated.title} cleared.';
  }

  // The highest cleared stage supplies a fixed reward per full idle minute.
  // Settling never advances the story or moves the save clock backward.
  int settleIdle(DateTime now) {
    final elapsed = now.difference(checkpoint).inMilliseconds;
    if (elapsed <= 0) return 0;
    checkpoint = now.toUtc();
    if (!hasCompanion) return 0;
    final bank = min(elapsed, const Duration(hours: 8).inMilliseconds) +
        farmRemainderMs;
    const minute = Duration.millisecondsPerMinute;
    farmRemainderMs = bank % minute;
    final reward = bank ~/ minute * cleared;
    playerXp += reward;
    companionXp += reward;
    return reward;
  }

  void markActive(DateTime now) {
    if (now.isAfter(checkpoint)) checkpoint = now.toUtc();
  }

  Map<String, Object?> toJson() => {
    'version': 1,
    'checkpoint': checkpoint.toIso8601String(),
    'skills': _skills.map((key, value) => MapEntry(key.name, value)),
    'logged': _logged.map((key, value) => MapEntry(key.name, value)),
    'playerXp': playerXp,
    'companionXp': companionXp,
    'cleared': cleared,
    'battleTicks': battleTicks,
    'battleDamage': battleDamage,
    'farmRemainderMs': farmRemainderMs,
    'awakening': awakening?.name,
  };

  factory Profile.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1) throw const FormatException('Unknown save version');
    int readInt(String key, [int? maximum]) {
      final value = json[key];
      if (value is! int || value < 0 || (maximum != null && value > maximum)) {
        throw FormatException('Invalid save field: $key');
      }
      return value;
    }

    final profile = Profile(DateTime.parse(json['checkpoint'] as String))
      ..playerXp = readInt('playerXp')
      ..companionXp = readInt('companionXp')
      ..cleared = readInt('cleared', Stage.values.length)
      ..battleTicks = readInt('battleTicks', 4)
      ..battleDamage = readInt('battleDamage', Stage.values.last.hp - 1)
      ..farmRemainderMs = readInt('farmRemainderMs', 59999);
    final skills = json['skills'] as Map<String, dynamic>;
    for (final skill in Skill.values) {
      final value = skills[skill.name] ?? 0;
      if (value is! int || value < 0) throw const FormatException('Invalid XP');
      profile._skills[skill] = value;
    }
    final logged = json['logged'] as Map<String, dynamic>;
    for (final quest in LifeQuest.values) {
      final day = logged[quest.name];
      if (day != null) profile._logged[quest] = day as String;
    }
    final path = json['awakening'];
    if (path != null && !profile.discoverable.any((item) =>
        item.name == path && profile.awaken(item))) {
      throw const FormatException('Invalid awakening');
    }
    return profile;
  }
}
