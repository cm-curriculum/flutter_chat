import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'chat_adder.dart';
import 'chat_requester.dart';

class ChatSelector extends StatefulWidget {
  const ChatSelector({super.key});

  @override
  State<ChatSelector> createState() => _ChatSelectorState();
}

class _ChatSelectorState extends State<ChatSelector> {
  final db = FirebaseFirestore.instance;
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> _loadUser(uid) async {
    final db = FirebaseFirestore.instance;
    return (await db.collection("users").doc(uid).get()).data();
  }

  Future<Map<String, dynamic>?> _loadChat(DocumentReference ref) async {
    return (await ref.get()).data() as Map<String, dynamic>;
  }

  Widget memberDisplay(DocumentReference chatRef) {
    return FutureBuilder(
      future: chatRef.get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic>? chatData = snapshot.data.data();
          if (chatData != null) { // Successfully loaded data
            return ListView.builder( // Displays all group members
              shrinkWrap: true,
              itemCount: chatData['members'].length,
              itemBuilder: (BuildContext context, int memberIndex) {
                return FutureBuilder(
                  future: _loadUser(chatData['members'][memberIndex]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic>? userData = snapshot.data;
                      if (userData != null) { // Successfully loaded data
                        return Text(userData['name']);
                      } else { // Problem loading data
                        return const Text("Error loading data");
                      }
                    } else { // Loading data
                      return const Text("loading...");
                    }
                  },
                );
              },
            );
          } else { // Problem loading data
            return const Text("Error loading data");
          }
        } else { // Loading data
          return const Text("loading...");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Selector"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 90,
            child: FutureBuilder(
              future: db.collection('chat_keys').where('user', isEqualTo: myUid).get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) { // Successfully loaded data
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>? keys = snapshot.data.docs;
                  print(myUid);
                  if (keys != null) {
                    if (keys!.isEmpty) {
                      return Text("You are not part of any chats.");
                    }
                    return ListView.builder( // Once posts are retrieved, generates ListView
                      itemCount: keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            children: [
                              memberDisplay(keys[index]['ref']),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(docRef: keys[index]['ref'])));
                                  },
                                  child: Text("View")
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else { // Problem loading data
                    print("CANNOT LOAD DATA");
                    return const Text("Error loading data");
                  }
                } else { // Loading data
                  print("LOADING DATA");
                  return const Text("Loading...");
                }
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChatAdder()));
                    },
                    child: Text("Create Chat")
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChatRequester()));
                    },
                    child: Text("View Invites")
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
