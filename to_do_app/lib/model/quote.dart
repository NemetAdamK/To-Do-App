import 'dart:convert';
import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] ?? '',
      author: json['author'] ?? '',
    );
  }
}

Future<List<Quote>> fetchQuotes() async {
  final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
  
  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((quote) => Quote.fromJson(quote)).toList();
  } else {
    throw Exception('Failed to load quotes');
  }
}
