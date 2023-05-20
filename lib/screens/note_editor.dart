import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_note/style/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  @override
  Widget build(BuildContext context) {
    String date = DateTime.now().toString();
    TextEditingController _titleController = TextEditingController();
    TextEditingController _mainController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Add a new Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          //Wrap in SingleChildScrollView To make the Column Scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 28.0,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Title',
                ),
                style: AppStyle.mainTitle,
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                date,
                style: AppStyle.dateTitle,
              ),
              SizedBox(
                height: 28.0,
              ),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Content',
                ),
                style: AppStyle.mainContent,
              ),
            ],
          ),
        ),
      ),

      //Save Botton
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            try {
              String userId = user.uid;
              DocumentReference userRef =
                  FirebaseFirestore.instance.collection("Users").doc(userId);

              // Create or update the user document with relevant data
              await userRef.set({
                "name": user.displayName,
                "email": user.email,

                // Add any other relevant user data
              });

              // Create the note document under the user document
              DocumentReference noteRef = userRef.collection("Notes").doc();
              await noteRef.set({
                "note_title": _titleController.text,
                "creation_date": date,
                "note_content": _mainController.text,
              });

              print(noteRef.id);
              Navigator.pop(context);
            } catch (e) {
              print("Error writing note: $e");
            }
          } else {
            print("User not authenticated");
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
