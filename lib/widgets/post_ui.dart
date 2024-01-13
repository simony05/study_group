import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key});

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
                PostTitle(),
                TimePosted(),
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
                  TimeAndDate(),
                  Location(),
                  Attending(),
                ],
              ),
              ),
              Description(),

            ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Comments(),
                Join(),
              ]
            ),

          ],
        ),
      ),
    );
  }
}

class TimeAndDate extends StatelessWidget {
  const TimeAndDate({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class Location extends StatelessWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class Attending extends StatelessWidget {
  const Attending({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            Text('#', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class PostTitle extends StatelessWidget {
  const PostTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 6.5),
        child: Container(
          child: Text('Physics Study Group', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          //color: Colors.white,
          alignment: Alignment.centerLeft,
        )
    );
  }
}

class Join extends StatelessWidget {
  const Join({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: 100,
          height: 50,
          child: Container(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Join', style: TextStyle(color: Colors.white, fontSize: 15)),
              alignment: Alignment.center,
            ),
            margin: EdgeInsets.only(top: 10, right: 10, bottom: 10),
            alignment: Alignment.bottomRight,
          ),
        )
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 250,
        child: Container(
          child: Text('Comment...', textAlign: TextAlign.left, style: TextStyle(color: Colors.white)),
          margin: EdgeInsets.only(left: 5),
        ),
      ),
    );
  }
}

class TimePosted extends StatelessWidget {
  const TimePosted({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 6.5),
        child: Container(
            child: Text('Time', style: TextStyle(color: Colors.white),),
        ),
    );
  }
}






