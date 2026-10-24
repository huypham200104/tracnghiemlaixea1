import 'package:flutter/material.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/study/presentation/study_screen.dart';
import '../features/traffic_signs/presentation/traffic_signs_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

/// Navigation Shell 4 Tab theo chuẩn Material 3
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateTab: _onSelectTab),
      const StudyScreen(),
      const TrafficSignsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onSelectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Ôn tập',
            ),
            NavigationDestination(
              icon: Icon(Icons.traffic_outlined),
              selectedIcon: Icon(Icons.traffic),
              label: 'Biển báo',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Của tôi',
            ),
          ],
        ),
      ),
    );
  }
}
