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
          border: Border(
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
              offset: Offset(0, 3), // changes position of shadow
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
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 6.5),
                  child: Container(
                    child: Text(snap['subject'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    //color: Colors.white,
                    alignment: Alignment.centerLeft,
                  )
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 6.5),
                  child: Container(
                    child: Text(snap['time'], style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    height: 100,// <-- Fixed width.
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 102, 204, 0.5),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Time', style: TextStyle(color: Colors.white)),
                          Text('Date', style: TextStyle(color: Colors.white)),
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
                        color: Color.fromRGBO(0, 102, 204, 0.5),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Location', style: TextStyle(color: Colors.white)),
                          Text('Place', style: TextStyle(color: Colors.white)),
                        ],
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,// <-- Fixed width.
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 102, 204, 0.50),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Attending', style: TextStyle(color: Colors.white)),
                          Text('${snap['attending'].length}', style: TextStyle(color: Colors.white)),
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
                      color: Color.fromRGBO(0, 102, 204, 0.50),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        child: Text('Description:', style: TextStyle(color: Colors.white)),
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
                (snap['uid'] == FirebaseAuth.instance.currentUser!.uid) 
                ? IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute
                    (builder: (context) => CommentsView(postId: snap['postId'], hostName: snap['name']),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.red,
                  )
                )
                : Container(),
              ]
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

Future<void> deletePost(String postId) async {
  try {
    FirebaseFirestore.instance.collection('groups').doc(postId).delete();
  }
  catch (e) {
    print(e.toString());
  }
}

