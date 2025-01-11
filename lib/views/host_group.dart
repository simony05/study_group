import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_group/constants/routes.dart';
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
  final TextEditingController _location = TextEditingController();

  @override
  void dispose() {
    _subject.dispose();
    _time.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 102, 204, 0.50),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Host a group",
          style: TextStyle(color: Colors.white),),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              var uuid = const Uuid();
              var v1 = uuid.v1();
              Map<String, dynamic> dataToSave = {
                'postId': v1,
                'subject': _subject.text,
                'time': _time.text,
                'description': _description.text,
                'attending': [],
                'location': _location.text,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'uid': FirebaseAuth.instance.currentUser!.uid,
              };
              FirebaseFirestore.instance.collection('groups').doc(v1).set(dataToSave);
              _subject.clear();
              _time.clear();
              _description.clear();
              _location.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                homeRoute, 
                (_) => false,
              );
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
    body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
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
              hintText: 'Time - Day',
            ),
            maxLines: 1,
          ),
          TextField(
            controller: _location,
            decoration: const InputDecoration(
              hintText: 'Location',
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
    ),
    );
  }
}