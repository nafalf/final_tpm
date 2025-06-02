import 'package:flutter/material.dart';
import 'package:final_tpm/services/api_service.dart';
import 'package:hive/hive.dart';
import 'package:final_tpm/models/plant.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? plantDetail;
  bool isLoading = true;
  bool isFavorite = false;
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box('favoritesBox');
    fetchPlantDetail();
  }

  Future<void> fetchPlantDetail() async {
    try {
      final detail = await apiService.fetchPlantDetail(widget.id);
      setState(() {
        plantDetail = detail;
        isLoading = false;
      });

      final favoritePlant = favoritesBox.get(widget.id);
      setState(() {
        isFavorite = favoritePlant != null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal load detail: $e')));
      }
    }
  }

  void toggleFavorite() {
    if (isFavorite) {
      favoritesBox.delete(widget.id);
    } else {
      if (plantDetail != null) {
        final plant = Plant(
          id: widget.id,
          scientificName: plantDetail!['scientific_name'] ?? '',
          commonName: plantDetail!['common_name'] ?? '',
          imageUrl: plantDetail!['image_url'],
          distribution: plantDetail!['distribution'],
          growth: plantDetail!['growth']?.toString(),
          conservationStatus:
              plantDetail!['conservation_status']?['name'] ?? 'Tidak ada data',
          bibliography: null,
        );
        favoritesBox.put(widget.id, plant);
      }
    }
    setState(() {
      isFavorite = !isFavorite;
    });

    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Ditambahkan ke favorit!' : 'Dihapus dari favorit!'),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildInfoCard(String label, dynamic value, IconData icon) {
    if (value == null) return const SizedBox.shrink();
    if (value is String && value.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? genusName;
    String? genusSlug;
    String? genusFamilies;

    if (plantDetail != null && plantDetail!['genus'] != null) {
      final genus = plantDetail!['genus'];
      if (genus is Map<String, dynamic>) {
        genusName = genus['name'];
        genusSlug = genus['slug'];

        final families = genus['families'];
        if (families is List<dynamic>) {
          genusFamilies = families.map((f) => f['name'] ?? '').where((name) => name.isNotEmpty).join(', ');
        } else if (families is Map<String, dynamic>) {
          genusFamilies = families['name'] ?? '';
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        title: Text(
          plantDetail?['common_name'] ?? 'Detail Tanaman',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green[600]),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat detail tanaman...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : plantDetail == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Data tidak ditemukan',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Hero Image Section with Plant Icon
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.green[600]!, Colors.green[400]!],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background pattern
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.1,
                                child: Image.asset(
                                  'assets/plant_pattern.png', // You can add a subtle plant pattern
                                  repeat: ImageRepeat.repeat,
                                ),
                              ),
                            ),
                            // Plant Icon (replacing flower pot image)
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_florist,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Content Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Price Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plantDetail!['common_name'] ?? 'Nama Tidak Diketahui',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        plantDetail!['scientific_name'] ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Price badge (decorative)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green[600],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Native',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Description section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green[200]!),
                              ),
                              child: Text(
                                'Tanaman cantik yang tumbuh alami di berbagai wilayah. Memiliki keunikan tersendiri dan mudah untuk dirawat. Cocok untuk menghiasi rumah atau taman Anda.',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  height: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Plant Details
                            _buildInfoCard('Nama Umum', plantDetail!['common_name'], Icons.label),
                            _buildInfoCard('Nama Ilmiah', plantDetail!['scientific_name'], Icons.science),
                            _buildInfoCard('Famili', plantDetail!['family_common_name'], Icons.account_tree),
                            if (genusName != null) _buildInfoCard('Nama Genus', genusName, Icons.category),
                            if (genusSlug != null) _buildInfoCard('Slug', genusSlug, Icons.tag),
                            if (genusFamilies != null && genusFamilies.isNotEmpty)
                              _buildInfoCard('Genus Families', genusFamilies, Icons.family_restroom),
                            _buildInfoCard('Wilayah Penyebaran', plantDetail!['distribution'], Icons.public),
                            _buildInfoCard('Status Konservasi', plantDetail!['conservation_status']?['name'], Icons.security),
                            _buildInfoCard('Pertumbuhan', plantDetail!['growth']?.toString(), Icons.trending_up),
                            
                            const SizedBox(height: 30),
                            
                            // Add to Favorite Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: toggleFavorite,
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFavorite ? Colors.red[500] : Colors.green[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}