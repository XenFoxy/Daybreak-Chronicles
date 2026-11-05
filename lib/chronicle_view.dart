import 'package:flutter/material.dart';

import 'progression.dart';

part 'home_view.dart';

const _ink = Color(0xff20334a);
const _mist = Color(0xffe8f4fa);
const _line = Color(0xffcbdfe9);
const _blue = Color(0xff176388);
const _gold = Color(0xff8a4a18);
const _mint = Color(0xff17654c);

final daybreakTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: _blue,
    onPrimary: Colors.white,
    secondary: _mint,
    surface: Colors.white,
    onSurface: _ink,
    onSurfaceVariant: Color(0xff455e72),
  ),
  scaffoldBackgroundColor: _mist,
  useMaterial3: true,
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    ),
  ),
);

enum _Desk {
  home('Home', Icons.home_rounded),
  journal('Journal', Icons.menu_book_rounded),
  party('Party', Icons.groups_rounded),
  skills('Skills', Icons.auto_awesome_rounded);

  const _Desk(this.label, this.icon);
  final String label;
  final IconData icon;
}

class ChronicleView extends StatefulWidget {
  const ChronicleView({
    super.key,
    required this.profile,
    required this.now,
    required this.battle,
    required this.trailNote,
    required this.idleNote,
    required this.saveError,
    required this.onQuest,
    required this.onAwaken,
  });

  final Profile profile;
  final DateTime now;
  final Widget battle;
  final String trailNote;
  final String? idleNote;
  final bool saveError;
  final ValueChanged<LifeQuest> onQuest;
  final ValueChanged<Awakening> onAwaken;

  @override
  State<ChronicleView> createState() => _ChronicleViewState();
}

class _ChronicleViewState extends State<ChronicleView> {
  _Desk _desk = _Desk.home;

