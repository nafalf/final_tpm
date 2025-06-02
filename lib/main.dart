import 'package:final_tpm/pages/sensor_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:final_tpm/models/user.dart';
import 'package:final_tpm/models/plant.dart';

// Import halaman (buat file kosong dulu, nanti isi step selanjutnya)
import 'package:final_tpm/pages/login_page.dart';
import 'package:final_tpm/pages/register_page.dart';
import 'package:final_tpm/pages/list_page.dart';
import 'package:final_tpm/pages/favorite_page.dart';
import 'package:final_tpm/pages/profile_page.dart';
import 'package:final_tpm/pages/saran_page.dart';
import 'package:final_tpm/pages/detail_page.dart';
import 'package:final_tpm/pages/conversion_page.dart';
import 'package:final_tpm/pages/tracking_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Register adapter clc
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PlantAdapter());

  // Buka box untuk session dan favorites
  await Hive.openBox<User>('usersBox');
  await Hive.openBox('sessionBox');
  await Hive.openBox('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantInfo',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/list': (context) => const ListPage(),
        '/favorite': (context) => const FavoritePage(),
        '/profile': (context) => const ProfilePage(),
        '/saran': (context) => const SaranPage(),
        '/conversion': (context) => const ConversionPage(),
        '/tracking': (context) => const TrackingPage(),
        '/sensor': (context) => const SensorPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final id = settings.arguments as String;
          return MaterialPageRoute(
              builder: (_) => DetailPage(id: id));
        }
        return null;
      },
    );
  }
}
