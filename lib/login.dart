import 'package:chat_test/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_selector.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
          ),
          TextField(
            controller: password,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ChatSelector()));
                });
              },
              child: Text("Sign In")
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text("Sign Up")
          )
        ],
      ),
    );
  }
}
