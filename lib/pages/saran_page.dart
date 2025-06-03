import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  // === CONSTANTS === //
  static const Color _primaryColor = Color(0xFF4CAF50);
  static const Color _backgroundColor = Color(0xFFF1F8E9); 
  static const Color _textColor = Color(0xFF2E7D32);

  static const List<Map<String, dynamic>> _kesanMatKul = [
    {
      'title': 'Kesan Mata Kuliah',
      'icon': Icons.star,
      'color': Colors.amber,
      'items': [
        "Mata kuliah ini sangat menarik tetapi melelahkan",
        "Banyak sekali materi yang bermanfaat",
        "Pengajar sangat inspiratif",
        "Praktikum yang diberikan sangat membantu pemahaman konsep",
        "Mata kuliah ini menantang tapi sangat worth it!",
        "Banyak insight baru yang didapat dari setiap pertemuan",
      ]
    },
    {
      'title': 'Saran untuk Mata Kuliah',
      'icon': Icons.lightbulb,
      'color': Colors.orange,
      'items': [
        "Semoga jadwal praktikum bisa lebih fleksibel",
        "Akan sangat membantu jika ada tutorial video tambahan",
        "Bisa ditambahkan forum diskusi online untuk sharing",
        "Semoga referensi buku bisa lebih beragam dan up-to-date",
      ]
    },
    {
      'title': 'Pesan untuk Mahasiswa Selanjutnya',
      'icon': Icons.message,
      'color': Colors.blue,
      'items': [
        "Jangan takut untuk bertanya saat ada yang tidak dipahami!",
        "Manfaatkan setiap kesempatan praktikum dengan maksimal",
        "Rajin-rajin baca referensi dan explore lebih dalam",
        "Jangan menyerah ketika menghadapi tugas yang sulit",
        "Enjoy the process, karena masa kuliah tidak akan terulang!"
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  // === HEADER SECTION === //
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saran & Kesan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Refleksi Perjalanan Mata Kuliah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              _buildHeaderIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.school,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          // Add functionality if needed
        },
      ),
    );
  }

  // === CONTENT SECTION === //
  Widget _buildContent() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildWelcomeMessage(),
              const SizedBox(height: 30),
              ..._kesanMatKul.map(_buildSection),
              _buildFooterMessage(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // === WELCOME MESSAGE === //
  Widget _buildWelcomeMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.emoji_emotions,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Terima Kasih Atas Perjalanan\nyang Luar Biasa!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // === SECTION BUILDER === //
  Widget _buildSection(Map<String, dynamic> section) {
    final String title = section['title'];
    final IconData icon = section['icon'];
    final Color color = section['color'];
    final List<String> items = List<String>.from(section['items']);

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title, icon, color),
          const SizedBox(height: 16),
          _buildSectionItems(items),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItems(List<String> items) {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildSectionItem(item, index);
      }).toList(),
    );
  }

  Widget _buildSectionItem(String item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, right: 16),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.green.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 15,
                  color: _textColor,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === FOOTER MESSAGE === //
  Widget _buildFooterMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green[200]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            size: 36,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Semoga mata kuliah ini terus berkembang dan memberikan manfaat yang lebih besar lagi di masa depan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}