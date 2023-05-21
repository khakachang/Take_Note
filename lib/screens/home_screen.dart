import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:take_note/screens/note_editor.dart';
import 'package:take_note/screens/note_reader.dart';
import 'package:take_note/screens/sign_in.dart';
import 'package:take_note/style/app_style.dart';
import 'package:take_note/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
User? _user;
late String userId; // Declare userId variable

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  late String userId; // Declare userId variable

  @override
  void initState() {
    super.initState();
    retrieveUserId(); // Call the function to retrieve the user ID
  }

  Future<void> retrieveUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _user = FirebaseAuth.instance.currentUser;
  // }

  // Change Google Account
  Future<void> _changeGoogleAccount() async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final result = await _googleSignIn.signIn();

      if (result != null) {
        final GoogleSignInAuthentication googleAuth =
            await result.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        final updatedUser = FirebaseAuth.instance.currentUser;
        if (mounted && updatedUser != null) {
          setState(() {
            _user = updatedUser;
          });
        }
      }
    } catch (e) {
      print('Failed to change Google account: $e');
      // Handle any error that occurred during the account change process
    }
  }

  //Sign out Function
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        //To remove gray status bar
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _changeGoogleAccount();
              },
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0.0,
        title: const Text(
          "Take Note",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "images/AppLogoForDrawer.png",
                    height: 50,
                  )),
              Divider(),
              Text(
                "Developed by",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                  letterSpacing: 4.0,
                ),
              ),
              Text(
                "Boyar Debbarma",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
              Text(
                "Bikash Debbarma",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                "Khakachang Tripura",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        //GridView Paddding
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
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

            //Notes Grid view

            // User user = FirebaseAuth.instance.currentUser;
            // String userId = user.uid;

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(userId)
                    .collection("Notes")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return Text(
                        "There are no notes",
                        style: TextStyle(color: Colors.black),
                      );
                    }
                    return StaggeredGridView.count(
                      crossAxisCount: 2,
                      staggeredTiles: snapshot.data!.docs.map((note) {
                        return StaggeredTile.fit(1);
                      }).toList(),
                      children: snapshot.data!.docs.map((note) {
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
                  }

                  return Text(
                    "Error retrieving notes",
                    style: TextStyle(color: Colors.black),
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
