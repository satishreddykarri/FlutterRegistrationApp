import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:registrationpage/Screens/login_screen.dart';
import 'package:registrationpage/Screens/registrationscreen.dart';
import 'package:registrationpage/Screens/upload_status.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Registrationscreen()),
                );
              }).catchError((error) {
                print('Sign out failed: $error');
              });
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("statuses").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshots.data!.docs.isEmpty) {
            return Center(child: Text("No Data"));
          }

          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshots.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: data['imageurl'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(data['imageurl']),
                        radius: 24,
                      )
                    : CircleAvatar(
                        child: Icon(Icons.image, color: Colors.white),
                        backgroundColor: Colors.grey,
                        radius: 24,
                      ),
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(data['message'] ?? 'No Message'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UploadStatus()),
          );
        },
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
