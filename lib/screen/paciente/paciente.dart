import 'package:bipolari_app/screen/paciente/widgets/listRegisters.dart';
import 'package:bipolari_app/screen/paciente/widgets/pacientProfile.dart';
import 'package:flutter/material.dart';

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});
  @override
  State<PacientePage> createState() => _PacientePageState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.emoji_emotions),
    label: 'Registros',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Perfil',
  ),
];

const _widgets = [
  ListRegisters(),
  PacientProfile()
];

class _PacientePageState extends State<PacientePage> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final bool _isSmallScreen = _width < 600;
    final bool _isLargeScreen = _width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text('BipolariApp'),
      ),
      bottomNavigationBar: _isSmallScreen
          ? BottomNavigationBar(
              items: _navBarItems,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              })
          : null,
      body: Row(
        children: <Widget>[
          if (!_isSmallScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: _isLargeScreen,
              destinations: _navBarItems
                  .map((item) => NavigationRailDestination(
                      icon: item.icon,
                      selectedIcon: item.activeIcon,
                      label: Text(
                        item.label!,
                      )))
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: Center(
              child: _widgets[_selectedIndex],
            ),
          )
        ],
      ),
    floatingActionButton: mostrarBoton(context),
    );
  }
  
  Widget? mostrarBoton(BuildContext context) {
    return _selectedIndex != 0 ? null: FloatingActionButton(
        onPressed:(){
          Navigator.pushNamed(context, "/pacient/form-register");
        },
        child: const Icon(Icons.add),
      );
  }
}