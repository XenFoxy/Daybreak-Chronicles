import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progression.dart';
import 'save_store.dart';
import 'trail_scene.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DaybreakApp(store: SaveStore(SharedPreferencesAsync())));
}

class DaybreakApp extends StatelessWidget {
  const DaybreakApp({super.key, required this.store});

  final SaveStore store;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Daybreak Chronicles',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffe5a751),
        brightness: Brightness.dark,
      ),
    ),
    home: Chronicle(store: store),
  );
}

class Chronicle extends StatefulWidget {
  const Chronicle({super.key, required this.store});

  final SaveStore store;

  @override
  State<Chronicle> createState() => _ChronicleState();
}

class _ChronicleState extends State<Chronicle> with WidgetsBindingObserver {
  Profile? _profile;
  late final TrailScene _scene = TrailScene(() => _profile!);
  Timer? _timer;
  bool _foreground = true;
  bool _settleOnResume = false;
  bool _saving = false;
  bool _saveError = false;
  String _trailNote = 'Follow the lanterns through the meadow.';
  String? _idleNote;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _foreground = WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    unawaited(_open());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) {
      _tick();
    } else {
      _settleOnResume = true;
    }
  }

  Future<void> _open() async {
    setState(() => _saveError = false);
    try {
      final now = DateTime.now();
      final profile = await widget.store.load(now);
      final reward = profile.settleIdle(now);
      await widget.store.save(profile);
      if (!mounted) return;
      setState(() {
        _profile = profile;
        if (reward > 0) _idleNote = _rewardText(reward);
      });
    } catch (_) {
      if (mounted) setState(() => _saveError = true);
    }
  }

  String _rewardText(int xp) => 'While away, you and Miri each earned $xp XP.';

  void _tick() {
    if (!_foreground || _profile == null || _saving) return;
    final now = DateTime.now();
    if (_settleOnResume) {
      _settleOnResume = false;
      unawaited(_commit((profile) => profile.settleIdle(now)).then((saved) {
        if (!saved) _settleOnResume = true;
      }));
    } else {
      unawaited(_commit((profile) {
        profile.markActive(now);
        return profile.battleSecond();
      }));
    }
  }

  Future<bool> _commit(Object Function(Profile) change) async {
    if (!_foreground || _saving) return false;
    _saving = true;
    final candidate = Profile.fromJson(_profile!.toJson());
    final result = change(candidate);
    try {
      await widget.store.save(candidate);
      if (!mounted) return true;
      setState(() {
        _profile = candidate;
        _saveError = false;
        if (result is String && result.isNotEmpty) _trailNote = result;
        if (result is int && result > 0) _idleNote = _rewardText(result);
      });
      return true;
    } catch (_) {
      if (mounted) setState(() => _saveError = true);
      return false;
    } finally {
      _saving = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Daybreak Chronicles')),
      body: SafeArea(
        child: profile == null
            ? Center(
                child: _saveError
                    ? FilledButton(
                        onPressed: _open,
                        child: const Text('Could not open the save. Retry'),
                      )
                    : const CircularProgressIndicator(),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 660),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Text('THE LANTERN TRAIL', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(height: 185, child: GameWidget(game: _scene)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Stage ${profile.stage.index + 1} · ${profile.stage.title}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text('${profile.stage.enemy} · ${profile.enemyHp}/${profile.stage.hp} HP'),
                      LinearProgressIndicator(value: profile.enemyHp / profile.stage.hp),
                      const SizedBox(height: 8),
                      Text(profile.campaignComplete ? 'Trail complete · replaying Dawnspire' : _trailNote),
                      if (_idleNote != null) Text(_idleNote!),
                      if (_saveError) const Text('Could not save progress. Retrying…'),
                      const Divider(height: 32),
                      Text('Your party', style: Theme.of(context).textTheme.titleLarge),
                      Text('Adventurer · Lv. ${profile.level} · ${profile.playerXp} XP · ${profile.attack} party attack'),
                      Text(profile.hasCompanion
                          ? 'Miri, lantern scout · Lv. ${profile.companionLevel} · ${profile.companionXp} XP'
                          : 'Your first companion awaits beyond Lantern Meadow.'),
                      const Divider(height: 32),
                      Text('Life quests', style: Theme.of(context).textTheme.titleLarge),
                      const Text('Log a completed activity once per local day.'),
                      for (final quest in LifeQuest.values)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(quest.label),
                          subtitle: Text('+${LifeQuest.xp} ${quest.skill.name} XP'),
                          trailing: OutlinedButton(
                            onPressed: profile.loggedToday(quest, now)
                                ? null
                                : () => _commit((p) => p.logQuest(quest, DateTime.now())),
                            child: Text(profile.loggedToday(quest, now) ? 'Logged' : 'Log'),
                          ),
                        ),
                      const Divider(height: 32),
                      Text('Skill profile', style: Theme.of(context).textTheme.titleLarge),
                      for (final skill in Skill.values)
                        Text('${skill.name} · ${profile.xp(skill)} XP'),
                      const SizedBox(height: 12),
                      Text(
                        profile.awakening == null
                            ? 'Awakenings · Discover a path at 20 XP in a skill.'
                            : 'Awakening · ${profile.awakening!.title}',
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final path in profile.discoverable)
                            ChoiceChip(
                              label: Text(path.title),
                              selected: path == profile.awakening,
                              onSelected: (selected) {
                                if (selected) _commit((p) => p.awaken(path));
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
