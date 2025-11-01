import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height});

  final double? height;
  static const double _aspectRatio = 180 / 83;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double resolvedHeight = _resolveHeight(constraints);
        final double idealWidth = resolvedHeight * _aspectRatio;
        final double resolvedWidth = _resolveWidth(constraints, idealWidth);

        return SizedBox(
          height: resolvedHeight,
          width: resolvedWidth,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SvgPicture.asset(
              'assets/decor/pgr_logo.svg',
              height: resolvedHeight,
              fit: BoxFit.contain,
              semanticsLabel: 'PGR Drive Technologies',
            ),
          ),
        );
      },
    );
  }

  double _resolveHeight(BoxConstraints constraints) {
    final double fallback = height ?? 64;
    final double? maxHeight =
        (constraints.hasBoundedHeight &&
            constraints.maxHeight.isFinite &&
            constraints.maxHeight > 0)
        ? constraints.maxHeight
        : null;
    final double candidate = height ?? maxHeight ?? fallback;
    return candidate.clamp(32, 132);
  }

  double _resolveWidth(BoxConstraints constraints, double idealWidth) {
    if (constraints.hasBoundedWidth &&
        constraints.maxWidth.isFinite &&
        constraints.maxWidth > 0) {
      return math.min(idealWidth, constraints.maxWidth);
    }
    return idealWidth;
  }
}
