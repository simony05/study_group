import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_group/widgets/comment_card.dart';
import 'package:uuid/uuid.dart';

class CommentsView extends StatefulWidget {
  final postId;
  final hostName;
  const CommentsView({super.key, required this.postId, required this.hostName});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController commentEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.hostName}'s Study Group",
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Send a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  var uuid = const Uuid();
                  var v1 = uuid.v1();
                  FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.postId)
                    .collection('comments')
                    .doc(v1)
                    .set({
                      'postId': v1,
                      'name': FirebaseAuth.instance.currentUser!.displayName,
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'text': commentEditingController.text,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    });
                    commentEditingController.clear();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> comment(String postId, String text, String uid, String name) async {
  try {
    if(text.isNotEmpty) {
      var uuid = const Uuid();
      var v1 = uuid.v1();
      FirebaseFirestore.instance
      .collection('groups')
      .doc(postId)
      .collection('comments')
      .doc(v1)
      .set({
        'name': name,
        'uid': uid,
        'text': text,
        'commentId': v1,
        'timestamp': DateTime.now(),
      });
    }
  }
  catch(e) {
    print(e.toString());
  }
  return "";
}