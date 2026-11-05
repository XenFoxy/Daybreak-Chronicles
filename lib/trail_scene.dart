import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';

import 'progression.dart';

const _art = 'sunnyland';

class TrailScene extends FlameGame {
  TrailScene(this.readProfile);

  final Profile Function() readProfile;
  final _paint = Paint()..filterQuality = FilterQuality.none;
  late final Image _sky;
  late final Image _foliage;
  late final Image _terrain;
  late final _Strip _run;
  late final _Strip _jump;
  late final List<_Strip> _enemies;
  double _time = 0;
  double _sinceHit = 1;
  int? _lastTick;
  int? _lastXp;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final art = await images.loadAll([
      '$_art/back.png',
      '$_art/middle.png',
      '$_art/tileset.png',
      '$_art/fox-run.png',
      '$_art/fox-jump.png',
      '$_art/frog-idle.png',
      '$_art/opossum.png',
      '$_art/eagle-attack.png',
    ]);
    _sky = art[0];
    _foliage = art[1];
    _terrain = art[2];
    _run = _Strip(art[3], 6);
    _jump = _Strip(art[4], 2);
    _enemies = [_Strip(art[5], 4), _Strip(art[6], 6), _Strip(art[7], 4)];
  }

  @override
  void update(double dt) {
    super.update(dt);
    final profile = readProfile();
    _time += dt;
    _sinceHit += dt;
    if (_lastTick != null &&
        (_lastTick != profile.battleTicks || _lastXp != profile.playerXp)) {
      _sinceHit = 0;
    }
    _lastTick = profile.battleTicks;
    _lastXp = profile.playerXp;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final profile = readProfile();
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;
    final ground = h * .79;
    final sceneryScale = h / 240;
    final spriteScale = h / 112;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, w, h));
    _paint.colorFilter = ColorFilter.mode(switch (profile.stage) {
      Stage.lanternMeadow => const Color(0xfffff3db),
      Stage.copperwood => const Color(0xff8fb5a0),
      Stage.dawnspire => const Color(0xffbb9fd3),
    }, BlendMode.modulate);
    _repeat(canvas, _sky, _bounds(_sky), 0, sceneryScale, 7);
    _repeat(
      canvas,
      _foliage,
      _bounds(_foliage),
      ground - 143 * sceneryScale,
      sceneryScale,
      23,
    );
    const grass = Rect.fromLTWH(48, 16, 16, 16);
    const soil = Rect.fromLTWH(16, 48, 16, 16);
    for (var y = ground; y < h; y += 16 * spriteScale) {
      _repeat(canvas, _terrain, y == ground ? grass : soil, y, spriteScale, 47);
    }

    if (profile.hasCompanion) {
      _paint.colorFilter = const ColorFilter.matrix([
        .22,
        .46,
        .32,
        0,
        0,
        .64,
        .28,
        .08,
        0,
        0,
        .78,
        .16,
        .06,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);
      _sprite(
        canvas,
        _run,
        _time + .26,
        w * .20,
        ground + 2,
        spriteScale * .85,
      );
    }

    _paint.colorFilter = null;
    final attacking = _sinceHit < .24;
    final lunge = attacking ? sin(_sinceHit / .24 * pi) * w * .11 : 0.0;
    _sprite(
      canvas,
      attacking ? _jump : _run,
      attacking ? _sinceHit : _time,
      w * .38 + lunge,
      ground,
      spriteScale,
    );

    final enemy = profile.stage.index;
    final enemyX = w * .73 + (attacking ? 4 : 0);
    final enemyY = enemy == 2 ? ground - h * .14 : ground;
    _sprite(canvas, _enemies[enemy], _time, enemyX, enemyY, spriteScale);
    if (_sinceHit < .14) {
      canvas.drawLine(
        Offset(enemyX - 8, enemyY - 17),
        Offset(enemyX + 8, enemyY - 31),
        _paint
          ..color = const Color(0xffffde93)
          ..strokeWidth = 3,
      );
    }
    canvas.restore();
  }

  Rect _bounds(Image image) =>
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

  void _repeat(
    Canvas canvas,
    Image image,
    Rect source,
    double y,
    double scale,
    double speed,
  ) {
    final width = source.width * scale;
    for (var x = -(_time * speed % width); x < size.x; x += width) {
      canvas.drawImageRect(
        image,
        source,
        Rect.fromLTWH(x, y, width, source.height * scale),
        _paint,
      );
    }
  }

  void _sprite(
    Canvas canvas,
    _Strip strip,
    double time,
    double x,
    double y,
    double scale,
  ) {
    final width = strip.frameWidth * scale;
    final height = strip.image.height * scale;
    canvas.drawImageRect(
      strip.image,
      strip.frame(time),
      Rect.fromLTWH(x - width / 2, y - height, width, height),
      _paint,
    );
  }
}

class _Strip {
  const _Strip(this.image, this.frames);

  final Image image;
  final int frames;
  double get frameWidth => image.width / frames;

  Rect frame(double seconds) => Rect.fromLTWH(
    (seconds * 10).floor() % frames * frameWidth,
    0,
    frameWidth,
    image.height.toDouble(),
  );
}
