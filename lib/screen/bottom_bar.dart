import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/home_screen.dart';
import 'package:flutter_ticket_check/screen/more_screen.dart';
import 'package:flutter_ticket_check/screen/scan_screen.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ScanScreen(),
    const MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Styles.iconsColor,
        selectedItemColor: Styles.primaryColor,
        backgroundColor: Styles.shadeColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home_filled),
            label: 'О приложении',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            activeIcon: Icon(Icons.camera),
            label: 'Сканировать билет',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            activeIcon: Icon(Icons.menu),
            label: 'Ещё',
          ),
        ],
      ),
    );
  }
}
