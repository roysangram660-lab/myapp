import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/chat_service.dart';

class NewCommunityRoomScreen extends StatefulWidget {
  const NewCommunityRoomScreen({super.key});

  @override
  State<NewCommunityRoomScreen> createState() => _NewCommunityRoomScreenState();
}

class _NewCommunityRoomScreenState extends State<NewCommunityRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _createRoom() async {
    if (_formKey.currentState!.validate()) {
      final chatService = Provider.of<ChatService>(context, listen: false);
      final roomName = _roomNameController.text;

      try {
        final roomId = await chatService.createCommunityRoom(roomName);
        if (!mounted) return;
        // Navigate to the newly created room
        context.go('/community/room/$roomId');
      } catch (e) {
        if (!mounted) return;
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create room: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _roomNameController,
                decoration: const InputDecoration(labelText: 'Room Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a room name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createRoom,
                child: const Text('Create Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
