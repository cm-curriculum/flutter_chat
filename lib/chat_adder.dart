import 'package:chat_test/chat_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatAdder extends StatefulWidget {
  const ChatAdder({super.key});

  @override
  State<ChatAdder> createState() => _ChatAdderState();
}

class _ChatAdderState extends State<ChatAdder> {
  TextEditingController email = new TextEditingController();
  String uidOfSearchedUser = "";
  List<Map<String, dynamic>> members = [];
  final db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _loadUser() async {
    final db = FirebaseFirestore.instance;
    return (await db.collection("users").doc(uidOfSearchedUser).get()).data();
  }

  Future<void> createInvites() async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    List<String> memberUids = [];
    List<String> memberUidsWithOwner = [];
    for (Map<String, dynamic> entry in members) {
      memberUids.add(entry['uid']);
      memberUidsWithOwner.add(entry['uid']);
    }
    memberUidsWithOwner.add(myUid);

    var chatDocRef = await db.collection('chats').add(
      {
        'members': memberUidsWithOwner
      }
    );

    var createdInvite = await db.collection('invites').add(
      {
        'sender': myUid,
        'recipients': memberUids,
        'members': memberUidsWithOwner,
        'chat_ref': chatDocRef
      }
    );

    var chatRef = await db.collection('chat_keys').add(
      {
        'ref': chatDocRef,
        'user': myUid
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Adder"),
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
            onChanged: (String changed) {
              db.collection('users').where('email', isEqualTo: changed).get().then((querySnapshot) {
                if (querySnapshot.docs.isEmpty) {
                  return;
                } else {
                  QueryDocumentSnapshot<Map<String, dynamic>> result = querySnapshot.docs[0];
                  Map<String, dynamic> resultUser = result.data();
                  setState(() {
                    uidOfSearchedUser = resultUser['uid'];
                  });
                }
              });
            },
          ),
          Container(
            child: FutureBuilder(
              future: _loadUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic>? userData = snapshot.data;
                  if (userData != null) { // Successfully loaded data
                    return Card(
                      child: Column(
                        children: [
                          Text("Name: " + userData['name']),
                          Text("Email: " + userData['email']),
                          Text("UID: " + userData['uid']),
                          ElevatedButton(
                              onPressed: () {
                                if (!members.contains(userData)) {
                                  setState(() {
                                    members.add(userData);
                                  });
                                }
                              },
                              child: Text("Add")
                          )
                        ],
                      ),
                    );
                  } else { // Problem loading data
                    return const Text("Error loading data");
                  }
                } else { // Loading data
                  return const Text("No results.");
                }
              },
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                  children: [
                      Text("Name: " + members[index]['name']),
                      Text("Email: " + members[index]['email']),
                      Text("UID: " + members[index]['uid']),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            members.removeAt(index);
                          });
                        },
                        child: Text("Remove")
                      )
                    ]
                  );
                }
            )
          ),
          ElevatedButton(
              onPressed: () {
                createInvites().then((value) {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ChatSelector()));
                });
              },
              child: Text("Submit")
          )
        ],
      ),
    );
  }
}
