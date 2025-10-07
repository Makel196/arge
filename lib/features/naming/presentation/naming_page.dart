import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/widgets/coming_soon_scaffold.dart';

class NamingPage extends StatelessWidget {
  const NamingPage({super.key});

  static const String routeName = 'naming';
  static const String routePath = '/naming';
  static Widget routeBuilder(BuildContext context, GoRouterState state) =>
      const NamingPage();

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScaffold(title: 'Isimlendirme Sistemleri');
  }
}
