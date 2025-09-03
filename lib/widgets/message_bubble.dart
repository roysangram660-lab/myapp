import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String sender;
  final DateTime? timestamp;

  const MessageBubble({
    super.key,
    required this.isMe,
    required this.text,
    required this.sender,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: isMe
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  DateFormat.jm().format(timestamp!),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary.withAlpha(178)
                        : Theme.of(context).colorScheme.onSecondary.withAlpha(178),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
