import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/room_provider.dart';
import '../event/event_feed_screen.dart';
import '../profile/profile_screen.dart';
import '../room/room_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Load initial data
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Get providers
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Set token for API requests if authenticated
    if (authProvider.isAuthenticated) {
      eventProvider.setToken(authProvider.token!);
      // roomProvider.setToken(authProvider.token!);
    }

    // In a real app, we would fetch data from API
    // For demo, we're using mock data
    eventProvider.setMockEvents();

    // Preload user's saved rooms if authenticated
    if (authProvider.isAuthenticated) {
      await roomProvider.fetchSavedRooms();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Events Feed
          const EventFeedScreen(),

          // Saved Rooms
          const RoomListScreen(isSavedRooms: true),

          // Profile
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_basketball_outlined),
              activeIcon: Icon(Icons.sports_basketball),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Rooms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textLightSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
