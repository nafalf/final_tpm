import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  String _locationMessage = "Lokasi belum didapatkan";
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;
  Stream<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartTracking();
  }

  Future<void> _checkPermissionsAndStartTracking() async {
    setState(() {
      _isLoading = true;
      _locationMessage = "Memeriksa izin lokasi...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Layanan lokasi tidak aktif. Aktifkan layanan lokasi.";
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Izin lokasi ditolak.";
          _isLoading = false;
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Izin lokasi ditolak permanen, aktifkan di pengaturan.";
        _isLoading = false;
      });
      return;
    }

    _startListeningLocation();
  }

  void _startListeningLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // update setiap 5 meter
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings);

    _positionStream!.listen((Position position) {
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationMessage =
            'Latitude: ${position.latitude.toStringAsFixed(6)}\nLongitude: ${position.longitude.toStringAsFixed(6)}';
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // background hijau muda
      appBar: AppBar(
        backgroundColor: Colors.green[50], // hijau tua
        title: const Text('Tracking LBS'),
        // leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Lokasi Anda:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Text(
                  _locationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _checkPermissionsAndStartTracking,
              icon: const Icon(Icons.my_location),
              label: const Text('Perbarui Lokasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: (_latitude != null && _longitude != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(_latitude!, _longitude!),
                          zoom: 16.5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(_latitude!, _longitude!),
                                width: 50,
                                height: 50,
                                builder: (ctx) => const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.green)
                          : const Text('Lokasi belum tersedia'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
