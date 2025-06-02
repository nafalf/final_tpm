import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://trefle.io/api/v1/plants';
  final String apiKey = 'kvmJfg_-uQdlZHZkjvPNNClDlGyrFekldnYy4szBd9g'; // Ganti dengan API Key kamu

  Future<List<dynamic>> fetchPlants({int page = 1, String query = ''}) async {
    final url = Uri.parse('$baseUrl?page=$page&token=$apiKey&filter[common_name]=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['data']; // daftar tanaman
    } else {
      throw Exception('Failed to load plants');
    }
  }

  Future<Map<String, dynamic>> fetchPlantDetail(String id) async {
    final url = Uri.parse('https://trefle.io/api/v1/plants/$id?token=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['data'];
    } else {
      throw Exception('Failed to load plant detail');
    }
  }

}
