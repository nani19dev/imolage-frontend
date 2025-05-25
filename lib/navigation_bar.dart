import 'package:flutter/material.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:go_router/go_router.dart';

class MainScreens extends StatefulWidget {
  final Widget? child;

  const MainScreens({
    super.key,
    this.child,
  }); 

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  int currentIndex = 0; 

  void changeTab(int index) {
    switch (index) {
      case 0:
        context.goNamed(routeProperties);
        break;
      case 1:
        context.goNamed(routeDashboard);
        break;
      default:
        context.goNamed(routeProperties);
        break;
    }
    setState(() {
      currentIndex = index;
    });
  }

  final navBarItems = [
    const NavigationDestination(
      icon: Icon(Icons.groups_2_outlined),
      label: 'Properties',
    ),
    const NavigationDestination(
      icon: Icon(Icons.article_outlined),
      label: 'Dashboard',
    ),
    /*const NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      label: 'Profile',
    ),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(navBarItems[currentIndex].label),
      ),*/
      bottomNavigationBar: NavigationBar(
        destinations: navBarItems,
        selectedIndex: currentIndex,
        onDestinationSelected: (newIndex) => changeTab(newIndex)
      ),
      body: widget.child
    );
  }
}