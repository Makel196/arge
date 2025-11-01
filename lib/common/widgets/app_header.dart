// ============ APP_HEADER.DART ============
import "dart:math" as math;

import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";

import "package:pgr_arge_sistemleri/common/constants/app_constants.dart";
import "package:pgr_arge_sistemleri/common/theme/neomorphism.dart";
import "package:pgr_arge_sistemleri/common/utils/responsive.dart";
import "package:pgr_arge_sistemleri/common/utils/sound_effects.dart";
import "package:pgr_arge_sistemleri/common/widgets/brand_logo.dart";

/// Shared application header widget with responsive sizing.
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
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveScale metrics = ResponsiveScale.of(context);
    final Size size = MediaQuery.sizeOf(context);
    final Color accent = accentColor ?? CupertinoColors.activeBlue;
    final String headerText = title?.trim() ?? '';
    final bool hasExplicitTitle = headerText.isNotEmpty;
    final bool isCompact = size.width < Responsive.tablet;
    final double widthScale = (size.width / AppConstants.desktopBreakpoint)
        .clamp(0.75, 1.4);
    final double heightScale = (size.height / AppConstants.minWindowHeight)
        .clamp(0.75, 1.2);
    final double blendedScale = math.min(
      1.45,
      math.max(0.72, (metrics.scale + widthScale + heightScale) / 3),
    );
    final double controlSize = (46 * blendedScale)
        .clamp(isCompact ? 26 : 32, 72)
        .toDouble();
    final double logoHeight = (68 * blendedScale)
        .clamp(isCompact ? 36 : 42, 110)
        .toDouble();
    final double horizontalPadding = metrics.gap(isCompact ? 0.75 : 1.0);
    final double rightPadding = metrics.gap(isCompact ? 0.9 : 1.0);
    final double verticalPadding = metrics.gap(isCompact ? 0.45 : 0.6);

    final double availableCenterWidth =
        size.width - (horizontalPadding + rightPadding) * 2 - (controlSize * 2);
    final double titleMaxWidth = availableCenterWidth.clamp(
      0,
      size.width * (isCompact ? 0.68 : 0.52),
    );

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: horizontalPadding * (isCompact ? 1.05 : 1.0),
        end: rightPadding,
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      child: SizedBox(
        height: logoHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sol taraf - Back button
            SizedBox(
              width: controlSize,
              child: showBack
                  ? _HeaderButton(
                      icon: CupertinoIcons.arrowshape_turn_up_left_fill,
                      metrics: metrics,
                      accent: accent,
                      onPressed: () => _handleBack(context),
                      isCircular: true, // Tamamen yuvarlak
                    )
                  : const SizedBox.shrink(),
            ),

            // Orta - Title (esneyebilir, merkeze alınmış)
            Expanded(
              child: hasExplicitTitle
                  ? Center(
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
                          constraints: BoxConstraints(maxWidth: titleMaxWidth),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              headerText,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Sağ taraf - Trailing ve Logo (sabit boyutlu, sağa yaslanmış)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.35,
                minWidth: logoHeight * 0.8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Trailing widget varsa
                  if (trailing != null) ...[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: metrics.gap(0.35)),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: trailing!,
                        ),
                      ),
                    ),
                  ],

                  // Logo - Sağa yaslanmış, esnek
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _handleLogoTap(context),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: logoHeight,
                            minHeight: logoHeight * 0.6,
                            maxWidth: logoHeight * 2.5,
                            minWidth: logoHeight * 0.8,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                              child: BrandLogo(height: logoHeight),
                            ),
                          ),
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
    this.isCircular = false,
  });

  final IconData icon;
  final ResponsiveScale metrics;
  final Color accent;
  final VoidCallback onPressed;
  final bool isCircular;

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
    final double side = widget.metrics
        .icon(3.0)
        .clamp(widget.metrics.icon(2.4), widget.metrics.icon(3.6))
        .toDouble();

    // Tamamen yuvarlak veya normal border radius
    final BorderRadius radius = widget.isCircular
        ? BorderRadius.circular(side / 2)
        : widget.metrics.br;

    return GestureDetector(
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
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.metrics.icon(1.3),
              color: widget.accent,
            ),
          ),
        ),
      ),
    );
  }
}

// ============ HOME_SCREEN.DART DÜZELTMELERİ ============
// _HomeContent build metodundaki cardHeight hesaplaması şu şekilde değiştirilmeli:

/*
ESKI KOD (HATALI):
final double cardHeight = scaledHeight.clamp(
  300,
  size.height * (showSideControls ? 0.68 : 0.75),
);

YENİ KOD (DÜZELTİLMİŞ):
*/
// final double minCardHeight = 240.0;
// final double maxCardHeight = size.height * (showSideControls ? 0.68 : 0.75);
// final double cardHeight = scaledHeight.clamp(
//   minCardHeight,
//   math.max(minCardHeight, maxCardHeight),
// );
