import 'package:chatapp/screens/signup.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCnt = TextEditingController();
  final TextEditingController _passwordCnt = TextEditingController();

  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/img1.jpg'),
                    width: size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildEmailInput(_emailCnt),
                  _buildPasswordInput(_passwordCnt),
                  SizedBox(height: 5),
                  _buildLoginButton(authService),
                  _buildSignupBtn(),
                ],
              ),
            )
          ],
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
            hintText: "Email",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
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
            hintText: "Password",
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
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
          color: Colors.blue,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            authService.signInWithEmailAndPassword(
                _emailCnt.text, _passwordCnt.text);
            // if (_formKey.currentState!.validate()) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("Processing Data")),
            //   );
            // }
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
              style: TextStyle(color: Colors.amber, fontSize: 13),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        });
  }
}
