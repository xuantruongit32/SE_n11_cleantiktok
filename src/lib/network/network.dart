import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  static final String baseUrl = 'https://tiktok-video-no-watermark2.p.rapidapi.com';
  static final String apiKey = 'bea33a1b7dmsh60b0fb4cf251173p136080jsn22179bcf65f0';
  static final String apiHost = 'tiktok-video-no-watermark2.p.rapidapi.com';

  static Future<Map<String, dynamic>> getUserPosts(String username, int count, String cursor) async {
    final url = Uri.parse('$baseUrl/user/posts?unique_id=@$username&count=$count&cursor=$cursor');
    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to get user posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}

