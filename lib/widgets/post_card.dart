import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_group/views/comments_view.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Row( 
            children: [
              Text(snap['name']),
              Text(snap['subject']),
              Text(snap['time']),
              Text(
                '${snap['attending'].length} attending',
              ),
            ],
          ),
          Text(snap['description']),
          Row(
            children: [
              IconButton(
                onPressed: () async { 
                  await attendingGroup(
                    snap['postId'],
                    FirebaseAuth.instance.currentUser!.uid,
                    snap['attending'],
                  ); 
                },
                icon: const Icon(
                  CupertinoIcons.checkmark_circle,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute
                  (builder: (context) => CommentsView(postId: snap['postId'], hostName: snap['name']),
                  ),
                ),
                icon: const Icon(
                  CupertinoIcons.ellipses_bubble,
                  color: Colors.green,
                )
              ),
              (snap['uid'] == FirebaseAuth.instance.currentUser!.uid) 
                ? IconButton(
                  onPressed: () async {
                    final shouldDeleteGroup = await deleteGroupDialog(context);
                    if (shouldDeleteGroup) {
                      deleteGroup(snap['postId']);
                    }
                  }
                    
                  ,
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.red,
                  )
                )
                : Container(),
            ],
          ),
          Text(
            DateFormat('MM/dd/yyyy, hh:mm a').format(
              DateTime.fromMillisecondsSinceEpoch(
                snap['timestamp']
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> attendingGroup(String postId, String uid, List attending) async {
  try {
    if (attending.contains(uid)) {
      await FirebaseFirestore.instance.collection('groups').doc(postId).update({
        'attending': FieldValue.arrayRemove([uid]),
      });
    }
    else {
      await FirebaseFirestore.instance.collection('groups').doc(postId).update({
        'attending': FieldValue.arrayUnion([uid]),
      });
    }
  }
  catch (e) {
    print(e.toString(),);
  }
}

Future<void> deleteGroup(String postId) async {
  try {
    FirebaseFirestore.instance.collection('groups').doc(postId).delete();
  }
  catch (e) {
    print(e.toString());
  }
}

Future<bool> deleteGroupDialog(BuildContext context) {
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this study group?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete')
          ),
        ]
      );
    },
  ).then((value) => value ?? false);
}