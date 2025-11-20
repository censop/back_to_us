
import 'package:back_to_us/Screens/NavigationBar/capture_screen.dart';
import 'package:back_to_us/Screens/NavigationBar/home_screen.dart';
import 'package:back_to_us/Screens/Profile/Settings/settings_screen.dart';
import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Theme/my_app_theme.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/routes.dart';
import 'package:flutter/material.dart';


class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int currentPageIndex = 0;

  bool isLoading = false;

  List<Widget> screens = [
    HomeScreen(),
    CaptureScreen(), 
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    loadAppData();
  }


  @override
  Widget build(BuildContext context) {
    bool isCaptureScreen = currentPageIndex == 1;

    return Scaffold(
       appBar: AppBar(
        title: Text(
          "Back to Us",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: MyAppTheme.mainColor,
          )
        ),
        centerTitle: true,
        actions: [
          CustomProfilePictureDisplayer(
            radius: 24,
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.profile,
              );
            },
          ),
          SizedBox(width: 16,)
        ],
      ),
      extendBody: isCaptureScreen,
      bottomNavigationBar: NavigationBar(
        backgroundColor: currentPageIndex == 1 ? Theme.of(context).colorScheme.surface.withAlpha(0) :Theme.of(context).colorScheme.surface,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [ 
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle), 
            label: "New"
          ), 
          NavigationDestination(
            icon: Icon(Icons.settings_outlined), 
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : screens[currentPageIndex],

    );
  }
    Future<void> loadAppData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseService.getAppUser();
    setState(() {
      isLoading = false;
    });
  }

}