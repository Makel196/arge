import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/utils/responsive.dart';
import 'package:pgr_arge_sistemleri/common/utils/sound_effects.dart';
import 'package:pgr_arge_sistemleri/common/theme/app_theme.dart';
import 'package:pgr_arge_sistemleri/common/theme/neomorphism.dart';
import 'package:pgr_arge_sistemleri/common/widgets/app_header.dart';
import 'package:pgr_arge_sistemleri/features/home/presentation/widgets/home_action_card.dart';

/// Ana sayfa ekranı - Responsive tasarım ile kartları gösterir
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home';
  static const String routePath = '/';

  static Widget routeBuilder(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  double _viewportFraction = 0.9;
  int _currentIndex = 0;

  static const List<_HomeAction> _actions = <_HomeAction>[
    _HomeAction(
      feature: AppFeature.naming,
      icon: FontAwesomeIcons.tags,
      title: 'İSİMLENDİRME',
      description:
          'Parça, proje ve doküman adlandırma tek tip kurallar uygulayın.',
      routePath: '/naming',
    ),
    _HomeAction(
      feature: AppFeature.standards,
      icon: FontAwesomeIcons.clipboardCheck,
      title: 'STANDARTLAR',
      description:
          'Kurumsal standartları ve prosedürleri tek yerde yönetin ve paylaşın.',
      routePath: '/standards',
    ),
    _HomeAction(
      feature: AppFeature.materials,
      icon: FontAwesomeIcons.boxesStacked,
      title: 'MALZEMELER',
      description:
          'Malzeme kartları, özellikler ve tedarik bilgilerini düzenleyin.',
      routePath: '/materials',
    ),
    _HomeAction(
      feature: AppFeature.projects,
      icon: FontAwesomeIcons.diagramProject,
      title: 'PROJELER',
      description: 'Görevleri planlayın, atayın ve ilerlemeyi izleyin.',
      routePath: '/projects',
    ),
    _HomeAction(
      feature: AppFeature.calculations,
      icon: FontAwesomeIcons.calculator,
      title: 'HESAPLAMALAR',
      description:
          'Mühendislik ve tasarım hesaplarını doğrulanabilir şablonlarla yapın.',
      routePath: '/calculations',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _viewportFraction);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _playClickSound() async {
    await SoundEffects.playTap();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ResponsiveScale metrics = ResponsiveScale.of(context);

    final double widthScale = (size.width / 1100).clamp(0.8, 1.35);
    final double heightScale = (size.height / 820).clamp(0.82, 1.2);
    final double averagedScale = (metrics.scale + widthScale + heightScale) / 3;
    final double scale = math.min(1.3, math.max(0.82, averagedScale));

    final _HomeAction currentAction = _actions[_currentIndex];
    final FeaturePalette currentPalette = AppTheme.featurePalette(
      currentAction.feature,
    );
    final LinearGradient backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.white,
        AppTheme.soften(currentPalette.accent, 0.85),
        AppTheme.soften(currentPalette.primary, 0.6),
        currentPalette.secondary,
      ],
      stops: const <double>[0, 0.42, 0.72, 1],
    );

    final double targetViewportFraction = size.width >= Responsive.wide
        ? 0.32
        : size.width >= Responsive.desktop
        ? 0.38
        : size.width >= Responsive.tablet
        ? 0.6
        : 0.88;

    _ensureViewport(targetViewportFraction);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.gap(1.0),
              vertical: metrics.gap(0.75),
            ),
            child: Column(
              children: [
                AppHeader(onLogoTap: () => context.go(HomeScreen.routePath)),
                SizedBox(height: metrics.gap(1.0)),
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 480),
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: math.min(size.width * 0.92, 1120.0 * scale),
                        ),
                        child: _HomeContent(
                          actions: _actions,
                          currentPalette: currentPalette,
                          controller: _pageController,
                          currentIndex: _currentIndex,
                          scale: scale,
                          showSideControls: size.width >= Responsive.desktop,
                          onPageChanged: _handlePageChanged,
                          onPrevious: _handlePrevious,
                          onNext: _handleNext,
                          onActionSelected: _handleActionSelected,
                          onIndicatorTap: _handleIndicatorTap,
                          onPlaySound: _playClickSound,
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

  void _ensureViewport(double targetFraction) {
    if ((targetFraction - _viewportFraction).abs() < 0.001) {
      return;
    }

    final oldController = _pageController;
    final double currentPage = oldController.hasClients
        ? oldController.page ?? _currentIndex.toDouble()
        : _currentIndex.toDouble();

    _viewportFraction = targetFraction;
    _pageController = PageController(
      viewportFraction: _viewportFraction,
      initialPage: currentPage.round().clamp(0, _actions.length - 1),
    );

    oldController.dispose();
  }

  void _handlePageChanged(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  void _handlePrevious() {
    if (_currentIndex == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleNext() {
    if (_currentIndex >= _actions.length - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleIndicatorTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleActionSelected(_HomeAction action) {
    if (action.routePath == null) {
      return;
    }
    context.push(action.routePath!);
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.actions,
    required this.currentPalette,
    required this.controller,
    required this.currentIndex,
    required this.scale,
    required this.showSideControls,
    required this.onPageChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onActionSelected,
    required this.onIndicatorTap,
    required this.onPlaySound,
  });

  final List<_HomeAction> actions;
  final FeaturePalette currentPalette;
  final PageController controller;
  final int currentIndex;
  final double scale;
  final bool showSideControls;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<_HomeAction> onActionSelected;
  final ValueChanged<int> onIndicatorTap;
  final VoidCallback onPlaySound;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Color accentColor = currentPalette.primary;
    final Color indicatorColor = AppTheme.soften(accentColor, 0.2);
    final Color inactiveIndicator = AppTheme.soften(accentColor, 0.82);
    final Color controlAccent = AppTheme.soften(accentColor, 0.08);

    final TextStyle headlineStyle = AppTextStyles.headlineLarge(context)
        .copyWith(
          fontSize: (28 * scale).clamp(19, 38).toDouble(),
          letterSpacing: 0.35,
          fontWeight: FontWeight.w700,
          height: 1.15,
          color: AppTheme.soften(accentColor, 0.12),
        );

    // DÜZELTME: clamp hatasını önlemek için min ve max değerlerini kontrol ediyoruz
    final double availableHeight = size.height * 0.62;
    final double scaledHeight = availableHeight * (0.7 + (scale - 1) * 0.18);
    final double minCardHeight = 240.0;
    final double maxCardHeight = size.height * (showSideControls ? 0.68 : 0.75);

    // Minimum değer maksimum değerden büyükse, maksimum değeri minimum değere eşitle
    final double safeMaxCardHeight = math.max(minCardHeight, maxCardHeight);
    final double cardHeight = scaledHeight.clamp(
      minCardHeight,
      safeMaxCardHeight,
    );

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: size.height * 0.8),
        child: Padding(
          padding: EdgeInsets.only(bottom: (32 * scale).clamp(24, 40)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AR-GE SİSTEMLERİ',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: headlineStyle,
              ),
              SizedBox(height: (24 * scale).clamp(16, 32)),
              SizedBox(
                height: cardHeight,
                child: _ActionCarousel(
                  controller: controller,
                  actions: actions,
                  currentIndex: currentIndex,
                  accentColor: controlAccent,
                  scale: scale,
                  showSideControls: showSideControls,
                  onPageChanged: onPageChanged,
                  onPrevious: onPrevious,
                  onNext: onNext,
                  onActionSelected: onActionSelected,
                  onPlaySound: onPlaySound,
                ),
              ),
              SizedBox(height: (28 * scale).clamp(24, 36)),
              _PageIndicators(
                currentIndex: currentIndex,
                itemCount: actions.length,
                scale: scale,
                activeColor: indicatorColor,
                inactiveColor: inactiveIndicator,
                onTap: onIndicatorTap,
              ),
              if (!showSideControls) ...[
                SizedBox(height: (28 * scale).clamp(24, 36)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CarouselButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: currentIndex == 0 ? null : onPrevious,
                      scale: scale,
                      accentColor: controlAccent,
                    ),
                    SizedBox(width: (20 * scale).clamp(16, 28)),
                    _CarouselButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: currentIndex >= actions.length - 1
                          ? null
                          : onNext,
                      scale: scale,
                      accentColor: controlAccent,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCarousel extends StatelessWidget {
  const _ActionCarousel({
    required this.controller,
    required this.actions,
    required this.currentIndex,
    required this.accentColor,
    required this.scale,
    required this.showSideControls,
    required this.onPageChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onActionSelected,
    required this.onPlaySound,
  });

  final PageController controller;
  final List<_HomeAction> actions;
  final int currentIndex;
  final Color accentColor;
  final double scale;
  final bool showSideControls;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<_HomeAction> onActionSelected;
  final VoidCallback onPlaySound;

  @override
  Widget build(BuildContext context) {
    final pageView = Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          if (event.scrollDelta.dy > 0) {
            if (currentIndex < actions.length - 1) {
              onNext();
            }
          } else if (event.scrollDelta.dy < 0) {
            if (currentIndex > 0) {
              onPrevious();
            }
          }
        }
      },
      child: PageView.builder(
        controller: controller,
        clipBehavior: Clip.none,
        padEnds: true,
        physics: const BouncingScrollPhysics(),
        itemCount: actions.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          final action = actions[index];
          final bool isActive = index == currentIndex;
          final FeaturePalette palette = AppTheme.featurePalette(
            action.feature,
          );
          final double activeScale = 1.02 + (scale - 1) * 0.08;
          final double inactiveScale = 0.92 + (scale - 1) * 0.05;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 360),
            curve: NeomorphismTokens.smoothCurve,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? (8 * scale) : (16 * scale),
              vertical: isActive ? (8 * scale) : (20 * scale),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 360),
              curve: NeomorphismTokens.smoothCurve,
              scale: isActive ? activeScale : inactiveScale,
              child: HomeActionCard(
                icon: action.icon,
                title: action.title,
                subtitle: action.description,
                isHighlighted: isActive,
                onDetailsPressed: action.routePath == null
                    ? null
                    : () {
                        onPlaySound();
                        onActionSelected(action);
                      },
                primaryColor: palette.primary,
                secondaryColor: palette.secondary,
                accentColor: palette.accent,
              ),
            ),
          );
        },
      ),
    );

    if (!showSideControls) {
      return pageView;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        pageView,
        Positioned(
          left: 0,
          child: _CarouselButton(
            icon: Icons.chevron_left_rounded,
            onPressed: currentIndex == 0 ? null : onPrevious,
            scale: scale,
            accentColor: accentColor,
          ),
        ),
        Positioned(
          right: 0,
          child: _CarouselButton(
            icon: Icons.chevron_right_rounded,
            onPressed: currentIndex >= actions.length - 1 ? null : onNext,
            scale: scale,
            accentColor: accentColor,
          ),
        ),
      ],
    );
  }
}

