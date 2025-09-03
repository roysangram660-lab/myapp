
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityRoomsScreen extends StatelessWidget {
  const CommunityRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/community/new');
            },
            tooltip: 'Create Room',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('community_rooms').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rooms = snapshot.data!.docs;

          if (rooms.isEmpty) {
            return const Center(
              child: Text('No rooms yet. Be the first to create one!'),
            );
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final roomName = room['name'] ?? 'Untitled Room';
              final roomId = room.id;

              return ListTile(
                title: Text(roomName),
                leading: const Icon(Icons.group),
                onTap: () {
                  context.go('/community/room/$roomId');
                },
              );
            },
          );
        },
      ),
    );
  }
}
