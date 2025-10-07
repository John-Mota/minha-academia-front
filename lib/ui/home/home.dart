import 'package:flutter/material.dart';
import 'package:minha_academia_front/ui/home/dashboard_content.dart';

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
    const Center(child: Text('Página de Alunos')),
    const Center(child: Text('Página de Professores')),
    const Center(child: Text('Página de Frequência')),
    const Center(child: Text('Página de Máquinas')),
    const Center(child: Text('Página de Treinos')),
    const Center(child: Text('Página de Relatórios')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0.8,
              ),
            ),
            margin: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isCollapsed ? 50.0 : 250.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: _isCollapsed ? 4.0 : 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!_isCollapsed)
                          Expanded(
                            child: Text(
                              'FitPalette Admin',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
                  ),
                  _buildMenuItem(label: 'Alunos', icon: Icons.person, index: 1),
                  _buildMenuItem(
                    label: 'Professores',
                    icon: Icons.school,
                    index: 2,
                  ),
                  _buildMenuItem(
                    label: 'Frequência',
                    icon: Icons.calendar_month,
                    index: 3,
                  ),
                  _buildMenuItem(
                    label: 'Máquinas',
                    icon: Icons.fitness_center,
                    index: 4,
                  ),
                  _buildMenuItem(
                    label: 'Treinos',
                    icon: Icons.run_circle,
                    index: 5,
                  ),
                  _buildMenuItem(
                    label: 'Relatórios',
                    icon: Icons.assessment,
                    index: 6,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,

              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required int index,
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
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: SizedBox(
            height: 48.0,
            child: _isCollapsed
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
