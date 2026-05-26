import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64, this.showCoin = true});

  final double size;
  final bool showCoin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(showCoin: showCoin),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.showCoin});
  final bool showCoin;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final scale = s / 512;
    double x(double v) => v * scale;

    final bgRect =
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(x(112)));
    final bgPaint = Paint()..color = const Color(0xFF2563EB);
    canvas.drawRRect(bgRect, bgPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: 'T',
        style: TextStyle(
          fontSize: x(360),
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.0,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset((s - tp.width) / 2, (s - tp.height) / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _LogoPainter old) => old.showCoin != showCoin;
}
