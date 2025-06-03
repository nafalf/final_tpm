import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SaranPage extends StatefulWidget {
  const SaranPage({super.key});

  @override
  State<SaranPage> createState() => _SaranPageState();
}

class _SaranPageState extends State<SaranPage> {
  // === CONSTANTS === //
  static const Color _primaryColor = Color(0xFF4CAF50);
  static const Color _backgroundColor = Color(0xFFF1F8E9);
  static const Color _textColor = Color(0xFF2E7D32);

  // === STATE VARIABLES === //
  List<Map<String, dynamic>> _kesanMatKul = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // === SHARED PREFERENCES METHODS === //
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? dataString = prefs.getString('kesan_matkul_data');
      
      if (dataString != null) {
        final List<dynamic> jsonData = json.decode(dataString);
        setState(() {
          _kesanMatKul = jsonData.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _kesanMatKul = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _kesanMatKul = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String dataString = json.encode(_kesanMatKul);
      await prefs.setString('kesan_matkul_data', dataString);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // === CRUD METHODS === //
  Future<void> _addNewSection() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _SectionDialog(),
    );

    if (result != null) {
      setState(() {
        _kesanMatKul.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': result['title'],
          'icon': result['icon'],
          'color': result['color'],
          'items': <String>[],
        });
      });
      await _saveData();
    }
  }

  Future<void> _editSection(int index) async {
    final section = _kesanMatKul[index];
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _SectionDialog(
        initialTitle: section['title'],
        initialIcon: section['icon'],
        initialColor: section['color'],
      ),
    );

    if (result != null) {
      setState(() {
        _kesanMatKul[index] = {
          ..._kesanMatKul[index],
          'title': result['title'],
          'icon': result['icon'],
          'color': result['color'],
        };
      });
      await _saveData();
    }
  }

  Future<void> _deleteSection(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Bagian'),
        content: Text('Apakah Anda yakin ingin menghapus "${_kesanMatKul[index]['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _kesanMatKul.removeAt(index);
      });
      await _saveData();
    }
  }

  Future<void> _addNewItem(int sectionIndex) async {
    final TextEditingController controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Item Baru'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan teks item...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _kesanMatKul[sectionIndex]['items'].add(result);
      });
      await _saveData();
    }
  }

  Future<void> _editItem(int sectionIndex, int itemIndex) async {
    final TextEditingController controller = TextEditingController(
      text: _kesanMatKul[sectionIndex]['items'][itemIndex],
    );
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _kesanMatKul[sectionIndex]['items'][itemIndex] = result;
      });
      await _saveData();
    }
  }

  Future<void> _deleteItem(int sectionIndex, int itemIndex) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _kesanMatKul[sectionIndex]['items'].removeAt(itemIndex);
      });
      await _saveData();
    }
  }

  // === ICON HELPER === //
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'message':
        return Icons.message;
      case 'favorite':
        return Icons.favorite;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'school':
        return Icons.school;
      case 'book':
        return Icons.book;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.info;
    }
  }

  Color _getColorData(String colorName) {
    switch (colorName) {
      case 'amber':
        return Colors.amber;
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.green;
    }
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewSection,
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _kesanMatKul.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        if (_kesanMatKul.isNotEmpty) _buildWelcomeMessage(),
                        const SizedBox(height: 30),
                        ..._kesanMatKul.asMap().entries.map((entry) {
                          final index = entry.key;
                          final section = entry.value;
                          return _buildSection(section, index);
                        }),
                        const SizedBox(height: 80), // Space for FAB
                      ],
                    ),
                  ),
      ),
    );
  }

  // === EMPTY STATE === //
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 80,
            color: Colors.green[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada saran atau kesan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.green[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah bagian baru',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[400],
            ),
          ),
        ],
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
  Widget _buildSection(Map<String, dynamic> section, int sectionIndex) {
    final String title = section['title'];
    final String iconName = section['icon'];
    final String colorName = section['color'];
    final List<String> items = List<String>.from(section['items']);

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title, iconName, colorName, sectionIndex),
          const SizedBox(height: 16),
          _buildSectionItems(items, sectionIndex),
          _buildAddItemButton(sectionIndex),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconName, String colorName, int sectionIndex) {
    final IconData icon = _getIconData(iconName);
    final Color color = _getColorData(colorName);

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
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editSection(sectionIndex);
                  break;
                case 'delete':
                  _deleteSection(sectionIndex);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItems(List<String> items, int sectionIndex) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            'Belum ada item dalam bagian ini',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildSectionItem(item, sectionIndex, index);
      }).toList(),
    );
  }

  Widget _buildSectionItem(String item, int sectionIndex, int itemIndex) {
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
              child: Row(
                children: [
                  Expanded(
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
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _editItem(sectionIndex, itemIndex);
                          break;
                        case 'delete':
                          _deleteItem(sectionIndex, itemIndex);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemButton(int sectionIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: () => _addNewItem(sectionIndex),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.green[200]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.green[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tambah Item',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === SECTION DIALOG === //
class _SectionDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialIcon;
  final String? initialColor;

  const _SectionDialog({
    this.initialTitle,
    this.initialIcon,
    this.initialColor,
  });

  @override
  _SectionDialogState createState() => _SectionDialogState();
}

class _SectionDialogState extends State<_SectionDialog> {
  late TextEditingController _titleController;
  String _selectedIcon = 'star';
  String _selectedColor = 'amber';

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'star', 'icon': Icons.star},
    {'name': 'lightbulb', 'icon': Icons.lightbulb},
    {'name': 'message', 'icon': Icons.message},
    {'name': 'favorite', 'icon': Icons.favorite},
    {'name': 'thumb_up', 'icon': Icons.thumb_up},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'book', 'icon': Icons.book},
    {'name': 'quiz', 'icon': Icons.quiz},
  ];

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'amber', 'color': Colors.amber},
    {'name': 'orange', 'color': Colors.orange},
    {'name': 'blue', 'color': Colors.blue},
    {'name': 'red', 'color': Colors.red},
    {'name': 'purple', 'color': Colors.purple},
    {'name': 'teal', 'color': Colors.teal},
    {'name': 'pink', 'color': Colors.pink},
    {'name': 'indigo', 'color': Colors.indigo},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _selectedIcon = widget.initialIcon ?? 'star';
    _selectedColor = widget.initialColor ?? 'amber';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? 'Tambah Bagian Baru' : 'Edit Bagian'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Bagian',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Icon:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _iconOptions.map((option) {
                final isSelected = _selectedIcon == option['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = option['name'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[100] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      option['icon'],
                      color: isSelected ? Colors.green : Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Warna:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((option) {
                final isSelected = _selectedColor == option['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = option['name'];
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: option['color'],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.trim().isNotEmpty) {
              Navigator.of(context).pop({
                'title': _titleController.text.trim(),
                'icon': _selectedIcon,
                'color': _selectedColor,
              });
            }
          },
          child: Text(widget.initialTitle == null ? 'Tambah' : 'Simpan'),
        ),
      ],
    );
  }
}