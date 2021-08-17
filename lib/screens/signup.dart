import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCnt = TextEditingController();
  final TextEditingController _emailCnt = TextEditingController();
  final TextEditingController _passwordCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/img2.png'),
                radius: 50,
              ),
              SizedBox(height: 5),
              Text(
                'Registration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 13),
              _buildNameInput(_nameCnt),
              _buildEmailInput(_emailCnt),
              _buildPasswordInput(_passwordCnt),
              SizedBox(height: 10),
              _buildSignupButton(authService),
              SizedBox(height: 10),
              textButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInput(TextEditingController _nameCnt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _nameCnt,
        maxLines: 1,
        keyboardType: TextInputType.name,
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
              Icons.person,
              color: Color(0xff2162AF),
            ),
            onPressed: () {},
          ),
          hintText: "Enter name",
        ),
        // validator: (value) => value!.isEmpty ? 'Name can\'t be empty' : null,
        // onSaved: (value) => _name = value!.trim(),
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
        // validator: (value) => value!.isEmpty ? 'Email can\'t be empty' : null,
        // onSaved: (value) => _email = value!.trim(),
      ),
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
        // validator: (value) =>
        //     value!.isEmpty ? 'Password can\'t be empty' : null,
        // onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  Widget _buildSignupButton(authService) {
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
            'Signup',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            if (_emailCnt.text.isNotEmpty && _passwordCnt.text.isNotEmpty) {
              await authService.createUserWithEmailAndPassword(
                  _emailCnt.text, _passwordCnt.text);
              Navigator.pushNamed(context, '/login');

              pref.setString("email", _emailCnt.text);
            } else {
              print("Noted");
            }
          },
        ),
      ),
    );
  }
}

class textButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Already have an account."));
  }
}
