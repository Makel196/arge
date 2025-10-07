import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Neomorfik yuzeyler icin tekrar kullanilabilir renk ve gorsel ayarlari tutar.
/// Bu arac sayesinde kart, kontrol ve chip gibi bilesenlerde ayni gorunumu saglayabiliriz.
class NeomorphismPalette {
  const NeomorphismPalette({
    required this.background,
    required this.shadows,
    this.borderColor,
    this.borderWidth = 0,
    required this.titleColor,
    required this.bodyColor,
    required this.iconColor,
    this.glow,
    this.badge,
    this.innerGlow,
  });

  /// Taban yuzeylerde kullanilan degrade.
  final LinearGradient background;

  /// Kabartma etkisi icin iki veya uc katmanli golve listesi.
  final List<BoxShadow> shadows;

  /// Cevre cizgisi rengi (istege bagli).
  final Color? borderColor;

  /// Cizgi kalinligi (varsayilan 0 - cizgi yok).
  final double borderWidth;

  /// Baslik metin rengi.
  final Color titleColor;

  /// Govde veya aciklama metin rengi.
  final Color bodyColor;

  /// Ikon rengi (kart ikonlari veya tekil buton ikonlari icin).
  final Color iconColor;

  /// Opsiyonel olarak ic parlama icin kullanilan radial degrade.
  final RadialGradient? glow;

  /// Ikon rozetleri gibi ek yuzeyler icin hazirlanan alt palet.
  final NeomorphismBadgePalette? badge;

  /// İç parlama efekti (inset glow).
  final RadialGradient? innerGlow;

  /// Hazir paleti BoxDecoration formatina cevirir.
  BoxDecoration decoration(BorderRadius borderRadius) {
    return BoxDecoration(
      gradient: background,
      boxShadow: shadows,
      borderRadius: borderRadius,
      border: null,
    );
  }

