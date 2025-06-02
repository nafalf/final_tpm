import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  final List<String> developerSuggestions = const [
    "Jangan terlalu sulit",
    "Kesan sangat menantang",
    "Berikan feedback yang membangun",
    "Jaga konsistensi dalam penggunaan fitur",
    "Pastikan UI mudah digunakan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran dan Kesan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: developerSuggestions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(developerSuggestions[index]),
            );
          },
        ),
      ),
    );
  }
}
