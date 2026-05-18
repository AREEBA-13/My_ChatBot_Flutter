import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqService {
  final String apiKey;
  final String model;

  GroqService({
    String? apiKey,
    this.model = 'llama-3.3-70b-versatile', // High-speed, high-quality llama 3.3 model from Groq
  }) : apiKey = apiKey ?? dotenv.env['GROQ_API_KEY'] ?? '';

  /// Fetches a completion from the Groq API using the provided chat history.
  Future<String> getChatResponse(List<Map<String, String>> chatHistory) async {
    if (apiKey.isEmpty || apiKey == "YOUR_GROQ_API_KEY_HERE") {
      return "Error: Groq API Key is not configured. Please supply your valid Groq API key inside the .env file at the root of the chat_bot project directory.";
    }

    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final body = jsonEncode({
      "model": model,
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful, polite, and modern AI chatbot built with Flutter and VelocityX. Keep responses concise, clear, and highly engaging."
        },
        ...chatHistory,
      ],
      "temperature": 0.7,
      "max_tokens": 1024,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        return reply.toString().trim();
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          final errorMessage = errorBody['error']?['message'] ?? 'Unknown API error';
          return "Error (Status ${response.statusCode}): $errorMessage";
        } catch (_) {
          return "Error (Status ${response.statusCode}): ${response.reasonPhrase}";
        }
      }
    } catch (e) {
      return "Network Error: Failed to communicate with Groq API. ($e)";
    }
  }
}
