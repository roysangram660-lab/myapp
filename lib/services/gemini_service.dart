import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final _model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  Future<String> generateText(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response from model.';
    } catch (e) {
      return 'Error generating text: $e';
    }
  }
}
