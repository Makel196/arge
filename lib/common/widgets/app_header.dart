import "dart:math" as math;

import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";

import "package:pgr_arge_sistemleri/common/constants/app_constants.dart";
import "package:pgr_arge_sistemleri/common/theme/neomorphism.dart";
import "package:pgr_arge_sistemleri/common/utils/responsive.dart";
import "package:pgr_arge_sistemleri/common/utils/sound_effects.dart";
import "package:pgr_arge_sistemleri/common/widgets/brand_logo.dart";

/// Responsive application header with consistent layout across all pages.
///
/// Uses a three-column flex layout:
/// - Left: Back button (fixed width)
/// - Center: Title (flexible, expandable)
/// - Right: Logo (fixed width, maintains aspect ratio)
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

  // Responsive size constants
  static const double _minButtonSize = 32.0;
  static const double _maxButtonSize = 56.0;
  static const double _minLogoHeight = 56.0;  // Artırıldı: 40 -> 56
  static const double _maxLogoHeight = 120.0; // Artırıldı: 80 -> 120
  static const double _logoAspectRatio = 2.8; // Artırıldı: 2.5 -> 2.8 (daha geniş)

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
    final Size screenSize = MediaQuery.sizeOf(context);
    final ResponsiveScale metrics = ResponsiveScale.of(context);
    final Color accent = accentColor ?? CupertinoColors.activeBlue;

    // Responsive breakpoints
    final bool isCompact = screenSize.width < Responsive.tablet;
    final bool isDesktop = screenSize.width >= Responsive.desktop;

    // Calculate responsive sizes
    final _HeaderSizes sizes = _calculateSizes(
      screenSize: screenSize,
      metrics: metrics,
      isCompact: isCompact,
      isDesktop: isDesktop,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.horizontalPadding,
        vertical: sizes.verticalPadding,
      ),
      child: SizedBox(
        height: sizes.headerHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left section: Back button (fixed width)
            _buildBackButton(
              context: context,
              showBack: showBack,
              buttonSize: sizes.buttonSize,
              accent: accent,
              metrics: metrics,
            ),

            // Center section: Title (flexible, expandable)
            Expanded(
              child: _buildTitle(
                title: title,
                titleFontSize: sizes.titleFontSize,
                metrics: metrics,
              ),
            ),

            // Right section: Trailing + Logo (fixed width)
            _buildLogoSection(
              context: context,
              trailing: trailing,
              logoHeight: sizes.logoHeight,
              logoWidth: sizes.logoWidth,
              metrics: metrics,
            ),
          ],
        ),
      ),
    );
  }

  /// Build back button section
  Widget _buildBackButton({
    required BuildContext context,
    required bool showBack,
    required double buttonSize,
    required Color accent,
    required ResponsiveScale metrics,
  }) {
    return SizedBox(
      width: buttonSize + 8, // Extra space for visual balance
      child: showBack
          ? Align(
              alignment: Alignment.centerLeft,
              child: _CircularBackButton(
                size: buttonSize,
                accent: accent,
                metrics: metrics,
                onPressed: () => _handleBack(context),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  /// Build title section
  Widget _buildTitle({
    required String? title,
    required double titleFontSize,
    required ResponsiveScale metrics,
  }) {
    final String headerText = title?.trim() ?? '';
    final bool hasTitle = headerText.isNotEmpty;

    if (!hasTitle) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          headerText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: CupertinoColors.label,
          ),
        ),
      ),
    );
  }

  /// Build logo section (logo + optional trailing widget)
  Widget _buildLogoSection({
    required BuildContext context,
    required Widget? trailing,
    required double logoHeight,
    required double logoWidth,
    required ResponsiveScale metrics,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Trailing widget
        if (trailing != null) ...[
          trailing,
          SizedBox(width: metrics.gap(0.5)),
        ],

        // Logo - Fixed position, maintains aspect ratio
        GestureDetector(
          onTap: () => _handleLogoTap(context),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              height: logoHeight,
              width: logoWidth,
              child: BrandLogo(height: logoHeight),
            ),
          ),
        ),
      ],
    );
  }

  /// Calculate all responsive sizes
  _HeaderSizes _calculateSizes({
    required Size screenSize,
    required ResponsiveScale metrics,
    required bool isCompact,
    required bool isDesktop,
  }) {
    // Base scale calculation
    final double widthScale = (screenSize.width / AppConstants.desktopBreakpoint)
        .clamp(0.75, 1.3);
    final double heightScale = (screenSize.height / AppConstants.minWindowHeight)
        .clamp(0.75, 1.2);
    final double baseScale = math.min(
      1.3,
      math.max(0.75, (metrics.scale + widthScale + heightScale) / 3),
    );

    // Button size
    final double buttonSize = (44.0 * baseScale)
        .clamp(_minButtonSize, _maxButtonSize);

    // Logo size (maintains aspect ratio) - Base artırıldı: 60 -> 90
    final double logoHeight = (90.0 * baseScale)
        .clamp(_minLogoHeight, _maxLogoHeight);
    final double logoWidth = logoHeight * _logoAspectRatio;

    // Paddings
    final double horizontalPadding = isCompact
        ? metrics.gap(0.75)
        : metrics.gap(1.0);
    final double verticalPadding = isCompact
        ? metrics.gap(0.5)
        : metrics.gap(0.75);

    // Title font size
    final double titleFontSize = isCompact
        ? metrics.rem(1.25)
        : metrics.rem(1.5);

    // Header height matches logo height
    final double headerHeight = logoHeight;

    return _HeaderSizes(
      buttonSize: buttonSize,
      logoHeight: logoHeight,
      logoWidth: logoWidth,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      titleFontSize: titleFontSize,
      headerHeight: headerHeight,
    );
  }
}

/// Data class to hold calculated header sizes
class _HeaderSizes {
  const _HeaderSizes({
    required this.buttonSize,
    required this.logoHeight,
    required this.logoWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.titleFontSize,
    required this.headerHeight,
  });

  final double buttonSize;
  final double logoHeight;
  final double logoWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final double titleFontSize;
  final double headerHeight;
}

/// Circular back button with neomorphic design
class _CircularBackButton extends StatefulWidget {
  const _CircularBackButton({
    required this.size,
    required this.accent,
    required this.metrics,
    required this.onPressed,
  });

  final double size;
  final Color accent;
  final ResponsiveScale metrics;
  final VoidCallback onPressed;

  @override
  State<_CircularBackButton> createState() => _CircularBackButtonState();
}

class _CircularBackButtonState extends State<_CircularBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Neomorphic palette for the button
    final NeomorphismPalette palette = NeomorphismPalette.control(
      accent: widget.accent,
      isPressed: _isPressed,
      isEnabled: true,
    );

    // Icon size proportional to button size
    final double iconSize = widget.size * 0.5;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTap: () {
        SoundEffects.playTap();
        widget.onPressed();
      },
      child: AnimatedScale(
        duration: NeomorphismTokens.quickAnimation,
        curve: NeomorphismTokens.smoothCurve,
        scale: _isPressed ? 0.92 : 1.0,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Perfect circle
            gradient: palette.background,
            boxShadow: palette.shadows,
            border: palette.borderColor != null && palette.borderWidth > 0
                ? Border.all(
                    color: palette.borderColor!,
                    width: palette.borderWidth,
                  )
                : null,
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.arrowshape_turn_up_left_fill,
              size: iconSize,
              color: widget.accent,
            ),
          ),
        ),
      ),
    );
  }
}
