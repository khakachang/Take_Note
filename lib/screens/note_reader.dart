import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_note/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {super.key});
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
      ),
      body: Padding(
        //Inside Note Padding
        // padding: EdgeInsets.all(16.0),
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
              Text(
                widget.doc["note_title"],
                style: AppStyle.mainTitle,
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                widget.doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              SizedBox(
                height: 28.0,
              ),
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
}
