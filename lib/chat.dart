import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final DocumentReference docRef;

  const Chat({super.key, required this.docRef});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController message = TextEditingController();
  final db = FirebaseFirestore.instance;
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 80,
            child: FutureBuilder(
              future: widget.docRef.get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic>? chatData = snapshot.data.data();
                  if (chatData != null) { // Successfully loaded data
                    if (chatData['messages'] == null) {
                      return Text("No messages.");
                    }

                    return ListView.builder( // Displays all group members
                      itemCount: chatData['messages'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(chatData['messages'][index]['message']);
                      },
                    );
                  } else { // Problem loading data
                    return const Text("Error loading data");
                  }
                } else { // Loading data
                  return const Text("loading...");
                }
              },
            )
          ),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                TextField(
                  controller: message,
                ),
                ElevatedButton(
                    onPressed: () async {
                      List messages = [];

                      try {
                        print(((await widget.docRef.get()).data() as Map<String, dynamic>)['messages']);
                        messages = ((await widget.docRef.get()).data() as Map<String, dynamic>)['messages'];
                      } catch (exception) {
                        print(exception.toString());
                        //don't really need to do anything
                      }

                      messages.add(
                        {
                          'message': message.text,
                          'sender': myUid,
                          'time': DateTime.now().millisecondsSinceEpoch
                        }
                      );
                      setState(() {
                        widget.docRef.update({
                          'messages': messages
                        });
                      });
                    },
                    child: Text("Submit")
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
