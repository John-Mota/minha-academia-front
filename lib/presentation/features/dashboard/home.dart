import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  final Widget child;

  const Home({super.key, required this.child});
  static const List<Map<String, dynamic>> menuItems = [
    {'label': 'Início', 'icon': Icons.dashboard, 'path': '/home'},
    {'label': 'Alunos', 'icon': Icons.person, 'path': '/alunos'},
    {'label': 'Professores', 'icon': Icons.school, 'path': '/professor'},
    {'label': 'Máquinas', 'icon': Icons.fitness_center, 'path': '/maquina'},
    {'label': 'Treinos', 'icon': Icons.run_circle, 'path': '/treino'},
    {'label': 'Aulas', 'icon': Icons.sports_gymnastics, 'path': '/aulas'},
    {'label': 'Mapa', 'icon': Icons.assessment, 'path': '/mapa'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double desktopBreakpoint = 900.0;
    final isDesktop = screenWidth >= desktopBreakpoint;
    final currentPath = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.toString();

    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FitPalette Admin'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        drawer: Drawer(
          child: _buildSidebar(context, true, currentPath, isCollapsed: false),
        ),
        body: child,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0.8,
              ),
            ),
            margin: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 250.0,
              child: _buildSidebar(
                context,
                false,
                currentPath,
                isCollapsed: false,
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    bool isMobile,
    String currentPath, {
    required bool isCollapsed,
  }) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: isMobile || isCollapsed ? 4.0 : 16.0,
          ),
          child: Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (!isMobile)
                Expanded(
                  child: Text(
                    'FitPalette Admin',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),

        ...menuItems.map((item) {
          final isSelected = currentPath.startsWith(item['path'] as String);
          return _buildMenuItem(
            context: context,
            label: item['label'] as String,
            icon: item['icon'] as IconData,
            path: item['path'] as String,
            isSelected: isSelected,
            isMobile: isMobile,
            isCollapsed: isCollapsed,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String path,
    required bool isSelected,
    required bool isMobile,
    required bool isCollapsed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () {
            debugPrint('Menu Clicado: $label -> Caminho de navegação: $path');

            context.go(path);
            if (isMobile) {
              Navigator.of(context).pop();
            }
          },
          child: SizedBox(
            height: 48.0,
            child: isCollapsed && !isMobile
                ? Tooltip(
                    message: label,
                    child: Center(
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(178),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(178),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(178),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
