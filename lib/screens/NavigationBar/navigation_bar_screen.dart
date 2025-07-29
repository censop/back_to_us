import 'package:back_to_us/Screens/NavigationBar/home_screen.dart';
import 'package:back_to_us/Screens/NavigationBar/profile_screen.dart';
import 'package:flutter/material.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int currentPageIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [ 
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined), 
            selectedIcon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
      body: screens[currentPageIndex],
    );
  }
}