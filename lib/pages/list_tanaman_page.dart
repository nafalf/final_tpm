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
          SnackBar(
            content: Text('Error loading plants: $e'),
            backgroundColor: Colors.red[600],
          ),
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

  void clearSearch() {
    searchController.clear();
    query = '';
    currentPage = 1;
    fetchPlants();
  }

  Widget _buildPlantCard(dynamic plant, int index) {
    final commonName = plant['common_name'] ?? 'No Name';
    final scientificName = plant['scientific_name'] ?? '';
    final imageUrl = plant['image_url'];

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
        top: index == 0 ? 8 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: plant['id'].toString());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Plant Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green[50],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.green[50],
                                child: Icon(
                                  Icons.local_florist,
                                  color: Colors.green[300],
                                  size: 32,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.green[50],
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Icon(
                            Icons.local_florist,
                            color: Colors.green[300],
                            size: 32,
                          ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Plant Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commonName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (scientificName.isNotEmpty)
                        Text(
                          scientificName,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Native Plant',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      body: Column(
        children: [
          // Custom Header (menggantikan AppBar default)
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Daftar Tanaman',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (_) => onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Cari tanaman...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[500]),
                              onPressed: clearSearch,
                            )
                          : IconButton(
                              icon: Icon(Icons.search, color: Colors.green[600]),
                              onPressed: onSearch,
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.green[600]),
                        const SizedBox(height: 16),
                        Text(
                          'Memuat daftar tanaman...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : plants.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              query.isEmpty ? 'Tidak ada tanaman' : 'Tanaman tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (query.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: clearSearch,
                                child: Text(
                                  'Reset Pencarian',
                                  style: TextStyle(color: Colors.green[600]),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.green[600],
                        onRefresh: fetchPlants,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          itemCount: plants.length,
                          itemBuilder: (context, index) {
                            return _buildPlantCard(plants[index], index);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}