import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const apiKey ='paste-your-api-key';


  static Future<String> analyzeResume(String resumeText) async {
    try {
      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": """
You are a professional AI Resume Analyzer.

Analyze this resume professionally.

Return response ONLY in this exact format:

ATS Score: X/100

Key strengths:
- point
- point
- point

Suggestions for improvement:
- point
- point
- point

Best suited job roles:
- role
- role
- role

Resume:
$resumeText
"""
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      return data['choices'][0]['message']['content'];
    } catch (e) {
      return 'Error: $e';
    }
  }
}