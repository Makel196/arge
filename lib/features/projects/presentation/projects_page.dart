import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/common/widgets/coming_soon_scaffold.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const String routeName = 'projects';
  static const String routePath = '/projects';
  static Widget routeBuilder(BuildContext context, GoRouterState state) =>
      const ProjectsPage();

  @override
  Widget build(BuildContext context) {
    return const ComingSoonScaffold(
      title: 'Projeler',
    );
  }
}
