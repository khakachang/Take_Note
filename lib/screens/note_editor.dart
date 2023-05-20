import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_note/style/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditorScreen extends StatefulWidget {
  final QueryDocumentSnapshot?
      doc; // Document snapshot for editing, null for creating

  const NoteEditorScreen({Key? key, this.doc}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If a document snapshot is provided, populate the text fields with its data for editing
    if (widget.doc != null) {
      _titleController.text = widget.doc!["note_title"];
      _mainController.text = widget.doc!["note_content"];
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = DateTime.now().toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.doc != null ? "Edit Note" : "Add a new Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
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

      //Save Button
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

              if (widget.doc != null) {
                // Update the existing note document
                await widget.doc!.reference.update({
                  "note_title": _titleController.text,
                  "note_content": _mainController.text,
                });
              } else {
                // Create a new note document under the user document
                DocumentReference noteRef = userRef.collection("Notes").doc();
                await noteRef.set({
                  "note_title": _titleController.text,
                  "creation_date": date,
                  "note_content": _mainController.text,
                });
              }

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
