import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCnt = TextEditingController();
  final TextEditingController _passwordCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        reverse: true,
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/img3.jpg'),
                  radius: 80,
                ),
                SizedBox(height: 15),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                _buildEmailInput(_emailCnt),
                _buildPasswordInput(_passwordCnt),
                SizedBox(height: 5),
                _buildLoginButton(authService),
                _buildSignupBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput(TextEditingController _emailCnt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
          controller: _emailCnt,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
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
                Icons.mail,
                color: Color(0xff2162AF),
              ),
              onPressed: () {},
            ),
            hintText: "Email",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email address can\'t be empty';
            }
            return null;
          }),
    );
  }

  Widget _buildPasswordInput(TextEditingController _passwordCnt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
          controller: _passwordCnt,
          maxLines: 1,
          obscureText: true,
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
                Icons.lock,
                color: Color(0xff2162AF),
              ),
              onPressed: () {},
            ),
            hintText: "Password",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password can\'t be empty';
            }
            return null;
          }),
    );
  }

  Widget _buildLoginButton(authService) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.redAccent,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            if (_emailCnt.text.isNotEmpty && _passwordCnt.text.isNotEmpty) {
              authService.signInWithEmailAndPassword(
                  _emailCnt.text, _passwordCnt.text);
              pref.setString("email", _emailCnt.text);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Message"),
                      content: Text("Enter valid email and password"),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return FlatButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?\t',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            Text(
              'Signup',
              style: TextStyle(color: Colors.blue, fontSize: 13),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        });
  }
}
