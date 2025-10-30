import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:minha_academia_front/data/repositories/auth_repository.dart';
import 'package:minha_academia_front/presentation/features/auth/login.dart';
import 'package:minha_academia_front/presentation/features/dashboard/home.dart';
import 'package:minha_academia_front/presentation/features/dashboard/dashboard_content.dart';
import 'package:minha_academia_front/presentation/features/professor/professores_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

Future<String?> _redirect(BuildContext ctx, GoRouterState state) async {
  final authRepository = ctx.read<AuthRepository>();
  final loggedIn = authRepository.isLogged;

  const loginPath = '/login';
  final isGoingToLogin = state.matchedLocation == loginPath;

  const publicRoutes = {loginPath};
  final isPublicRoute = publicRoutes.contains(state.matchedLocation);

  if (loggedIn && isGoingToLogin) {
    return '/';
  }

  if (isPublicRoute) {
    return null;
  }

  if (!loggedIn) {
    return loginPath;
  }

  return null;
}

GoRouter buildAppRouter(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,

    refreshListenable: authRepository,
    redirect: _redirect,

    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (ctx, state, child) {
          return Home();
        },
        routes: [
          GoRoute(
            path: '/',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: DashboardContent()),
          ),
          GoRoute(
            path: '/professores',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: ProfessoresScreen()),
            routes: [],
          ),
        ],
      ),

      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (ctx, state) => const Login(),
      ),
    ],
  );
}
