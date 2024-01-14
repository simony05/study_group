import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_group/widgets/post_ui.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {
    bool host = true;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 102, 204, 0.50),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            FirebaseAuth.instance.currentUser!.displayName ?? "Unnamed",
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          children: [
            const Divider(
              height: 8,
              thickness: 4,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              TextButton(child: const Text('My Study Groups') ,  onPressed: () {
                host = true;
                TextButton.styleFrom(
                  foregroundColor: host == true ? Colors.blue : Colors.white);

              },),
              ]
            ),
            Container(
              child:
                StreamBuilder(
                  stream: (host == true)
                  ? FirebaseFirestore.instance
                    .collection('groups')
                    .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots()
                  : FirebaseFirestore.instance
                    .collection('groups')
                    .where('attending', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.length == 0) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Post(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                )
              )
            ],
        ),
      ),
    );
  }
}