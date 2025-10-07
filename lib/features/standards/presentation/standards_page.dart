import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/widgets/coming_soon_scaffold.dart';

class StandardsPage extends StatelessWidget {
  const StandardsPage({super.key});

  static const String routeName = 'standards';
  static const String routePath = '/standards';
  static Widget routeBuilder(BuildContext context, GoRouterState state) =>
      const StandardsPage();

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScaffold(
      title: 'Standartlar',
    );
  }
}
