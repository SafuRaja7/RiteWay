import 'package:flutter/material.dart';
import 'package:riteway/cubits/auth/cubit.dart';
import 'package:riteway/screens/driver/driver.dart';
import 'package:riteway/screens/profile/profile.dart';
import 'package:riteway/screens/rider/rider.dart';
import 'package:riteway/screens/routes/routes_name.dart';

import '../../configs/configs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.cubit(context);

    final tabs = [
      authCubit.state.data!.type == 'Driver' ? const Driver() : const Rider(),
      const RoutesNameScreen(
        isNav: true,
      ),
      const Profile(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_outlined),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.c!.primary,
        onTap: _onTapped,
      ),
      body: tabs[_selectedIndex],
    );
  }
}
