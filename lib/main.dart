import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const double winWidth = 800;
    const double winHeight = 800;

    // Minimum pencere boyutu
    const Size minSize = Size(winWidth, winHeight);
    window_size.setWindowMinSize(minSize);

    // Ekran(lar)ı al ve ilk ekrana göre pencereyi ortala
    final screens = await window_size.getScreenList();
    if (screens.isNotEmpty) {
      final frame = screens.first.frame; // aktif/ilk ekran
      final double left = frame.left + (frame.width - winWidth) / 2;
      final double top = frame.top + (frame.height - winHeight) / 2;

      window_size.setWindowFrame(Rect.fromLTWH(left, top, winWidth, winHeight));
    } else {
      // Ekran bilgisi alınamazsa, önceki davranışa benzer güvenli yedek
      window_size.setWindowFrame(
        const Rect.fromLTWH(100, 100, winWidth, winHeight),
      );
    }
  }

  runApp(const ProviderScope(child: App()));
}
