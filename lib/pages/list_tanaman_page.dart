import 'package:flutter/material.dart';
import 'package:final_tpm/services/api_service.dart';

class ListTanamanPage extends StatefulWidget {
  const ListTanamanPage({super.key});

  @override
  State<ListTanamanPage> createState() => _ListTanamanPageState();
}

class _ListTanamanPageState extends State<ListTanamanPage> {
  final ApiService apiService = ApiService();
  List<dynamic> plants = [];
  bool isLoading = false;
  int currentPage = 1;
  String query = '';

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    setState(() => isLoading = true);

    try {
      final result = await apiService.fetchPlants(page: currentPage, query: query);
      setState(() {
        plants = result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading plants: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void onSearch() {
    currentPage = 1;
    query = searchController.text.trim();
    fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tanaman'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                labelText: 'Cari tanaman',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      final commonName = plant['common_name'] ?? 'No Name';
                      final scientificName = plant['scientific_name'] ?? '';
                      final imageUrl = plant['image_url'];

                      return ListTile(
                        leading: imageUrl != null
                            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.local_florist),
                        title: Text(commonName),
                        subtitle: Text(scientificName),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail', arguments: plant['id'].toString());
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
