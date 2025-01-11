import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_group/views/comments_view.dart';

class Post extends StatelessWidget {
  final snap;
  const Post({super.key, required this.snap});


  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(
            right: BorderSide( //                   <--- left side
              color: Colors.white,
              width: 3.0,
            ),
            bottom: BorderSide( //                    <--- top side
              color: Colors.white,
              width: 3.0,
            ),
            left: BorderSide( //                   <--- left side
              color: Colors.white,
              width: 1.5,
            ),
            top: BorderSide( //                    <--- top side
              color: Colors.white,
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.75),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.black,
        ),
        height: 300,
        //color: Color.fromRGBO(98, 181, 120, 0.5),
        //alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6.5),
                  child: Container(
                    //color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Text(snap['subject'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6.5),
                  child: Text(
                    'Posted by ${snap['name']} on ${DateFormat('MM/dd').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      snap['timestamp']
                    ),)}'
                 , style: const TextStyle(color: Colors.white, fontSize: 10.0),),
                ),
              ],
            ),
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 100,// <-- Fixed width.
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 102, 204, 0.5),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(snap['time'], style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      //color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,// <-- Fixed width.
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 102, 204, 0.5),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(snap['location'], style: const TextStyle(color: Colors.white)),
                         
                        ],
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,// <-- Fixed width.
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 102, 204, 0.50),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Attending', 
                            style: TextStyle(color: Colors.white)),
                          Text(
                            '${snap['attending'].length}', 
                            style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
              SizedBox(
                height: 80,
                width: 340,
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 102, 204, 0.50),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          const Text('Description:', style: TextStyle(color: Colors.white)),
                          Text(snap['description']
                          , style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  },
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.red,
                  )
                )
                : Container(),
            ],
            ),

          ],
        ),
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