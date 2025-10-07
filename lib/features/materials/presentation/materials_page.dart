import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/widgets/coming_soon_scaffold.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  static const String routeName = 'materials';
  static const String routePath = '/materials';
  static Widget routeBuilder(BuildContext context, GoRouterState state) =>
      const MaterialsPage();

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScaffold(
      title: 'Malzemeler',
    );
  }
}
