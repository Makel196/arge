import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'app/app.dart';
import 'common/constants/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  if (Platform.isAndroid || Platform.isIOS) {
    const SystemUiOverlayStyle overlays = SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(overlays);
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const double winWidth = AppConstants.defaultWindowWidth;
    const double winHeight = AppConstants.defaultWindowHeight;

    window_size.setWindowMinSize(
      const Size(AppConstants.minWindowWidth, AppConstants.minWindowHeight),
    );

    final screens = await window_size.getScreenList();
    if (screens.isNotEmpty) {
      final frame = screens.first.frame;
      final double left = frame.left + (frame.width - winWidth) / 2;
      final double top = frame.top + (frame.height - winHeight) / 2;

      window_size.setWindowFrame(Rect.fromLTWH(left, top, winWidth, winHeight));
    } else {
      window_size.setWindowFrame(
        const Rect.fromLTWH(100, 100, winWidth, winHeight),
      );
    }
  }

  runApp(const ProviderScope(child: App()));
}
