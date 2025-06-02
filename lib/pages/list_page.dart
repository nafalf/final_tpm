import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:final_tpm/pages/list_tanaman_page.dart';
import 'package:final_tpm/pages/favorite_page.dart';
import 'package:final_tpm/pages/profile_page.dart';
import 'package:final_tpm/pages/saran_page.dart';
import 'package:final_tpm/pages/conversion_page.dart';
import 'package:final_tpm/pages/tracking_page.dart';
import 'package:final_tpm/pages/sensor_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ListTanamanPage(),
    FavoritePage(),
    ProfilePage(),
    SaranPage(),
    ConversionPage(),
    TrackingPage(),
    SensorPage(),
  ];

  final List<String> _titles = [
    'Tanaman',
    'Favorit',
    'Profil',
    'Saran',
    'Konversi',
    'Tracking',
    'Sensor',
  ];

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser'); // hapus session

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Tanaman'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Saran'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Konversi'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensor'),          
        ],
      ),
    );
  }
}
