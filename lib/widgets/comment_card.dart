import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
              MainAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              if (snap['uid'] != FirebaseAuth.instance.currentUser!.uid) Text(snap['name']),
            ],
          ),
          Row(
            mainAxisAlignment:
                (snap['uid'] == FirebaseAuth.instance.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: (snap['uid'] == FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    snap['text'],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    snap['timestamp']
                  ),
                ),
              ),
            const SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }
}