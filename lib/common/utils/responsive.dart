import "dart:math" as math;

import "package:flutter/widgets.dart";

import "package:pgr_arge_sistemleri/common/constants/app_constants.dart";

class Responsive {
  Responsive._();

  static const double tablet = AppConstants.tabletBreakpoint;
  static const double desktop = AppConstants.desktopBreakpoint;
  static const double wide = AppConstants.wideBreakpoint;
}

/// Helper for responsive sizing using rem-based units.
class ResponsiveScale {
  ResponsiveScale._(this._size);

  factory ResponsiveScale.of(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return ResponsiveScale._(size);
  }

  final Size _size;

  double get _referenceSide => math.min(_size.width, _size.height);

  double get scale => (_referenceSide / 390).clamp(0.85, 1.35);

  double rem(num units) => 16 * scale * units.toDouble();

  double gap(num units) => rem(units);

  double icon(num units) => rem(units);

  double get radiusCupertino => (12 * scale).clamp(48, 48);

  BorderRadius get br => BorderRadius.circular(radiusCupertino);

  bool get isSmall => _size.width < 600;

  bool get isMedium => _size.width >= 600 && _size.width < 1024;

  bool get isLarge => _size.width >= 1024;
}
