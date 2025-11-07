import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:minha_academia_front/data/repositories/auth_repository.dart';
import 'package:minha_academia_front/presentation/features/auth/login.dart';
import 'package:minha_academia_front/presentation/features/dashboard/home.dart';
import 'package:minha_academia_front/presentation/features/dashboard/dashboard_content.dart';
import 'package:minha_academia_front/presentation/features/aluno/alunos_screen.dart';
import 'package:minha_academia_front/presentation/features/aluno/cadastro_aluno_screen.dart';
import 'package:minha_academia_front/presentation/features/professor/professores_screen.dart';
import 'package:minha_academia_front/presentation/features/professor/cadastro_professor_screen.dart';
import 'package:minha_academia_front/presentation/features/maquina/maquinas_screen.dart';
import 'package:minha_academia_front/presentation/features/maquina/cadastro_maquina_screen.dart';
import 'package:minha_academia_front/presentation/features/treino/treinos_screen.dart';
import 'package:minha_academia_front/presentation/features/treino/cadastro_treino_screen.dart';
import 'package:minha_academia_front/presentation/features/aulas/aulas_screen.dart';
import 'package:minha_academia_front/presentation/features/aulas/cadastro_aula_screen.dart';
import 'package:minha_academia_front/presentation/features/mapa/mapa_screen.dart';

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
    return '/home';
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
    initialLocation: '/login',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authRepository,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (ctx, state) => const Login(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (ctx, state, child) {
          // Ajuste Crítico: Passa o widget 'child' (a tela da rota) para o Home.
          // O Home agora é o Layout que contém o menu e renderiza o 'child'.
          return Home(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            parentNavigatorKey: _shellNavigatorKey,
            // O DashboardContent é a tela inicial dentro do layout Home.
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: DashboardContent()),
          ),
          GoRoute(
            path: '/alunos',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: AlunosScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                // Rotas de cadastro não precisam de NoTransitionPage se quiserem animação de slide,
                // mas mantive a consistência com o que você enviou.
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (ctx, state) =>
                    const NoTransitionPage(child: CadastroAlunoScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/professor',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: ProfessoresScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (ctx, state) =>
                    const NoTransitionPage(child: CadastroProfessorScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/maquina',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: MaquinasScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (ctx, state) =>
                    const NoTransitionPage(child: CadastroMaquinaScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/treino',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: TreinosScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (ctx, state) =>
                    const NoTransitionPage(child: CadastroTreinoScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/aulas',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: AulasScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                parentNavigatorKey: _shellNavigatorKey,
                pageBuilder: (ctx, state) =>
                    const NoTransitionPage(child: CadastroAulaScreen()),
              ),
            ],
          ),
          GoRoute(
            path: '/mapa',
            parentNavigatorKey: _shellNavigatorKey,
            pageBuilder: (ctx, state) =>
                const NoTransitionPage(child: MapaScreen()),
          ),
        ],
      ),
    ],
  );
}
