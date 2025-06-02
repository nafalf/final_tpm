import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:final_tpm/models/plant.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box('favoritesBox');
  }

  void removeFavorite(String id) {
    favoritesBox.delete(id);
    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final plants = favoritesBox.values.cast<Plant>().toList();

    return Scaffold(
      backgroundColor: Colors.green[50], // Background hijau muda
      appBar: AppBar(
        title: const Text('Tanaman Favorit'),
        backgroundColor: Colors.green[800], // Hijau tua
      ),
      body: plants.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tanaman favorit',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: plant.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              plant.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.local_florist,
                            size: 50,
                            color: Colors.green,
                          ),
                    title: Text(
                      plant.commonName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      plant.scientificName,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFavorite(plant.id),
                      tooltip: 'Hapus dari favorit',
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: plant.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
