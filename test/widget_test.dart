// Basic smoke test for the AR-GE home experience.

import "package:flutter_test/flutter_test.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:pgr_arge_sistemleri/app/app.dart";

void main() {
  testWidgets('renders AR-GE home screen headline', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('AR-GE SİSTEMLERİ'), findsOneWidget);
  });
}
