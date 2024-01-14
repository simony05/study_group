import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_group/widgets/post_ui.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 102, 204, 0.50),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Find a study group',
          style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('groups')
          //.where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Post(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}