import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> chatCompletion(String content) async {
  //const url = 'http://localhost:5000/chat'; // IOS
  //const url = 'http://10.0.2.2:5000/chat'; Android
  const url = "http://34.125.68.62/chat";
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'content': content}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['response'];
  } else {
    throw Exception('Failed to get response from the server.');
  }
}