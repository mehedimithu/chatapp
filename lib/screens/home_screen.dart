import 'package:chatapp/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'char_screen.dart';

var signInWithEmailAndPassword = FirebaseAuth.instance.currentUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userMap;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setState(() {});
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore
        .collection('user')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String? chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // setState(() {
    //   if (isLoading = true){
    //     print('User not found');
    //   }else{
    //     isLoading = false;
    //   }
    // });

    await _firestore
        .collection('user')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
    print(userMap);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Chatapp'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.format_list_bulleted,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await authService.signOut();
              pref.remove("email");
            },
            child: Text(
              "Logout",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    _firebaseAuth.currentUser!.displayName!.toString().toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        label: Text('Chat room',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.chat),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? Center(child: Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      controller: _search,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Color(0xff2162AF),
                            size: 35,
                          ),
                          onPressed: () {},
                        ),
                        hintText: "Search by name",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: size.height / 50),
                userMap != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 9.0,
                                backgroundColor: userMap!['status'] == "Online"
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            title: Text(
                              userMap!['name'].toString().toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(userMap!['email']),
                            trailing: IconButton(
                              icon: Icon(Icons.chat),
                              onPressed: () {
                                String? roomId = chatRoomId(
                                    _firebaseAuth.currentUser!.displayName!,
                                    userMap!['name']);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Chat(
                                        chatRoomId: roomId!, userMap: userMap!),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
