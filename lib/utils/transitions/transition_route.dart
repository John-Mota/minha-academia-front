import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minha_academia_front/utils/constants/durations.dart';

GoRoute transitionGoRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  return GoRoute(
    path: path,
    parentNavigatorKey: parentNavigatorKey,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: transitionDuration,
      child: builder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.linear).animate(animation),
          child: child,
        );
      },
    ),
  );
}

ShellRoute transitionShellRoute({
  required List<RouteBase> routes,
  GlobalKey<NavigatorState>? navigatorKey,
  GlobalKey<NavigatorState>? parentNavigatorKey,
  Widget Function(BuildContext, GoRouterState, Widget)? builder,
}) {
  return ShellRoute(
    builder: builder,
    routes: routes,
    navigatorKey: navigatorKey,
    parentNavigatorKey: parentNavigatorKey,
  );
}
