import 'package:flutter/material.dart';
import 'package:myapp/services/gemini_service.dart';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  final _promptController = TextEditingController();
  final _geminiService = GeminiService();
  String _response = '';
  bool _isLoading = false;

  Future<void> _generateText() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    final response = await _geminiService.generateText(_promptController.text);

    setState(() {
      _response = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Enter a prompt',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateText,
              child: const Text('Generate Text'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_response),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
