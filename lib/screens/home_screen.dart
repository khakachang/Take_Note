import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:take_note/screens/note_editor.dart';
import 'package:take_note/screens/note_reader.dart';
import 'package:take_note/style/app_style.dart';
import 'package:take_note/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        //To remove gray status bar
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        elevation: 0.0,
        title: Text(
          "Take Note",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        //GridView Paddding
        padding: EdgeInsets.only(
          left: 3,
          right: 3,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Your recent Notes",
                style: GoogleFonts.roboto(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            // SizedBox(
            //   height: 20.0,
            // ),

            //Notes Grid view
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    // return GridView(

                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2),
                    //   children: snapshot.data!.docs
                    //       .map((note) => noteCard(() {
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) =>
                    //                       NoteReaderScreen(note),
                    //                 ));
                    //           }, note))
                    //       .toList(),
                    // );
                    return StaggeredGridView.count(
                      crossAxisCount: 2, // Number of columns in the grid
                      staggeredTiles: snapshot.data!.docs.map((note) {
                        // Generate StaggeredTile for each note item
                        return StaggeredTile.fit(1);
                      }).toList(),
                      children: snapshot.data!.docs.map((note) {
                        // Generate widgets for each note item
                        return noteCard(
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteReaderScreen(note),
                              ),
                            );
                          },
                          note,
                        );
                      }).toList(),
                    );
                  } //end here

                  return Text(
                    "There's no Notes",
                    style: GoogleFonts.nunito(color: Colors.black),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteEditorScreen()));
        },
        backgroundColor: Colors.black,
        label: Text("Add Note"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