  /// Kart bilesenleri icin standart paleti uretir.
  factory NeomorphismPalette.card({
    required Color primaryAccent,
    required Color secondaryAccent,
    required Color glowAccent,
    required bool isHighlighted,
    required bool isEnabled,
  }) {
    // Tatlı pastel yüzey rengi
    final Color base = Color.lerp(AppColors.surface, Colors.white, 0.15)!;

    // Yumuşak accent karışımı
    final Color softAccent = Color.alphaBlend(
      primaryAccent.withValues(alpha: 0.08),
      base,
    );

    // Ultra yumuşak gradient
    final LinearGradient surfaceGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.alphaBlend(Colors.white.withValues(alpha: 0.25), softAccent),
        softAccent,
        Color.alphaBlend(
          primaryAccent.withValues(alpha: 0.04),
          Color.alphaBlend(Colors.black.withValues(alpha: 0.03), softAccent),
        ),
      ],
    );

    // Tatlı yumuşak gölgeler
    final List<BoxShadow> surfaceShadows = <BoxShadow>[
      // Highlight gölge
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.60),
        offset: const Offset(-8, -8),
        blurRadius: 18,
        spreadRadius: 0,
      ),
      // Shadow gölge
      BoxShadow(
        color: Color.alphaBlend(
          primaryAccent.withValues(alpha: 0.08),
          Colors.black.withValues(alpha: 0.12),
        ),
        offset: const Offset(8, 8),
        blurRadius: 18,
        spreadRadius: 0,
      ),
      // Tatlı ambient glow
      BoxShadow(
        color: glowAccent.withValues(alpha: 0.10),
        offset: const Offset(0, 0),
        blurRadius: 24,
        spreadRadius: -4,
      ),
    ];

    // Badge için yumuşak palet
    final NeomorphismBadgePalette badgePalette = NeomorphismBadgePalette(
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.alphaBlend(Colors.white.withValues(alpha: 0.30), softAccent),
          softAccent,
          Color.alphaBlend(primaryAccent.withValues(alpha: 0.12), softAccent),
        ],
      ),
      borderColor: null,
      borderWidth: 0,
      shadows: <BoxShadow>[
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.50),
          offset: const Offset(-3, -3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color.alphaBlend(
            glowAccent.withValues(alpha: 0.15),
            Colors.black.withValues(alpha: 0.10),
          ),
          offset: const Offset(3, 3),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
      iconColor: primaryAccent.withValues(alpha: 0.95),
    );

    return NeomorphismPalette(
      background: surfaceGradient,
      shadows: surfaceShadows,
      borderColor: null,
      borderWidth: 0,
      titleColor: primaryAccent.withValues(alpha: 0.90),
      bodyColor: Color.alphaBlend(
        primaryAccent.withValues(alpha: 0.15),
        const Color(0xFF6B7A8F),
      ),
      iconColor: primaryAccent.withValues(alpha: isEnabled ? 0.92 : 0.45),
      glow: RadialGradient(
        colors: <Color>[
          glowAccent.withValues(alpha: 0.12),
          glowAccent.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        radius: 1.0,
      ),
      innerGlow: RadialGradient(
        colors: <Color>[
          primaryAccent.withValues(alpha: 0.03),
          Colors.transparent,
        ],
        radius: 1.5,
      ),
      badge: badgePalette,
    );
  }

  /// Dairesel kontrol butonlari icin standart paleti uretir.
  factory NeomorphismPalette.control({
    required Color accent,
    required bool isPressed,
    required bool isEnabled,
  }) {
    // Yumuşak yüzey
    final Color base = Color.lerp(AppColors.surface, Colors.white, 0.12)!;
    final Color tinted = Color.alphaBlend(accent.withValues(alpha: 0.06), base);

    // Gradient
    final LinearGradient surfaceGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isPressed
          ? <Color>[
              Color.alphaBlend(Colors.black.withValues(alpha: 0.08), tinted),
              tinted,
              Color.alphaBlend(Colors.white.withValues(alpha: 0.10), tinted),
            ]
          : <Color>[
              Color.alphaBlend(Colors.white.withValues(alpha: 0.15), tinted),
              tinted,
              Color.alphaBlend(Colors.black.withValues(alpha: 0.04), tinted),
            ],
    );

    // Gölgeler
    final List<BoxShadow> surfaceShadows;
    if (isEnabled) {
      surfaceShadows = isPressed
          ? <BoxShadow>[
              // İçe çöküş
              BoxShadow(
                color: Color.alphaBlend(
                  accent.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.14),
                ),
                offset: const Offset(-4, -4),
                blurRadius: 10,
                spreadRadius: -2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.25),
                offset: const Offset(4, 4),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ]
          : <BoxShadow>[
              // Kabartma
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.70),
                offset: const Offset(-6, -6),
                blurRadius: 14,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Color.alphaBlend(
                  accent.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.16),
                ),
                offset: const Offset(6, 6),
                blurRadius: 14,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
                offset: const Offset(0, 0),
                blurRadius: 16,
                spreadRadius: -2,
              ),
            ];
    } else {
      surfaceShadows = <BoxShadow>[
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.50),
          offset: const Offset(-5, -5),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          offset: const Offset(5, 5),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];
    }

    return NeomorphismPalette(
      background: surfaceGradient,
      shadows: surfaceShadows,
      borderColor: null,
      borderWidth: 0,
      titleColor: accent.withValues(alpha: 0.88),
      bodyColor: accent.withValues(alpha: 0.75),
      iconColor: accent.withValues(alpha: isEnabled ? 0.92 : 0.40),
      glow: null,
      innerGlow: null,
      badge: null,
    );
  }

  /// İçe basık (inset) neomorphic efekt için özel palet
  factory NeomorphismPalette.inset({
    required Color accent,
    required bool isEnabled,
  }) {
    final Color base = Color.lerp(AppColors.surface, Colors.white, 0.10)!;

    final LinearGradient surfaceGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.alphaBlend(Colors.black.withValues(alpha: 0.06), base),
        base,
        Color.alphaBlend(Colors.white.withValues(alpha: 0.08), base),
      ],
    );

    final List<BoxShadow> surfaceShadows = <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: isEnabled ? 0.12 : 0.08),
        offset: const Offset(-3, -3),
        blurRadius: 8,
        spreadRadius: -1,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: isEnabled ? 0.20 : 0.12),
        offset: const Offset(3, 3),
        blurRadius: 8,
        spreadRadius: -1,
      ),
    ];

    return NeomorphismPalette(
      background: surfaceGradient,
      shadows: surfaceShadows,
      borderColor: null,
      borderWidth: 0,
      titleColor: accent.withValues(alpha: 0.85),
      bodyColor: accent.withValues(alpha: 0.70),
      iconColor: accent.withValues(alpha: isEnabled ? 0.88 : 0.42),
      glow: null,
      innerGlow: null,
      badge: null,
    );
  }

  /// Düz (flat) neomorphic efekt için özel palet
  factory NeomorphismPalette.flat({
    required Color accent,
    required bool isEnabled,
  }) {
    final Color base = Color.lerp(AppColors.surface, Colors.white, 0.12)!;

    final LinearGradient surfaceGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.alphaBlend(Colors.white.withValues(alpha: 0.10), base),
        base,
        Color.alphaBlend(Colors.black.withValues(alpha: 0.03), base),
      ],
    );

    final List<BoxShadow> surfaceShadows = <BoxShadow>[
      BoxShadow(
        color: Colors.white.withValues(alpha: isEnabled ? 0.45 : 0.30),
        offset: const Offset(-4, -4),
        blurRadius: 10,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isEnabled ? 0.10 : 0.06),
        offset: const Offset(4, 4),
        blurRadius: 10,
        spreadRadius: 0,
      ),
    ];

    return NeomorphismPalette(
      background: surfaceGradient,
      shadows: surfaceShadows,
      borderColor: null,
      borderWidth: 0,
      titleColor: accent.withValues(alpha: 0.88),
      bodyColor: accent.withValues(alpha: 0.72),
      iconColor: accent.withValues(alpha: isEnabled ? 0.90 : 0.43),
      glow: null,
      innerGlow: null,
      badge: null,
    );
  }
}

