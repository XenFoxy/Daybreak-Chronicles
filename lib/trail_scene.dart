import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';

import 'progression.dart';

class TrailScene extends FlameGame {
  TrailScene(this.readProfile);

  final Profile Function() readProfile;
  double _time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final profile = readProfile();
    final w = size.x;
    final h = size.y;
    final paint = Paint();
    final sky = [0xff35375e, 0xff284849, 0xff453256][profile.stage.index];
    final ground = h * .77;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint..color = Color(sky));
    canvas.drawCircle(Offset(w * .74, h * .31), 30, paint..color = const Color(0xffffd793));
    for (var layer = 0; layer < 2; layer++) {
      final path = Path()..moveTo(0, h);
      for (var x = 0.0; x <= w + 8; x += 8) {
        final wave = sin(x / (48 + layer * 30) + _time * (.35 + layer * .25));
        path.lineTo(x, h * (.54 + layer * .11) + wave * 13);
      }
      path..lineTo(w, h)..close();
      canvas.drawPath(path, paint..color = Color(layer == 0 ? 0xff697289 : 0xff454f66));
    }
    canvas.drawRect(Rect.fromLTWH(0, ground, w, h - ground), paint..color = const Color(0xff222839));
    for (var x = -(_time * 45 % 32); x < w; x += 32) {
      canvas.drawRect(Rect.fromLTWH(x, ground + 11, 14, 2), paint..color = const Color(0xff637784));
    }

    final hop = sin(_time * 10) * 3;
    if (profile.hasCompanion) {
      _chibi(canvas, Offset(w * .19, ground + hop), const Color(0xffe5a751));
    }
    final lunge = pow(max(0, 1 - (_time % 1) * 4), 2) * 19;
    _chibi(canvas, Offset(w * .39 + lunge, ground - hop), const Color(0xff98cdd6));
    final enemy = Offset(w * .73, ground - 13 + hop);
    canvas.drawOval(Rect.fromCenter(center: enemy, width: 39, height: 30),
        paint..color = const Color(0xffd389aa));
    canvas.drawCircle(enemy.translate(-7, 1), 2.5, paint..color = const Color(0xff332435));
    canvas.drawCircle(enemy.translate(6, 1), 2.5, paint);
  }

  void _chibi(Canvas canvas, Offset feet, Color cloak) {
    final paint = Paint()..color = cloak;
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: feet.translate(0, -9), width: 23, height: 22),
        const Radius.circular(6)), paint);
    final head = feet.translate(0, -31);
    canvas.drawPath(Path()
      ..moveTo(head.dx - 17, head.dy)
      ..lineTo(head.dx - 14, head.dy - 25)
      ..lineTo(head.dx + 2, head.dy - 13)
      ..lineTo(head.dx + 15, head.dy - 24)
      ..lineTo(head.dx + 17, head.dy)
      ..close(), paint);
    canvas.drawCircle(head, 17, paint);
    canvas.drawOval(Rect.fromCenter(center: head.translate(2, 4), width: 27, height: 21),
        paint..color = const Color(0xffffe2bc));
    paint.color = const Color(0xff24233a);
    canvas.drawOval(Rect.fromCenter(center: head.translate(-2, 4), width: 4, height: 7), paint);
    canvas.drawOval(Rect.fromCenter(center: head.translate(10, 4), width: 4, height: 7), paint);
  }
}
