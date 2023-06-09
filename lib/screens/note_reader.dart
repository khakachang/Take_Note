import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:take_note/screens/update.dart';
import 'package:take_note/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key});
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateScreen(noteSnapshot: widget.doc),
                ),
              );
            },
            icon: Icon(Icons.edit_outlined, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              _showOptionsMenu(context);
            },
            icon: Icon(Icons.delete_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.0),
              Text(
                widget.doc["note_title"],
                style: AppStyle.mainTitle,
              ),
              SizedBox(height: 4.0),
              Text(
                widget.doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              SizedBox(height: 28.0),
              Text(
                widget.doc["note_content"],
                style: AppStyle.mainContent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Note'),
              onTap: () {
                _deleteNote();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print("Authenticated User UID: ${user?.uid}");
      print("User ID from Document Path: ${user?.uid}");

      print("Document Path: Users/${user?.uid}/Notes/${widget.doc.id}");
      print("Note ID: ${widget.doc.id}");

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user?.uid)
          .collection("Notes")
          .doc(widget.doc.id)
          .delete();

      // Show a snackbar or any other notification indicating successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Note deleted successfully"),
        ),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that occurred during deletion
      print('Failed to delete note: $e');
      // Show a snackbar or any other notification indicating the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete note"),
        ),
      );
    }
  }
}
