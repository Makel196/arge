import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/theme/app_theme.dart';
import 'package:pgr_arge_sistemleri/common/theme/neomorphism.dart';
import 'package:pgr_arge_sistemleri/common/utils/responsive.dart';
import 'package:pgr_arge_sistemleri/common/widgets/app_header.dart';
import 'package:pgr_arge_sistemleri/features/home/presentation/home_screen.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  static const String routeName = 'calculations';
  static const String routePath = '/calculations';
  static Widget routeBuilder(BuildContext context, _) =>
      const CalculationsPage();

  @override
  Widget build(BuildContext context) {
    final ResponsiveScale metrics = ResponsiveScale.of(context);
    final FeaturePalette palette = AppTheme.featurePalette(
      AppFeature.calculations,
    );
    final LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.white,
        AppTheme.soften(palette.accent, 0.86),
        AppTheme.soften(palette.primary, 0.58),
        palette.secondary,
      ],
      stops: const <double>[0, 0.4, 0.7, 1],
    );
    final TextStyle titleStyle = AppTextStyles.titleLarge(context).copyWith(
      fontWeight: FontWeight.w700,
      color: AppTheme.soften(palette.primary, 0.18),
      letterSpacing: 0.4,
      fontSize: metrics.rem(1.5),
    );
    final TextStyle bodyStyle = AppTextStyles.bodyLarge(context).copyWith(
      color:
          Color.lerp(palette.primary, Colors.black, 0.42) ??
          palette.primary.withValues(alpha: 0.8),
      height: 1.5,
    );
    final NeomorphismPalette infoPalette = NeomorphismPalette.card(
      primaryAccent: palette.primary,
      secondaryAccent: palette.secondary,
      glowAccent: palette.accent,
      isHighlighted: true,
      isEnabled: true,
    );

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.gap(1.0),
              vertical: metrics.gap(0.75),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  showBack: true,
                  title: 'Hesaplamalar',
                  accentColor: palette.primary,
                  onLogoTap: () => context.go(HomeScreen.routePath),
                ),
                SizedBox(height: metrics.gap(1.0)),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 1, end: 0),
                    builder: (context, value, child) => Opacity(
                      opacity: 1 - value,
                      child: Transform.translate(
                        offset: Offset(0, 48 * value),
                        child: child,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: metrics.rem(17.5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: metrics.gap(1.2),
                          vertical: metrics.gap(1.1),
                        ),
                        decoration: infoPalette.decoration(metrics.br),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Hesaplamalar',
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: metrics.gap(1.0)),
                            Text(
                              'Mühendislik hesaplama şablonları ve kontrolleri için arayüz hazırlanıyor.',
                              style: bodyStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: metrics.gap(1.25)),
                            CupertinoButton(
                              color: palette.primary,
                              borderRadius: metrics.br,
                              padding: EdgeInsets.symmetric(
                                horizontal: metrics.gap(1.6),
                                vertical: metrics.gap(0.6),
                              ),
                              onPressed: () => context.go(HomeScreen.routePath),
                              child: const Text('Ana sayfaya dön'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
