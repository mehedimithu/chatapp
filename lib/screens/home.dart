import 'package:chatapp/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var signInWithEmailAndPassword = FirebaseAuth.instance.currentUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(signInWithEmailAndPassword!.email.toString().trim()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await authService.signOut();
              pref.remove("email");
            },
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
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
                  fontSize: 17),
            ),
          ),

          //display messages
          Container(
              height: 500,
              child:
                  SingleChildScrollView(reverse: true, child: ShowMessages())),

          Container(
            height: 58,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              controller: mes,
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
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
                hintText: "Start writing here...",
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
            .orderBy("time")
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(x['messages']),
                          Text(
                            x['user'],
                            style: TextStyle(color: Colors.grey, fontSize: 10),
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
