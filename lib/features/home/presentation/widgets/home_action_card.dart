import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "package:pgr_arge_sistemleri/common/constants/app_constants.dart";
import "package:pgr_arge_sistemleri/common/theme/neomorphism.dart";
import "package:pgr_arge_sistemleri/common/utils/responsive.dart";

/// Ana sayfa kartlari icin ortak neomorfik yuzey.
/// Bu widget farkli sayfalarda da kullanilabilen standart tasarimi sunar.
class HomeActionCard extends StatefulWidget {
  const HomeActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.onDetailsPressed,
    this.isHighlighted = false,
    this.width,
    this.height,
    this.aspectRatio = 0.85,
  });

  /// Kart ikonunda kullanilacak ana simbol.
  final IconData icon;

  /// Kart basligi (tek satir olarak gosterilir).
  final String title;

  /// Kart aciklamasi.
  final String subtitle;

  /// Kartin ana vurgu rengi (metin ve ikonlar icin).
  final Color primaryColor;

  /// Kart arka plan renk karisimi icin kullanilan ikinci vurgu rengi.
  final Color secondaryColor;

  /// Kart icinde parlayan alanlar icin kullanilan aksan rengi.
  final Color accentColor;

  /// "Detaylara Git" tusuna basildiginda calisan islem.
  final VoidCallback? onDetailsPressed;

  /// Kart aktif durumda mi? Aktif kartlar daha belirgin gozukur.
  final bool isHighlighted;

  /// Kart genisligi (null ise parent'a gore ayarlanir).
  final double? width;

  /// Kart yuksekligi (null ise aspectRatio'ya gore ayarlanir).
  final double? height;

  /// Kart yukseklik/genislik orani (varsayilan 0.85).
  final double aspectRatio;

  @override
  State<HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<HomeActionCard> {
  bool _isCardPressed = false;

  void _setPressed(bool value) {
    if (_isCardPressed == value) return;
    setState(() => _isCardPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final bool isEnabled = widget.onDetailsPressed != null;
    final ResponsiveScale metrics = ResponsiveScale.of(context);

    // Kart yuzeyi icin hazirlanan palet (renk, golge, degrade vb.).
    final NeomorphismPalette palette = NeomorphismPalette.card(
      primaryAccent: widget.primaryColor,
      secondaryAccent: widget.secondaryColor,
      glowAccent: widget.accentColor,
      isHighlighted: widget.isHighlighted,
      isEnabled: isEnabled,
    );

    final Color pressedOverlay = Color.lerp(
      widget.primaryColor,
      Colors.black,
      0.18,
    )!.withValues(alpha: 0.18);
    final double targetScale = widget.isHighlighted
        ? (_isCardPressed ? 0.97 : 1.0)
        : (_isCardPressed ? 0.95 : 0.98);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : screenSize.width;
        final bool isMobile = screenSize.width < AppConstants.tabletBreakpoint;
        final double widthFactor = isMobile ? 0.9 : (isLandscape ? 0.42 : 0.48);
        final double minWidth = isMobile ? 260.0 : 300.0;
        final double maxWidth = isMobile
            ? 360.0
            : (isLandscape ? 440.0 : 380.0);
        final double defaultWidth = (availableWidth * widthFactor).clamp(
          minWidth,
          maxWidth,
        );

        final double resolvedWidth =
            widget.width ??
            (widget.height != null
                ? widget.height! / widget.aspectRatio
                : defaultWidth);
        final double resolvedHeight =
            widget.height ?? (resolvedWidth * widget.aspectRatio);
        final BorderRadius cardRadius = metrics.br;
        final double contentPadding = metrics
            .gap(isLandscape ? 1.0 : 1.25)
            .clamp(metrics.gap(0.75), metrics.gap(1.5))
            .toDouble();
        final Widget card = _buildCard(
          context: context,
          metrics: metrics,
          borderRadius: cardRadius,
          contentPadding: contentPadding,
          isLandscape: isLandscape,
          isEnabled: isEnabled,
          palette: palette,
          pressedOverlay: pressedOverlay,
          targetScale: targetScale,
        );

        return SizedBox(
          width: resolvedWidth,
          height: resolvedHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            child: card,
          ),
        );
      },
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required ResponsiveScale metrics,
    required BorderRadius borderRadius,
    required double contentPadding,
    required bool isLandscape,
    required bool isEnabled,
    required NeomorphismPalette palette,
    required Color pressedOverlay,
    required double targetScale,
  }) {
    final TextStyle titleStyle = AppTextStyles.titleLarge(context).copyWith(
      fontSize: metrics.rem(isLandscape ? 1.25 : 1.375),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: palette.titleColor,
    );
    final TextStyle bodyStyle = AppTextStyles.body(context).copyWith(
      fontSize: metrics.rem(isLandscape ? 0.8 : 0.875),
      color: palette.bodyColor,
      height: 1.45,
    );
    final double headerGap = metrics.gap(isLandscape ? 0.5 : 0.75);
    final double footerGap = metrics.gap(isLandscape ? 0.75 : 1.0);
    final int paragraphLines = isLandscape ? 2 : 3;

    return AnimatedScale(
      duration: NeomorphismTokens.relaxedAnimation,
      curve: NeomorphismTokens.smoothCurve,
      scale: targetScale,
      child: AnimatedContainer(
        duration: NeomorphismTokens.relaxedAnimation,
        curve: NeomorphismTokens.smoothCurve,
        clipBehavior: Clip.antiAlias,
        decoration: palette.decoration(borderRadius),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: NeomorphismTokens.quickAnimation,
                  curve: NeomorphismTokens.smoothCurve,
                  opacity: _isCardPressed ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: pressedOverlay),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _CardIconBadge(
                            icon: widget.icon,
                            palette: palette.badge,
                            metrics: metrics,
                          ),
                          SizedBox(height: headerGap),
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                          SizedBox(height: headerGap),
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.subtitle,
                              maxLines: paragraphLines,
                              overflow: TextOverflow.ellipsis,
                              style: bodyStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: footerGap),
                    Align(
                      alignment: Alignment.center,
                      child: _NeomorphicActionChip(
                        text: isEnabled ? "Detaylara Git" : "Yakinda",
                        accentColor: widget.primaryColor,
                        isEnabled: isEnabled,
                        metrics: metrics,
                        onPressed: widget.onDetailsPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardIconBadge extends StatelessWidget {
  const _CardIconBadge({
    required this.icon,
    this.palette,
    required this.metrics,
  });

  final IconData icon;
  final NeomorphismBadgePalette? palette;
  final ResponsiveScale metrics;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWideLayout = screenSize.width > 600;
    final double badgeSide = metrics.icon(isWideLayout ? 3.25 : 3.0);
    final double iconSize = metrics.icon(isWideLayout ? 1.5 : 1.35);

    final NeomorphismBadgePalette? badgePalette = palette;
    final BoxBorder? border =
        (badgePalette != null &&
            badgePalette.borderColor != null &&
            badgePalette.borderWidth > 0)
        ? Border.all(
            color: badgePalette.borderColor!,
            width: badgePalette.borderWidth,
          )
        : null;

    final BoxDecoration outerDecoration = BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: badgePalette?.shadows,
      border: border,
    );

    return Container(
      height: badgeSide,
      width: badgeSide,
      decoration: outerDecoration,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: badgePalette?.background,
        ),
        child: Center(
          child: FaIcon(icon, size: iconSize, color: badgePalette?.iconColor),
        ),
      ),
    );
  }
}

