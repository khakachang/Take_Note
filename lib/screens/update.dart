import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_note/screens/home_screen.dart';
import 'package:take_note/style/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateScreen extends StatefulWidget {
  final DocumentSnapshot noteSnapshot;

  const UpdateScreen({required this.noteSnapshot, Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late String date;
  late TextEditingController _titleController;
  late TextEditingController _mainController;

  @override
  void initState() {
    super.initState();
    date = widget.noteSnapshot.get("creation_date");
    _titleController =
        TextEditingController(text: widget.noteSnapshot.get("note_title"));
    _mainController =
        TextEditingController(text: widget.noteSnapshot.get("note_content"));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Edit Note",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            try {
              String userId = user.uid;
              DocumentReference noteRef = widget.noteSnapshot.reference;

              await noteRef.update({
                "note_title": _titleController.text,
                "note_content": _mainController.text,
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(), // Replace HomePage with your actual home page widget
                ),
              );
            } catch (e) {
              print("Error updating note: $e");
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
