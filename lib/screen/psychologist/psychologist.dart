import 'package:bipolari_app/screen/psychologist/widgets/charts.dart';
import 'package:bipolari_app/screen/psychologist/widgets/listPacients.dart';
import 'package:bipolari_app/screen/psychologist/widgets/psychologistProfile.dart';
import 'package:flutter/material.dart';

class PsychologistPage extends StatefulWidget {
  const PsychologistPage({Key? key}) : super(key: key);

  @override
  State<PsychologistPage> createState() => _PsychologistPageState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Inicio',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Usuarios',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Perfil',
  ),
];

const _widgets = [
  Charts(),
  ListPacients(),
  PsycholgistProfile()
];

class _PsychologistPageState extends State<PsychologistPage> {
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
    return _selectedIndex != 1 ? null: FloatingActionButton(
        onPressed:(){
          Navigator.pushNamed(context, "/psychologistic/form-pacient");
        },
        child: const Icon(Icons.add),
      );
  }
}