import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  Chat({required this.chatRoomId, required this.userMap});

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String chatRoomId;
  final Map<String, dynamic> userMap;
  final TextEditingController _chat = TextEditingController();

  void onSendMessage() {
    if (_chat.text.isNotEmpty) {
      _firestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection('chats')
          .add({
        "sendby": _firebaseAuth.currentUser!.displayName!.trim(),
        "message": _chat.text.trim(),
        "time": DateTime.now(),
      });
      _chat.clear();
    } else {
      print('Write something!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user")
              .doc(userMap['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap['name']),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.videocam,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Text(
              "Messages",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
          ),

          //display messages
          Expanded(
            child: Container(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                reverse: true,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          shrinkWrap: true,
                          primary: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            Map<String, dynamic> map = snapshot.data!.docs[i]
                                .data() as Map<String, dynamic>;
                            return messages(size, map);
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            width: size.width,
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: _chat,
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.attach_file,
                    color: Colors.grey,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: onSendMessage,
                ),
                hintText: "Start typing here..",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      // height: size.height,
      alignment: map['sendby'] == _firebaseAuth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: map['sendby'] == _firebaseAuth.currentUser!.displayName
              ? Colors.lightGreenAccent.withOpacity(0.2)
              : Colors.blueAccent.withOpacity(0.2),
          borderRadius: map['sendby'] == _firebaseAuth.currentUser!.displayName
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),

          // borderRadius: BorderRadius.circular(15),
          // color: Colors.blue,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            map['message'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            map['time'].toDate().toString(),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ]),
      ),
    );
  }
}
