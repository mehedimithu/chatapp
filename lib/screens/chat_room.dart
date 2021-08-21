import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var signInWithEmailAndPassword = FirebaseAuth.instance.currentUser;

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Map<String, dynamic>? userMap;

  final storeMessage = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController mes = TextEditingController();

  getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      signInWithEmailAndPassword = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(signInWithEmailAndPassword!.displayName.toString().trim()),
            Text(signInWithEmailAndPassword!.email.toString().trim(),
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
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
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.videocam,
              color: Colors.white,
              size: 20,
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:
                  SingleChildScrollView(reverse: true, child: ShowMessages()),
            ),
          ),

          Container(
            height: 58,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: mes,
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
                    color: Colors.green,
                  ),
                  onPressed: () {
                    if (mes.text.isNotEmpty) {
                      storeMessage.collection("Messages").doc().set({
                        "messages": mes.text.trim(),
                        "user":
                            signInWithEmailAndPassword!.email.toString().trim(),
                        "time": DateTime.now(),
                      });
                      mes.clear();
                    }
                  },
                ),
                hintText: "Start typing here..",
                // hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              primary: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return ListTile(
                  title: Column(
                    crossAxisAlignment:
                        signInWithEmailAndPassword!.email == x['user']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: signInWithEmailAndPassword!.email == x['user']
                              ? Colors.lightGreenAccent.withOpacity(0.1)
                              : Colors.blueAccent.withOpacity(0.2),
                          borderRadius:
                              signInWithEmailAndPassword!.email == x['user']
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(23),
                                      topRight: Radius.circular(23),
                                      bottomLeft: Radius.circular(23))
                                  : BorderRadius.only(
                                      topLeft: Radius.circular(23),
                                      topRight: Radius.circular(23),
                                      bottomRight: Radius.circular(23)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(x['messages']),
                              Text(
                                x['time'].toDate().toString(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(
                                x['user'],
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ]),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
