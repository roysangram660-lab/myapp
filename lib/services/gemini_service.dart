import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final _textModel = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  final _visionModel = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  Future<String> generateText(String prompt) async {
    try {
      final response = await _textModel.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response from model.';
    } catch (e) {
      return 'Error generating text: $e';
    }
  }

  Future<String> analyzeImage(String prompt, Uri imageUri) async {
    try {
      final content = Content.multi([
        TextPart(prompt),
        DataPart.fromUri(imageUri, 'image/jpeg'),
      ]);

      final response = await _visionModel.generateContent([content]);
      return response.text ?? 'No analysis result.';
    } catch (e) {
      return 'Error analyzing image: $e';
    }
  }
}
