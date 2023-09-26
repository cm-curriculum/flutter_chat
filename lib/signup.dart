import 'package:chat_test/chat_selector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
          ),
          TextField(
            controller: name,
          ),
          TextField(
            controller: password,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value) {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  db.collection('users').doc(uid).set(
                    {
                      'email': email.text,
                      'name': name.text,
                      'uid': uid
                    }
                  ).then((value) {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatSelector()));
                  });
                });
              },
              child: Text("Sign Up")
          )
        ],
      ),
    );
  }
}