/// Ikon rozetleri veya chip bilesenleri icin ek palet bilgisi.
class NeomorphismBadgePalette {
  const NeomorphismBadgePalette({
    required this.background,
    this.borderColor,
    this.borderWidth = 0,
    required this.shadows,
    required this.iconColor,
  });

  final LinearGradient background;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow> shadows;
  final Color iconColor;

  BoxDecoration decoration(BorderRadius borderRadius) {
    return BoxDecoration(
      gradient: background,
      borderRadius: borderRadius,
      boxShadow: shadows,
      border: null,
    );
  }
}

/// Neomorfik mimaride tekrar kullandigimiz animasyon sureleri ve coklama katsayilari.
class NeomorphismTokens {
  const NeomorphismTokens._();

  // Animasyon sureleri
  static const Duration instantAnimation = Duration(milliseconds: 100);
  static const Duration quickAnimation = Duration(milliseconds: 160);
  static const Duration regularAnimation = Duration(milliseconds: 220);
  static const Duration relaxedAnimation = Duration(milliseconds: 320);
  static const Duration slowAnimation = Duration(milliseconds: 450);

  // Animasyon egrileri
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve smoothCurve = Curves.easeInOutQuart;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve sharpCurve = Curves.easeInOutExpo;

  // Boyut sabitleri
  static const BorderRadius circularButtonRadius = BorderRadius.all(
    Radius.circular(999),
  );
  static const BorderRadius cardRadius = AppRadius.r24;
  static const BorderRadius badgeRadius = AppRadius.r24;
  static const BorderRadius chipRadius = AppRadius.r24;
  static const BorderRadius smallRadius = AppRadius.r16;

  // Golge yukseklikleri (elevation)
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationVeryHigh = 16.0;

  // Opaklik degerleri
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;
}

/// Uygulama genelinde kullanilacak metin stillerini merkezi halde tutar.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge ??
        const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          height: 1.2,
        );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium ??
        const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          height: 1.25,
        );
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium ??
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.4,
        );
  }

  static TextStyle titleLarge(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge ??
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          height: 1.3,
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          height: 1.45,
        );
  }

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 14, height: 1.5, letterSpacing: 0.1);
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge ??
        const TextStyle(fontSize: 16, height: 1.5, letterSpacing: 0.15);
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ??
        const TextStyle(fontSize: 12, height: 1.4, letterSpacing: 0.1);
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          height: 1.2,
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          height: 1.35,
        );
  }
}