/// Kart altinda yer alan metin + ok kombinasyonunu neomorfik chip olarak sunar.
class _NeomorphicActionChip extends StatefulWidget {
  const _NeomorphicActionChip({
    required this.text,
    required this.accentColor,
    required this.isEnabled,
    required this.metrics,
    this.onPressed,
  });

  final String text;
  final Color accentColor;
  final bool isEnabled;
  final ResponsiveScale metrics;
  final VoidCallback? onPressed;

  @override
  State<_NeomorphicActionChip> createState() => _NeomorphicActionChipState();
}

class _NeomorphicActionChipState extends State<_NeomorphicActionChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final NeomorphismPalette controlPalette = NeomorphismPalette.control(
      accent: widget.accentColor,
      isPressed: _isPressed,
      isEnabled: widget.isEnabled,
    );

    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double textScale = textScaler.scale(1.0).clamp(1.0, 1.2).toDouble();
    final double widthFactor = widget.metrics.scale.clamp(0.9, 1.3).toDouble();
    final BorderRadius chipRadius = widget.metrics.br;
    final double baseFont = 16 * widthFactor;
    final TextStyle labelStyle = AppTextStyles.button(context).copyWith(
      color: controlPalette.titleColor,
      fontSize: (baseFont * textScale).clamp(13, 18).toDouble(),
      letterSpacing: 0.2,
    );

    final double horizontalPadding = widget.metrics
        .gap(1.0)
        .clamp(widget.metrics.gap(0.75), widget.metrics.gap(1.5))
        .toDouble();
    final double verticalPadding = widget.metrics
        .gap(0.75)
        .clamp(widget.metrics.gap(0.5), widget.metrics.gap(1.0))
        .toDouble();
    final double labelGap = widget.metrics.gap(0.75);

    return GestureDetector(
      onTapDown: widget.isEnabled
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapCancel: widget.isEnabled
          ? () => setState(() => _isPressed = false)
          : null,
      onTapUp: widget.isEnabled
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTap: widget.isEnabled
          ? () {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        duration: NeomorphismTokens.quickAnimation,
        curve: NeomorphismTokens.smoothCurve,
        scale: _isPressed ? 0.96 : 1.0,
        child: AnimatedContainer(
          duration: NeomorphismTokens.regularAnimation,
          curve: NeomorphismTokens.smoothCurve,
          decoration: controlPalette.decoration(chipRadius),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle,
                ),
              ),
              SizedBox(width: labelGap),
              _NeomorphicCircleIcon(
                accentColor: widget.accentColor,
                glowPalette: controlPalette,
                isEnabled: widget.isEnabled,
                isPressed: _isPressed,
                metrics: widget.metrics,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip icindeki dairesel ok butonunu cizer.
class _NeomorphicCircleIcon extends StatelessWidget {
  const _NeomorphicCircleIcon({
    required this.accentColor,
    required this.glowPalette,
    required this.isEnabled,
    required this.isPressed,
    required this.metrics,
  });

  final Color accentColor;
  final NeomorphismPalette glowPalette;
  final bool isEnabled;
  final bool isPressed;
  final ResponsiveScale metrics;

  @override
  Widget build(BuildContext context) {
    final double sideBase = metrics.icon(1.75);
    final double side = sideBase
        .clamp(metrics.icon(1.0), metrics.icon(2.0))
        .toDouble();
    final double iconBase = metrics.icon(1.0);
    final double iconSize = iconBase
        .clamp(metrics.icon(0.75), metrics.icon(1.2))
        .toDouble();
    return AnimatedScale(
      duration: NeomorphismTokens.quickAnimation,
      curve: NeomorphismTokens.smoothCurve,
      scale: isPressed ? 0.9 : 1.0,
      child: Container(
        height: side,
        width: side,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: glowPalette.background,
          boxShadow: glowPalette.shadows,
          border: glowPalette.borderColor != null && glowPalette.borderWidth > 0
              ? Border.all(
                  color: glowPalette.borderColor!,
                  width: glowPalette.borderWidth,
                )
              : null,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: glowPalette.glow,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.arrowRightLong,
              size: iconSize,
              color: isEnabled
                  ? accentColor.withValues(alpha: 0.92)
                  : accentColor.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}
