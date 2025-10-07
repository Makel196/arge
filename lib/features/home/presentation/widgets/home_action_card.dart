import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "package:pgr_arge_sistemleri/common/theme/app_theme.dart";
import "package:pgr_arge_sistemleri/common/theme/neomorphism.dart";

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
    final double visualScale =
        (screenSize.shortestSide / 720).clamp(0.9, 1.1).toDouble();

    // Kart yuzeyi icin hazirlanan palet (renk, golge, degrade vb.).
    final NeomorphismPalette palette = NeomorphismPalette.card(
      primaryAccent: widget.primaryColor,
      secondaryAccent: widget.secondaryColor,
      glowAccent: widget.accentColor,
      isHighlighted: widget.isHighlighted,
      isEnabled: isEnabled,
    );

    // Standart baslik ve govde stillerini tek noktadan yonetelim.
    final TextStyle titleStyle = AppTextStyles.titleLarge(context).copyWith(
      fontSize: (20 * visualScale).clamp(20, 28).toDouble(),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: palette.titleColor,
    );

    final TextStyle bodyStyle = AppTextStyles.body(context).copyWith(
      fontSize: (13 * visualScale).clamp(12, 16).toDouble(),
      color: palette.bodyColor,
      height: 1.45,
    );

    final Color pressedOverlay = Color.lerp(
      widget.primaryColor,
      Colors.black,
      0.18,
    )!
        .withValues(alpha: 0.18);
    final double targetScale = widget.isHighlighted
        ? (_isCardPressed ? 0.97 : 1.0)
        : (_isCardPressed ? 0.95 : 0.98);

    Widget card = AnimatedScale(
      duration: NeomorphismTokens.relaxedAnimation,
      curve: NeomorphismTokens.smoothCurve,
      scale: targetScale,
      child: AnimatedContainer(
        duration: NeomorphismTokens.relaxedAnimation,
        curve: NeomorphismTokens.smoothCurve,
        clipBehavior: Clip.antiAlias,
        decoration: palette.decoration(AppRadius.r48),
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
                padding: EdgeInsets.all(
                  isLandscape ? AppSpacing.s16 : AppSpacing.s20,
                ),
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
                          ),
                          SizedBox(
                            height: isLandscape
                                ? AppSpacing.s8
                                : AppSpacing.s12,
                          ),
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: isLandscape
                                ? AppSpacing.s8
                                : AppSpacing.s12,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.subtitle,
                              maxLines: isLandscape ? 2 : 3,
                              overflow: TextOverflow.ellipsis,
                              style: bodyStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: isLandscape ? AppSpacing.s12 : AppSpacing.s16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: _NeomorphicActionChip(
                        text: isEnabled ? "Detaylara Git" : "Yakinda",
                        accentColor: widget.primaryColor,
                        isEnabled: isEnabled,
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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : screenSize.width;
        final double defaultWidth =
            (availableWidth * (isLandscape ? 0.42 : 0.86)).clamp(
          260.0,
          isLandscape ? 420.0 : 360.0,
        );

        final double resolvedWidth = widget.width ??
            (widget.height != null
                ? widget.height! / widget.aspectRatio
                : defaultWidth);
        final double resolvedHeight =
            widget.height ?? (resolvedWidth * widget.aspectRatio);

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
}

class _CardIconBadge extends StatelessWidget {
  const _CardIconBadge({required this.icon, this.palette});

  final IconData icon;
  final NeomorphismBadgePalette? palette;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWideLayout = screenSize.width > 600;
    final double badgeScale =
        (screenSize.shortestSide / 720).clamp(0.9, 1.1).toDouble();
    final double badgeSide =
        ((isWideLayout ? 56 : 52) * badgeScale).clamp(48, 64).toDouble();
    final double iconSize = (badgeSide * 0.48).clamp(20, 28).toDouble();

    final NeomorphismBadgePalette? badgePalette = palette;
    final BoxBorder? border = (badgePalette != null &&
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
          child: FaIcon(
            icon,
            size: iconSize,
            color: badgePalette?.iconColor,
          ),
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
    this.onPressed,
  });

  final String text;
  final Color accentColor;
  final bool isEnabled;
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
    final double textScale =
        textScaler.scale(1.0).clamp(1.0, 1.2).toDouble();
    final TextStyle labelStyle = AppTextStyles.button(context).copyWith(
      color: controlPalette.titleColor,
      fontSize: (14 * textScale).clamp(12, 16).toDouble(),
      letterSpacing: 0.2,
    );

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
          decoration: controlPalette.decoration(AppRadius.r48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
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
              const SizedBox(width: AppSpacing.s12),
              _NeomorphicCircleIcon(
                accentColor: widget.accentColor,
                glowPalette: controlPalette,
                isEnabled: widget.isEnabled,
                isPressed: _isPressed,
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
  });

  final Color accentColor;
  final NeomorphismPalette glowPalette;
  final bool isEnabled;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    final double side = AppSpacing.s24 + AppSpacing.s4;
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
              size: 16,
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