/// Yan ok butonları - neomorfik yönlendirme kontrolü
class _CarouselButton extends StatefulWidget {
  const _CarouselButton({
    required this.icon,
    this.onPressed,
    required this.scale,
    required this.accentColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double scale;
  final Color accentColor;

  @override
  State<_CarouselButton> createState() => _CarouselButtonState();
}

class _CarouselButtonState extends State<_CarouselButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double size = ((AppSpacing.s48 + AppSpacing.s8) * widget.scale)
        .clamp(40, 50)
        .toDouble();
    final double iconSize = (AppSpacing.s20 * widget.scale)
        .clamp(32, 48)
        .toDouble();
    final bool isEnabled = widget.onPressed != null;

    final NeomorphismPalette controlPalette = NeomorphismPalette.control(
      accent: widget.accentColor,
      isPressed: _isPressed,
      isEnabled: isEnabled,
    );

    return GestureDetector(
      onTapDown: (_) {
        if (isEnabled) {
          setState(() => _isPressed = true);
          SoundEffects.playTap();
        }
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: NeomorphismTokens.quickAnimation,
        curve: Curves.easeOutCubic,
        scale: _isPressed ? 0.94 : 1.0,
        child: AnimatedContainer(
          duration: NeomorphismTokens.regularAnimation,
          curve: Curves.easeOutCubic,
          width: size,
          height: size,
          decoration: controlPalette.decoration(AppRadius.cupertino),
          child: AnimatedContainer(
            duration: NeomorphismTokens.quickAnimation,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(_isPressed && isEnabled ? 2 : 0),
            decoration: const BoxDecoration(borderRadius: AppRadius.cupertino),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.cupertino,
                gradient: controlPalette.glow,
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: iconSize,
                  color: controlPalette.iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({
    required this.currentIndex,
    required this.itemCount,
    required this.scale,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final int currentIndex;
  final int itemCount;
  final double scale;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final double height = (8 * scale).clamp(8, 12).toDouble();
    final double passiveWidth = (18 * scale).clamp(12, 24).toDouble();
    final double activeWidth = (40 * scale).clamp(28, 48).toDouble();
    final double spacing = (6 * scale).clamp(4, 8).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: spacing),
            height: height,
            width: isActive ? activeWidth : passiveWidth,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: AppRadius.cupertino,
            ),
          ),
        );
      }),
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.feature,
    required this.icon,
    required this.title,
    required this.description,
    this.routePath,
  });

  final AppFeature feature;
  final IconData icon;
  final String title;
  final String description;
  final String? routePath;
}
