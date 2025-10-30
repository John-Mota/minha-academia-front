import 'package:flutter/material.dart';
import 'package:minha_academia_front/presentation/features/aluno/alunos_screen.dart';
import 'package:minha_academia_front/presentation/features/dashboard/dashboard_content.dart';
import 'package:minha_academia_front/presentation/features/maquinas/MaquinasScreen.dart';
import 'package:minha_academia_front/presentation/features/professor/professores_screen.dart';
import 'package:minha_academia_front/presentation/features/treinos/TreinosScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isCollapsed = false;

  final List<Widget> _pages = [
    const DashboardContent(),
    const AlunosScreen(),
    const ProfessoresScreen(),
    const MaquinasScreen(),
    const TreinosScreen(),
    const Center(child: Text('Página de Relatórios')),
  ];

  void _onMenuItemSelected(int index, {bool closeDrawer = false}) {
    setState(() {
      _selectedIndex = index;
    });
    if (closeDrawer && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildSidebar(bool isMobile) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: isMobile || _isCollapsed ? 4.0 : 16.0,
          ),
          child: Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (!isMobile && !_isCollapsed)
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
              if (!isMobile)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  icon: Icon(
                    _isCollapsed ? Icons.menu : Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20.0,
                  ),
                ),
            ],
          ),
        ),
        _buildMenuItem(
          label: 'Início',
          icon: Icons.dashboard,
          index: 0,
          isMobile: isMobile,
        ),
        _buildMenuItem(
          label: 'Alunos',
          icon: Icons.person,
          index: 1,
          isMobile: isMobile,
        ),
        _buildMenuItem(
          label: 'Professores',
          icon: Icons.school,
          index: 2,
          isMobile: isMobile,
        ),
        _buildMenuItem(
          label: 'Máquinas',
          icon: Icons.fitness_center,
          index: 3,
          isMobile: isMobile,
        ),
        _buildMenuItem(
          label: 'Treinos',
          icon: Icons.run_circle,
          index: 4,
          isMobile: isMobile,
        ),
        _buildMenuItem(
          label: 'Relatórios',
          icon: Icons.assessment,
          index: 5,
          isMobile: isMobile,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double desktopBreakpoint = 900.0;
    final isDesktop = screenWidth >= desktopBreakpoint;
    if (!isDesktop) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('FitPalette Admin'),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
        drawer: Drawer(child: _buildSidebar(true)),

        body: _pages[_selectedIndex],
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isCollapsed ? 50.0 : 250.0,
              child: _buildSidebar(false),
            ),
          ),

          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required int index,
    required bool isMobile,
  }) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Material(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withAlpha(25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: () => _onMenuItemSelected(index, closeDrawer: isMobile),
          child: SizedBox(
            height: 48.0,
            child: _isCollapsed && !isMobile
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
