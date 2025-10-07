import 'package:flutter/material.dart';

class BrandingCorner extends StatelessWidget {
  const BrandingCorner({super.key, required this.alignment, this.size = 220});

  final Alignment alignment;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: 0.32,
        child: AspectRatio(
          aspectRatio: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _CornerAccentPainter(alignment: alignment),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerAccentPainter extends CustomPainter {
  _CornerAccentPainter({required this.alignment});

  final Alignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    final bool flipX = alignment.x > 0;
    final bool flipY = alignment.y < 0;

    canvas.save();
    if (flipX) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }
    if (flipY) {
      canvas.translate(0, size.height);
      canvas.scale(1, -1);
    }

    final paintLayers = <_AccentLayer>[
      _AccentLayer(
        color: const Color(0xFFAA1824).withValues(alpha: 0.85),
        offset: const Offset(0, 0),
        scale: 1,
      ),
      _AccentLayer(
        color: const Color(0xFFC62828).withValues(alpha: 0.8),
        offset: const Offset(18, 18),
        scale: 0.88,
      ),
      _AccentLayer(
        color: const Color(0xFFE53935).withValues(alpha: 0.75),
        offset: const Offset(34, 34),
        scale: 0.76,
      ),
    ];

    for (final layer in paintLayers) {
      final path = Path()
        ..moveTo(
          layer.offset.dx,
          size.height * 0.35 * layer.scale + layer.offset.dy,
        )
        ..lineTo(
          size.width * 0.6 * layer.scale + layer.offset.dx,
          size.height * layer.scale + layer.offset.dy,
        )
        ..lineTo(
          size.width * layer.scale + layer.offset.dx,
          size.height * layer.scale + layer.offset.dy,
        )
        ..lineTo(
          size.width * 0.42 * layer.scale + layer.offset.dx,
          size.height * 0.35 * layer.scale + layer.offset.dy,
        )
        ..close();

      final paint = Paint()
        ..color = layer.color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CornerAccentPainter oldDelegate) {
    return oldDelegate.alignment != alignment;
  }
}

class _AccentLayer {
  const _AccentLayer({
    required this.color,
    required this.offset,
    required this.scale,
  });

  final Color color;
  final Offset offset;
  final double scale;
}
