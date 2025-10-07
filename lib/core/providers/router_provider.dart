import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pgr_arge_sistemleri/features/calculations/presentation/calculations_page.dart';
import 'package:pgr_arge_sistemleri/features/home/presentation/home_screen.dart';
import 'package:pgr_arge_sistemleri/features/materials/presentation/materials_page.dart';
import 'package:pgr_arge_sistemleri/features/naming/presentation/naming_page.dart';
import 'package:pgr_arge_sistemleri/features/projects/presentation/projects_page.dart';
import 'package:pgr_arge_sistemleri/features/standards/presentation/standards_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: HomeScreen.routePath,
    routes: <RouteBase>[
      GoRoute(
        path: HomeScreen.routePath,
        name: HomeScreen.routeName,
        builder: HomeScreen.routeBuilder,
      ),
      GoRoute(
        path: NamingPage.routePath,
        name: NamingPage.routeName,
        builder: NamingPage.routeBuilder,
      ),
      GoRoute(
        path: StandardsPage.routePath,
        name: StandardsPage.routeName,
        builder: StandardsPage.routeBuilder,
      ),
      GoRoute(
        path: MaterialsPage.routePath,
        name: MaterialsPage.routeName,
        builder: MaterialsPage.routeBuilder,
      ),
      GoRoute(
        path: ProjectsPage.routePath,
        name: ProjectsPage.routeName,
        builder: ProjectsPage.routeBuilder,
      ),
      GoRoute(
        path: CalculationsPage.routePath,
        name: CalculationsPage.routeName,
        builder: CalculationsPage.routeBuilder,
      ),
    ],
  );
});
