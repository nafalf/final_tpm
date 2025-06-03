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

  // === PAGE CONFIGURATION === //
  static const List<Widget> _pages = [
    ListTanamanPage(),
    FavoritePage(),
    ConversionPage(),
    TrackingPage(),
    SensorPage(),
    SaranPage(),
    ProfilePage(),
  ];

  static const List<_PageConfig> _pageConfigs = [
    _PageConfig(
      title: 'Tanaman',
      icon: Icons.local_florist,
      hasAppBar: false,
      hasFloatingLogout: true,
    ),
    _PageConfig(
      title: 'Favorit',
      icon: Icons.favorite,
      hasAppBar: false,
      hasFloatingLogout: true,
    ),
    _PageConfig(
      title: 'Konversi',
      icon: Icons.swap_horiz,
      hasAppBar: true,
      hasFloatingLogout: false,
    ),
    _PageConfig(
      title: 'Tracking',
      icon: Icons.location_on,
      hasAppBar: true,
      hasFloatingLogout: false,
    ),
    _PageConfig(
      title: 'Sensor',
      icon: Icons.sensors,
      hasAppBar: true,
      hasFloatingLogout: false,
    ),
    _PageConfig(
      title: 'Saran',
      icon: Icons.feedback,
      hasAppBar: false,
      hasFloatingLogout: false,
    ),
    _PageConfig(
      title: 'Profil',
      icon: Icons.person,
      hasAppBar: true,
      hasFloatingLogout: false,
    ),
  ];

  // === METHODS === //
  Future<void> _logout() async {
    try {
      // Show confirmation dialog
      final bool? shouldLogout = await _showLogoutConfirmation();
      if (shouldLogout != true) return;

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.green),
          ),
        );
      }

      // Clear session
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');

      // Navigate to login
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog if open
        _showErrorSnackBar('Terjadi kesalahan saat logout');
      }
    }
  }

  Future<bool?> _showLogoutConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[400]),
            const SizedBox(width: 8),
            const Text('Konfirmasi Logout'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // === UI BUILDERS === //
  @override
  Widget build(BuildContext context) {
    final currentConfig = _pageConfigs[_currentIndex];

    return Scaffold(
      appBar: currentConfig.hasAppBar ? _buildAppBar(currentConfig.title) : null,
      body: _buildBody(currentConfig),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.green[600],
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      actions: [
        _buildLogoutButton(isAppBar: true),
      ],
    );
  }

  Widget _buildBody(_PageConfig config) {
    if (config.hasFloatingLogout) {
      return Stack(
        children: [
          _pages[_currentIndex],
          _buildFloatingLogoutButton(),
        ],
      );
    }
    return _pages[_currentIndex];
  }

  Widget _buildFloatingLogoutButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildLogoutButton(isAppBar: false),
      ),
    );
  }

  Widget _buildLogoutButton({required bool isAppBar}) {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: isAppBar ? Colors.white : Colors.green[600],
        size: 20,
      ),
      tooltip: 'Logout',
      onPressed: _logout,
      splashRadius: 20,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: _onTabChanged,
        items: _pageConfigs.map((config) {
          return BottomNavigationBarItem(
            icon: Icon(config.icon),
            activeIcon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(config.icon),
            ),
            label: config.title,
          );
        }).toList(),
      ),
    );
  }
}

// === PAGE CONFIGURATION CLASS === //
class _PageConfig {
  final String title;
  final IconData icon;
  final bool hasAppBar;
  final bool hasFloatingLogout;

  const _PageConfig({
    required this.title,
    required this.icon,
    required this.hasAppBar,
    required this.hasFloatingLogout,
  });
}