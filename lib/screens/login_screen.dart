import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 12),
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
                  SizedBox(height:10),
                  Text('Chit-Chat!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                  SizedBox(height: 18),
                  _buildEmailInput(),
                  _buildPasswordInput(),
                  _buildLoginAndSignuButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
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
        validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value!.trim(),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: TextFormField(
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
        validator: (value) =>
            value!.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  Widget _buildLoginAndSignuButton() {
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
          onPressed: () {},
        ),
      ),
    );
  }
}
