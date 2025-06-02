import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'dart:math';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  late Box sessionBox;
  String? username;

  // Barometer variables
  double? currentPressure;
  String weatherCondition = "Mengukur...";
  String plantAdvice = "Menunggu data sensor...";

  Timer? barometerTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    sessionBox = Hive.box('sessionBox');
    username = sessionBox.get('currentUser');
    startSimulatedBarometer();
  }

  @override
  void dispose() {
    barometerTimer?.cancel();
    super.dispose();
  }

  void startSimulatedBarometer() {
    // Simulate barometer readings for demo purposes
    barometerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Simulate realistic pressure values (990-1030 hPa)
      double simulatedPressure = 1010 + (_random.nextDouble() * 40 - 20);
      updatePressureData(simulatedPressure);
    });
  }

  void updatePressureData(double pressure) {
    setState(() {
      currentPressure = pressure;
      analyzeWeatherCondition();
      generatePlantAdvice();
    });
  }

  void analyzeWeatherCondition() {
    if (currentPressure == null) return;

    if (currentPressure! > 1020) {
      weatherCondition = "☀️ Cuaca Cerah";
    } else if (currentPressure! > 1010) {
      weatherCondition = "🌤️ Cuaca Stabil";
    } else if (currentPressure! > 1000) {
      weatherCondition = "☁️ Cuaca Berawan";
    } else {
      weatherCondition = "🌧️ Cuaca Buruk";
    }
  }

  void generatePlantAdvice() {
    if (currentPressure == null) return;

    if (currentPressure! > 1020) {
      plantAdvice = "Waktu yang tepat untuk menyiram tanaman dan aktivitas berkebun!";
    } else if (currentPressure! > 1010) {
      plantAdvice = "Cuaca stabil, lakukan perawatan rutin tanaman Anda.";
    } else if (currentPressure! > 1000) {
      plantAdvice = "Pantau kelembaban tanah sebelum menyiram.";
    } else {
      plantAdvice = "Kemungkinan hujan, tunda penyiraman tanaman!";
    }
  }

  void showNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tekanan: ${currentPressure?.toStringAsFixed(1)} hPa - $plantAdvice'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
      appBar: AppBar(
        title: const Text(
          'PlantInfo - Barometer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: showNotification,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barometer Pressure Reading Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.speed,
                      size: 50,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentPressure != null
                          ? '${currentPressure!.toStringAsFixed(1)} hPa'
                          : 'Mengukur...',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tekanan Atmosfer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Weather Condition Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[200]!, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      weatherCondition,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      plantAdvice,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: showNotification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Tampilkan Info',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
