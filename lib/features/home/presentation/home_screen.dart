import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:pgr_arge_sistemleri/common/utils/responsive.dart';
import 'package:pgr_arge_sistemleri/common/widgets/brand_logo.dart';
import 'package:pgr_arge_sistemleri/common/theme/app_theme.dart';
import 'package:pgr_arge_sistemleri/common/theme/neomorphism.dart';
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
  late AudioPlayer _audioPlayer;

  static const List<_HomeAction> _actions = <_HomeAction>[
    _HomeAction(
      icon: FontAwesomeIcons.tags,
      title: 'İSİMLENDİRME',
      description:
          'Parça, proje ve doküman adlandırmalarında tek tip kurallar uygulayın.',
      primaryColor: Color(0xFFD22630),
      secondaryColor: Color(0xFFF96A49),
      accentColor: Color(0xFFFFB74D),
      routePath: '/naming',
    ),
    _HomeAction(
      icon: FontAwesomeIcons.clipboardCheck,
      title: 'STANDARTLAR',
      description:
          'Kurumsal standartları ve prosedürleri tek yerde yönetin ve paylaşın.',
      primaryColor: Color(0xFF3F51B5),
      secondaryColor: Color(0xFF5C6BC0),
      accentColor: Color(0xFF64B5F6),
      routePath: '/standards',
    ),
    _HomeAction(
      icon: FontAwesomeIcons.boxesStacked,
      title: 'MALZEMELER',
      description:
          'Malzeme kartları, özellikler ve tedarik bilgilerini düzenleyin.',
      primaryColor: Color(0xFF00897B),
      secondaryColor: Color(0xFF26A69A),
      accentColor: Color(0xFFA5D6A7),
      routePath: '/materials',
    ),
    _HomeAction(
      icon: FontAwesomeIcons.diagramProject,
      title: 'PROJELER',
      description: 'Görevleri planlayın, atayın ve ilerlemeyi izleyin.',
      primaryColor: Color(0xFF6A1B9A),
      secondaryColor: Color(0xFF8E24AA),
      accentColor: Color(0xFFCE93D8),
      routePath: '/projects',
    ),
    _HomeAction(
      icon: FontAwesomeIcons.calculator,
      title: 'HESAPLAMALAR',
      description:
          'Mühendislik ve tasarım hesaplarını doğrulanabilir şablonlarla yapın.',
      primaryColor: Color.fromARGB(255, 250, 121, 15),
      secondaryColor: Color.fromARGB(255, 219, 156, 97),
      accentColor: Color.fromARGB(255, 247, 212, 192),
      routePath: '/calculations',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: _viewportFraction);
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/click.mp3'), volume: 0.3);
    } catch (e) {
      debugPrint('Ses çalınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minSide = math.min(size.width, size.height);
    final double scale = (minSide / 800).clamp(0.75, 1.35);

    final double targetViewportFraction = size.width >= Responsive.desktop
        ? 0.38
        : size.width >= Responsive.tablet
        ? 0.62
        : 0.86;

    _ensureViewport(targetViewportFraction);

    return Scaffold(
      body: Stack(
        children: [
          _HomeBackground(scale: scale),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (20 * scale).clamp(16, 40),
                vertical: (16 * scale).clamp(12, 24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: (72 * scale).clamp(48, 88),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          _playClickSound();
                        },
                        child: Transform.translate(
                          offset: Offset((-8 * scale).clamp(-16, -4), 0),
                          child: BrandLogo(height: (72 * scale).clamp(48, 88)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: math.min(size.width * 0.92, 1120.0 * scale),
                        ),
                        child: _HomeContent(
                          actions: _actions,
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
                ],
              ),
            ),
          ),
        ],
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
    context.go(action.routePath!);
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minSide = math.min(size.width, size.height);
    final double cornerSide = (minSide * 0.30 * scale).clamp(160, 420);

    final theme = Theme.of(context);
    final Color backgroundColor = theme.scaffoldBackgroundColor;

    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        children: [
          _CornerImage(
            assetPath: 'assets/decor/top_right.svg',
            alignment: Alignment.topRight,
            offset: Offset(32 * scale, -32 * scale),
            side: cornerSide,
          ),
          _CornerImage(
            assetPath: 'assets/decor/bottom_left.svg',
            alignment: Alignment.bottomLeft,
            offset: Offset(-32 * scale, 32 * scale),
            side: cornerSide,
          ),
        ],
      ),
    );
  }
}

class _CornerImage extends StatelessWidget {
  const _CornerImage({
    required this.assetPath,
    required this.alignment,
    required this.offset,
    required this.side,
  });

  final String assetPath;
  final Alignment alignment;
  final Offset offset;
  final double side;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: SizedBox(
          width: side,
          height: side,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: SvgPicture.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.actions,
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
    final TextStyle headlineStyle = AppTextStyles.headlineLarge(context)
        .copyWith(
          fontSize: (32 * scale).clamp(24, 40).toDouble(),
          letterSpacing: 0.4,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        );
    final availableHeight = size.height * 0.6;
    final double cardHeight = (availableHeight * 0.75).clamp(300, 520);

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
                style: headlineStyle,
              ),
              SizedBox(height: (24 * scale).clamp(16, 32)),
              SizedBox(
                height: cardHeight,
                child: _ActionCarousel(
                  controller: controller,
                  actions: actions,
                  currentIndex: currentIndex,
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
                    ),
                    SizedBox(width: (20 * scale).clamp(16, 28)),
                    _CarouselButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: currentIndex >= actions.length - 1
                          ? null
                          : onNext,
                      scale: scale,
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
              scale: isActive ? 1 : 0.94,
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
                primaryColor: action.primaryColor,
                secondaryColor: action.secondaryColor,
                accentColor: action.accentColor,
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
          ),
        ),
        Positioned(
          right: 0,
          child: _CarouselButton(
            icon: Icons.chevron_right_rounded,
            onPressed: currentIndex >= actions.length - 1 ? null : onNext,
            scale: scale,
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
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double scale;

  @override
  State<_CarouselButton> createState() => _CarouselButtonState();
}

class _CarouselButtonState extends State<_CarouselButton> {
  bool _isPressed = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/click.mp3'), volume: 0.3);
    } catch (e) {
      debugPrint('Ses çalınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = ((AppSpacing.s48 + AppSpacing.s8) * widget.scale)
        .clamp(40, 50)
        .toDouble();
    final double iconSize = (AppSpacing.s20 * widget.scale)
        .clamp(32, 48)
        .toDouble();
    final bool isEnabled = widget.onPressed != null;

    // Yandaki ok butonları için ortak neomorfik palet kullanılır.
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final NeomorphismPalette controlPalette = NeomorphismPalette.control(
      accent: colorScheme.primary,
      isPressed: _isPressed,
      isEnabled: isEnabled,
    );

    return GestureDetector(
      onTapDown: (_) {
        if (isEnabled) {
          setState(() => _isPressed = true);
          _playClickSound();
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
    required this.onTap,
  });

  final int currentIndex;
  final int itemCount;
  final double scale;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.primary.withAlpha((0.2 * 255).round()),
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
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.routePath,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String? routePath;
}
