part of 'chronicle_view.dart';

const _navy = Color(0xff132541);
const _ice = Color(0xffb8e9ff);
const _cut = BeveledRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(13)),
  side: BorderSide(color: Color(0xffb0daf5)),
);

class _HomeView extends StatelessWidget {
  const _HomeView({
    required this.profile,
    required this.battle,
    required this.trailNote,
    required this.idleNote,
    required this.saveError,
    required this.onJournal,
    required this.onParty,
  });

  final Profile profile;
  final Widget battle;
  final String trailNote;
  final String? idleNote;
  final bool saveError;
  final VoidCallback onJournal;
  final VoidCallback onParty;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff243e63), _navy],
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  children: [
                    _battlefield(wide),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        wide ? 24 : 12,
                        14,
                        wide ? 24 : 12,
                        16,
                      ),
                      child: Column(
                        spacing: 12,
                        children: [
                          _actions(context, constraints.maxWidth < 340),
                          _partyStrip(),
                        ],
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
  );

  Widget _battlefield(bool wide) => SizedBox(
    height: wide ? 435 : 390,
    child: Stack(
      fit: StackFit.expand,
      children: [
        battle,
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xd9132541),
                  Color(0x00132541),
                  Color(0x00132541),
                  Color(0xf2132541),
                ],
                stops: [0, .43, .69, 1],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(wide ? 24 : 12, 12, wide ? 24 : 12, 12),
          child: Column(
            children: [
              Row(
                spacing: 9,
                children: [
                  const _FoxPortrait(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DAYBREAK CHRONICLES',
                          style: TextStyle(
                            color: _ice,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                          ),
                        ),
                        Text(
                          profile.awakening?.title ?? 'Adventurer',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _GlassLabel('LV. ${profile.level}'),
                ],
              ),
              const SizedBox(height: 13),
              Material(
                color: const Color(0xe6223f67),
                shape: _cut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'CHAPTER 01   /   THE LANTERN TRAIL',
                        style: TextStyle(
                          color: _ice,
                          fontSize: 10,
                          letterSpacing: 1.25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        profile.stage.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                label:
                    '${profile.cleared} of ${Stage.values.length} stages cleared',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final stage in Stage.values) ...[
                      if (stage.index > 0)
                        Container(width: 24, height: 2, color: _ice),
                      Icon(
                        stage.index < profile.cleared
                            ? Icons.check_circle_rounded
                            : stage == profile.stage
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined,
                        color: stage == profile.stage
                            ? const Color(0xffffda85)
                            : _ice,
                        size: 20,
                        shadows: const [Shadow(color: _navy, blurRadius: 4)],
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              Row(
                spacing: 10,
                children: [
                  const _GlassLabel('AUTO-BATTLE', icon: Icons.bolt_rounded),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${profile.stage.enemy}  ·  ${profile.enemyHp}/${profile.stage.hp} HP',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            shadows: [Shadow(color: _navy, blurRadius: 5)],
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: profile.enemyHp / profile.stage.hp,
                          minHeight: 5,
                          color: const Color(0xffffce78),
                          backgroundColor: _navy,
                          semanticsLabel: 'Enemy health',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  saveError
                      ? 'Could not save progress. Retrying…'
                      : profile.campaignComplete
                      ? 'Trail complete · replaying Dawnspire'
                      : trailNote,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _actions(BuildContext context, bool stack) {
    final quests = _HomeAction(
      title: 'Life Quests',
      detail: 'Daily journal',
      icon: Icons.menu_book_rounded,
      onTap: onJournal,
    );
    final rewards = _HomeAction(
      title: 'Away Rewards',
      detail: idleNote != null ? 'XP earned' : 'Idle progress',
      icon: Icons.card_giftcard_rounded,
      gold: true,
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Away Rewards'),
          content: Text(
            idleNote ??
                (profile.hasCompanion
                    ? 'You and Miri each earn ${profile.cleared} XP per full idle minute, up to eight hours away. XP is added when you return.'
                    : 'Clear Lantern Meadow to start earning XP while away.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
    return stack
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [quests, rewards],
          )
        : Row(
            spacing: 10,
            children: [
              Expanded(child: quests),
              Expanded(child: rewards),
            ],
          );
  }

  Widget _partyStrip() => Material(
    color: const Color(0xff28466c),
    shape: _cut,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'MAIN PARTY',
                  style: TextStyle(
                    color: _ice,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              _GlassLabel('${profile.attack} ATK', icon: Icons.shield_rounded),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              _member(
                'Adventurer',
                'Lv. ${profile.level}',
                const _FoxPortrait(),
              ),
              _member(
                profile.hasCompanion ? 'Miri' : 'Companion',
                profile.hasCompanion
                    ? 'Lv. ${profile.companionLevel}'
                    : 'Awaiting scout',
                profile.hasCompanion
                    ? const _FoxPortrait(teal: true)
                    : const Icon(
                        Icons.lock_outline_rounded,
                        color: _ice,
                        size: 30,
                      ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _member(String name, String detail, Widget portrait) => OutlinedButton(
    onPressed: onParty,
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: _navy,
      side: const BorderSide(color: Color(0xff688db0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      padding: const EdgeInsets.all(7),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        portrait,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(detail, style: const TextStyle(color: _ice, fontSize: 11)),
          ],
        ),
      ],
    ),
  );
}

class _FoxPortrait extends StatelessWidget {
  const _FoxPortrait({this.teal = false});

  final bool teal;

  @override
  Widget build(BuildContext context) => Container(
    width: 39,
    height: 39,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xff6ab4d0), Color(0xff24476e)],
      ),
      border: Border.all(color: _ice),
      borderRadius: BorderRadius.circular(9),
    ),
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: 216,
        maxWidth: 216,
        child: Image.asset(
          'assets/images/sunnyland/fox-run.png',
          width: 216,
          filterQuality: FilterQuality.none,
          color: teal ? const Color(0x8065ded8) : null,
          colorBlendMode: BlendMode.srcATop,
        ),
      ),
    ),
  );
}

class _GlassLabel extends StatelessWidget {
  const _GlassLabel(this.text, {this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xe6244770),
    shape: _cut,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          if (icon case final glyph?) Icon(glyph, size: 16, color: _ice),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  );
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.title,
    required this.detail,
    required this.icon,
    required this.onTap,
    this.gold = false,
  });

  final String title;
  final String detail;
  final IconData icon;
  final VoidCallback onTap;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final foreground = gold ? const Color(0xff462912) : Colors.white;
    return Material(
      shape: _cut,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: ShapeDecoration(
          shape: _cut,
          gradient: LinearGradient(
            colors: gold
                ? const [Color(0xffffedac), Color(0xffefb854)]
                : const [Color(0xff3d6f9e), Color(0xff253e70)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
            child: Row(
              spacing: 8,
              children: [
                Icon(icon, color: foreground, size: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        detail,
                        style: TextStyle(color: foreground, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
