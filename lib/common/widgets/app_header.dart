import "dart:math" as math;

import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";

import "package:pgr_arge_sistemleri/common/constants/app_constants.dart";
import "package:pgr_arge_sistemleri/common/theme/neomorphism.dart";
import "package:pgr_arge_sistemleri/common/utils/responsive.dart";
import "package:pgr_arge_sistemleri/common/utils/sound_effects.dart";
import "package:pgr_arge_sistemleri/common/widgets/brand_logo.dart";

/// Shared application header with consistent responsive sizing.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
    this.onLogoTap,
    this.trailing,
    this.accentColor,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onLogoTap;
  final Widget? trailing;
  final Color? accentColor;

  void _handleBack(BuildContext context) {
    HapticFeedback.selectionClick();
    SoundEffects.playTap();
    final GoRouter router = GoRouter.of(context);
    if (onBack != null) {
      onBack!.call();
      return;
    }
    if (router.canPop()) {
      router.pop();
    }
  }

  void _handleLogoTap(BuildContext context) {
    SoundEffects.playTap();
    if (onLogoTap != null) {
      onLogoTap!.call();
    } else {
      GoRouter.of(context).go("/");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveScale metrics = ResponsiveScale.of(context);
    final Size size = MediaQuery.sizeOf(context);
    final Color accent = accentColor ?? CupertinoColors.activeBlue;
    final String headerText = title?.trim() ?? "";
    final bool hasExplicitTitle = headerText.isNotEmpty;
    final _HeaderLayout layout = _resolveHeaderLayout(metrics, size);

    final double trailingSlotWidth =
        math.max(layout.logoHeight * BrandLogo.aspectRatio, layout.controlSize) +
        (trailing != null ? layout.controlSize + layout.trailingSpacing : 0);

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: layout.horizontalPadding,
        end: layout.rightPadding,
        top: layout.verticalPadding,
        bottom: layout.verticalPadding,
      ),
      child: SizedBox(
        height: layout.logoHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: layout.controlSize,
              child: Align(
                alignment: Alignment.centerLeft,
                child: showBack
                    ? _HeaderButton(
                        icon: CupertinoIcons.arrowshape_turn_up_left_fill,
                        metrics: metrics,
                        accent: accent,
                        size: layout.controlSize,
                        onPressed: () => _handleBack(context),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            Expanded(
              flex: 2,
              child: hasExplicitTitle
                  ? _HeaderTitle(
                      text: headerText,
                      metrics: metrics,
                      maxWidth: layout.titleMaxWidth,
                      isCompact: layout.isCompact,
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              width: trailingSlotWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (trailing != null)
                    Padding(
                      padding: EdgeInsets.only(right: layout.trailingSpacing),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () => _handleLogoTap(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        height: layout.logoHeight,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: BrandLogo(height: layout.logoHeight),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatefulWidget {
  const _HeaderButton({
    required this.icon,
    required this.metrics,
    required this.accent,
    required this.onPressed,
    required this.size,
  });

  final IconData icon;
  final ResponsiveScale metrics;
  final Color accent;
  final VoidCallback onPressed;
  final double size;

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final NeomorphismPalette palette = NeomorphismPalette.control(
      accent: widget.accent,
      isPressed: _pressed,
      isEnabled: true,
    );
    final double side = widget.size;
    final BorderRadius radius = BorderRadius.circular(side);
    final double iconSize = math.max(
      18,
      math.min(side * 0.45, widget.metrics.icon(1.4)),
    );

    return Center(
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: () {
          SoundEffects.playTap();
          widget.onPressed();
        },
        child: AnimatedScale(
          duration: NeomorphismTokens.quickAnimation,
          curve: NeomorphismTokens.smoothCurve,
          scale: _pressed ? 0.94 : 1.0,
          child: AnimatedContainer(
            duration: NeomorphismTokens.quickAnimation,
            curve: NeomorphismTokens.smoothCurve,
            width: side,
            height: side,
            decoration: palette.decoration(radius),
            clipBehavior: Clip.antiAlias,
            child: Center(
              child: Icon(widget.icon, size: iconSize, color: widget.accent),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.text,
    required this.metrics,
    required this.maxWidth,
    required this.isCompact,
  });

  final String text;
  final ResponsiveScale metrics;
  final double maxWidth;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        style: TextStyle(
          fontSize: metrics.rem(isCompact ? 1.25 : 1.5),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.45,
          color: CupertinoColors.label,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(text, maxLines: 1, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _HeaderLayout {
  const _HeaderLayout({
    required this.logoHeight,
    required this.controlSize,
    required this.horizontalPadding,
    required this.rightPadding,
    required this.verticalPadding,
    required this.titleMaxWidth,
    required this.trailingSpacing,
    required this.isCompact,
  });

  final double logoHeight;
  final double controlSize;
  final double horizontalPadding;
  final double rightPadding;
  final double verticalPadding;
  final double titleMaxWidth;
  final double trailingSpacing;
  final bool isCompact;
}

_HeaderLayout _resolveHeaderLayout(ResponsiveScale metrics, Size size) {
  final bool isCompact = size.width < Responsive.tablet;
  final double logoHeight = _resolveLogoHeight(metrics, size, isCompact);

  final double horizontalPadding = metrics
      .gap(isCompact ? 0.75 : 1.0)
      .clamp(16, 32);
  final double rightPadding = metrics.gap(isCompact ? 0.9 : 1.0).clamp(18, 36);
  final double verticalPadding = metrics
      .gap(isCompact ? 0.45 : 0.6)
      .clamp(12, 28);
  final double controlSize = math.max(
    36,
    math.min(logoHeight * (isCompact ? 0.66 : 0.7), 78),
  );

  final double availableCenterWidth =
      size.width - (horizontalPadding + rightPadding) * 2 - (controlSize * 2);
  final double titleMaxWidth = availableCenterWidth.clamp(
    0,
    size.width * (isCompact ? 0.68 : 0.52),
  );

  final double trailingSpacing = metrics.gap(isCompact ? 0.3 : 0.45);

  return _HeaderLayout(
    logoHeight: logoHeight,
    controlSize: controlSize,
    horizontalPadding: horizontalPadding,
    rightPadding: rightPadding,
    verticalPadding: verticalPadding,
    titleMaxWidth: titleMaxWidth,
    trailingSpacing: trailingSpacing,
    isCompact: isCompact,
  );
}

double _resolveLogoHeight(ResponsiveScale metrics, Size size, bool isCompact) {
  final double widthProgress = _normalized(
    size.width,
    AppConstants.tabletBreakpoint * 0.9,
    AppConstants.wideBreakpoint * 1.1,
  );
  final double heightProgress = _normalized(
    size.height,
    AppConstants.minWindowHeight * 0.85,
    AppConstants.defaultWindowHeight * 1.35,
  );
  final double metricBase = metrics.rem(isCompact ? 2.4 : 3.1);

  final double widthBased = _lerp(54, 104, widthProgress);
  final double heightBased = _lerp(52, 94, heightProgress);
  final double average = (widthBased + heightBased + metricBase) / 3;

  return average.clamp(34, 104);
}

double _normalized(double value, double min, double max) {
  if (max <= min) {
    return 0;
  }
  final double t = (value - min) / (max - min);
  return t.clamp(0.0, 1.0);
}

double _lerp(double min, double max, double t) {
  return min + (max - min) * t;
}
