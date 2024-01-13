import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class HostGroupView extends StatefulWidget {
  const HostGroupView({super.key});

  @override
  State<HostGroupView> createState() => _HostGroupViewState();
}

class _HostGroupViewState extends State<HostGroupView> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _time.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Host group"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              var uuid = Uuid();
              var v1 = uuid.v1();
              Map<String, dynamic> dataToSave = {
                'postId': v1,
                'subject': _subject.text,
                'time': _time.text,
                'description': _description.text,
                'attending': [],
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'uid': FirebaseAuth.instance.currentUser!.uid,
              };
              FirebaseFirestore.instance.collection('groups').doc(v1).set(dataToSave);
              _subject.clear();
              _time.clear();
              _description.clear();
            }, 
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    body: Column(
      children: [
        TextField(
          controller: _subject,
          decoration: const InputDecoration(
            hintText: 'Subject',
          ),
          maxLines: 1,
        ),
        TextField(
          controller: _time,
          decoration: const InputDecoration(
            hintText: 'Time',
          ),
          maxLines: 1,
        ),
        TextField(
          controller: _description,
          decoration: const InputDecoration(
            hintText: 'Description',
          ),
          maxLines: 4,
        ),
      ],
    ),
    );
  }
}