  void _select(_Desk desk) => setState(() => _desk = desk);

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return Scaffold(
      appBar: _desk == _Desk.home
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              titleSpacing: 16,
              title: const Row(
                children: [
                  _Emblem(Icons.wb_twilight_rounded, _gold),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Daybreak Chronicles',
                      style: TextStyle(fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? const Color(0xff123454)
                  : const Color(0xffc7dcf6),
            ),
          ),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        child: NavigationBar(
          height: 68,
          backgroundColor: const Color(0xff152843),
          indicatorColor: const Color(0xff8ce5ff),
          selectedIndex: _desk.index,
          onDestinationSelected: (index) => _select(_Desk.values[index]),
          destinations: [
            for (final desk in _Desk.values)
              NavigationDestination(icon: Icon(desk.icon), label: desk.label),
          ],
        ),
      ),
      body: _desk == _Desk.home
          ? _HomeView(
              profile: profile,
              battle: widget.battle,
              trailNote: widget.trailNote,
              idleNote: widget.idleNote,
              saveError: widget.saveError,
              onJournal: () => _select(_Desk.journal),
              onParty: () => _select(_Desk.party),
            )
          : DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffd9eef8), Color(0xfff7f6ef)],
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 840;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(wide ? 24 : 14),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1180),
                          child: Flex(
                            direction: wide ? Axis.horizontal : Axis.vertical,
                            mainAxisSize: wide
                                ? MainAxisSize.max
                                : MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16,
                            children: [
                              Flexible(
                                flex: 3,
                                fit: wide ? FlexFit.tight : FlexFit.loose,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _encounter(profile, wide),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: wide ? FlexFit.tight : FlexFit.loose,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: switch (_desk) {
                                    _Desk.home => const SizedBox.shrink(),
                                    _Desk.journal => _journal(profile),
                                    _Desk.party => _party(profile),
                                    _Desk.skills => _skills(profile),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _encounter(Profile profile, bool wide) => _Panel(
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 10,
        runSpacing: 6,
        children: [
          const _Label('CHAPTER 01  /  THE LANTERN TRAIL'),
          _Badge('AUTO-BATTLE', _mint),
        ],
      ),
      const SizedBox(height: 8),
      _Heading(profile.stage.title),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(height: wide ? 268 : 172, child: widget.battle),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 10,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _Badge(
            'STAGE ${profile.stage.index + 1} / ${Stage.values.length}',
            _blue,
          ),
          Text(
            '${profile.stage.enemy}  ·  ${profile.enemyHp} / ${profile.stage.hp} HP',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _Meter(profile.enemyHp / profile.stage.hp, _gold, label: 'Enemy health'),
      const SizedBox(height: 10),
      Text(
        widget.profile.campaignComplete
            ? 'Trail complete · replaying Dawnspire'
            : widget.trailNote,
      ),
      if (widget.idleNote case final note?) ...[
        const SizedBox(height: 10),
        _Notice(Icons.nights_stay_rounded, note, _mint),
      ],
      if (widget.saveError) ...[
        const SizedBox(height: 10),
        const _Notice(
          Icons.sync_problem_rounded,
          'Could not save progress. Retrying…',
          _gold,
        ),
      ],
    ],
  );

  Widget _journal(Profile profile) {
    final done = LifeQuest.values
        .where((quest) => profile.loggedToday(quest, widget.now))
        .length;
    return _Panel(
      children: [
        const _Label('DAILY FIELD NOTES'),
        const _Heading('Life quests'),
        const SizedBox(height: 4),
        Text('$done / ${LifeQuest.values.length} logged today'),
        const SizedBox(height: 14),
        for (final quest in LifeQuest.values) ...[
          _Tile(
            icon: _skillIcon(quest.skill),
            color: _skillColor(quest.skill),
            title: quest.label,
            detail: '+${LifeQuest.xp} ${quest.skill.name} XP',
            action: profile.loggedToday(quest, widget.now)
                ? const _Badge('LOGGED', _mint)
                : FilledButton(
                    onPressed: () => widget.onQuest(quest),
                    child: const Text('Log'),
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _party(Profile profile) => _Panel(
    children: [
      const _Label('EXPEDITION ROSTER'),
      const _Heading('Your party'),
      const SizedBox(height: 8),
      _Badge('${profile.attack} PARTY ATTACK', _gold),
      const SizedBox(height: 14),
      _Tile(
        icon: Icons.shield_rounded,
        color: _gold,
        title: 'Adventurer',
        detail:
            '${profile.awakening?.title ?? 'Trailblazer'} · ${profile.playerXp} XP',
        action: _Badge('LV. ${profile.level}', _gold),
      ),
      const SizedBox(height: 8),
      _Tile(
        icon: profile.hasCompanion
            ? Icons.explore_rounded
            : Icons.lock_outline_rounded,
        color: _mint,
        title: profile.hasCompanion ? 'Miri' : 'Companion slot',
        detail: profile.hasCompanion
            ? 'Lantern scout · ${profile.companionXp} XP'
            : 'Meet a scout beyond Lantern Meadow.',
        action: profile.hasCompanion
            ? _Badge('LV. ${profile.companionLevel}', _mint)
            : null,
      ),
    ],
  );

  Widget _skills(Profile profile) => _Panel(
    children: [
      const _Label('ADVENTURER RECORD'),
      const _Heading('Skill profile'),
      const SizedBox(height: 12),
      for (final skill in Skill.values) ...[
        _Tile(
          icon: _skillIcon(skill),
          color: _skillColor(skill),
          title: skill.name[0].toUpperCase() + skill.name.substring(1),
          detail: '${profile.xp(skill)} XP',
          meter: (profile.xp(skill) / Awakening.requiredXp).clamp(0.0, 1.0),
        ),
        const SizedBox(height: 8),
      ],
      const SizedBox(height: 6),
      const _Label('CLASS AWAKENINGS'),
      const SizedBox(height: 4),
      const Text('Discover a path at ${Awakening.requiredXp} XP in its skill.'),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final path in profile.discoverable)
            ChoiceChip(
              label: Text(path.title),
              selected: path == profile.awakening,
              onSelected: (selected) {
                if (selected) widget.onAwaken(path);
              },
            ),
        ],
      ),
    ],
  );
}

IconData _skillIcon(Skill skill) => switch (skill) {
  Skill.vitality => Icons.directions_walk_rounded,
  Skill.focus => Icons.lightbulb_outline_rounded,
  Skill.craft => Icons.brush_rounded,
};

Color _skillColor(Skill skill) => switch (skill) {
  Skill.vitality => _mint,
  Skill.focus => _blue,
  Skill.craft => _gold,
};

class _Panel extends StatelessWidget {
  const _Panel({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x18254e6a),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    this.action,
    this.meter,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final Widget? action;
  final double? meter;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xfff6faff),
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      spacing: 9,
      children: [
        _Emblem(icon, color),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(detail, style: TextStyle(color: color)),
              if (meter case final value?) ...[
                const SizedBox(height: 6),
                _Meter(value, color, label: '$title awakening progress'),
              ],
            ],
          ),
        ),
        ?action,
      ],
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(
      context,
    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _blue,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.15,
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
    ),
  );
}

class _Emblem extends StatelessWidget {
  const _Emblem(this.icon, this.color);
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .11),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Icon(icon, size: 20, color: color),
  );
}

class _Notice extends StatelessWidget {
  const _Notice(this.icon, this.text, this.color);
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 8,
    children: [
      Icon(icon, color: color, size: 18),
      Expanded(
        child: Text(text, style: TextStyle(color: color)),
      ),
    ],
  );
}

class _Meter extends StatelessWidget {
  const _Meter(this.value, this.color, {required this.label});
  final double value;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
    value: value,
    minHeight: 7,
    color: color,
    backgroundColor: _mist,
    borderRadius: BorderRadius.circular(4),
    semanticsLabel: label,
  );
}
