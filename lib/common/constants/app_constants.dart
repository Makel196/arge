import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'PGR AR-GE';
  static const String appVersion = '1.0.0';

  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;
  static const double wideBreakpoint = 1440;

  static const double defaultWindowWidth = 800;
  static const double defaultWindowHeight = 800;
  static const double minWindowWidth = 800;
  static const double minWindowHeight = 800;

  static const Duration instantAnimation = Duration(milliseconds: 100);
  static const Duration quickAnimation = Duration(milliseconds: 160);
  static const Duration normalAnimation = Duration(milliseconds: 220);
  static const Duration slowAnimation = Duration(milliseconds: 450);

  static const bool enableDebugLogging = kDebugMode;
  static const bool enableAnalytics = kReleaseMode;

  static const String errorUnknown = 'Bilinmeyen bir hata oluştu';
  static const String errorNetwork = 'İnternet bağlantısı bulunamadı';

  static const String assetIconPath = 'assets/icon/';
  static const String assetDecorPath = 'assets/decor/';
  static const String assetSoundsPath = 'assets/sounds/';
}

enum DeviceType { mobile, tablet, desktop, wideScreen }

DeviceType getDeviceType(double width) {
  if (width < AppConstants.tabletBreakpoint) {
    return DeviceType.mobile;
  } else if (width < AppConstants.desktopBreakpoint) {
    return DeviceType.tablet;
  } else if (width < AppConstants.wideBreakpoint) {
    return DeviceType.desktop;
  } else {
    return DeviceType.wideScreen;
  }
}
