import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/widgets/coming_soon_scaffold.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  static const String routeName = 'calculations';
  static const String routePath = '/calculations';
  static Widget routeBuilder(BuildContext context, GoRouterState state) =>
      const CalculationsPage();

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScaffold(
      title: 'Hesaplamalar',
    );
  }
}
