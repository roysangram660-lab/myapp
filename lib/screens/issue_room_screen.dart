import 'package:flutter/material.dart';

class IssueRoomScreen extends StatelessWidget {
  const IssueRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Rooms'),
      ),
      body: const Center(
        child: Text('Issue Room Screen'),
      ),
    );
  }
}
