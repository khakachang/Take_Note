import 'package:flutter/material.dart';
import 'package:take_note/style/app_style.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Image.asset(
            "images/sign_in.png",
            alignment: Alignment.topCenter,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            child: Text(
              "Welcome",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: AutofillHints.addressCity,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 50, right: 50),
            child: Text(
              "Keep track of your notes and idea easily with our user-friendly interface.Stay organized and productive",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontFamily: AutofillHints.addressCity,
                fontWeight: FontWeight.w300,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          ElevatedButton(
            // style: ButtonStyle(shadowColor: ),
            onPressed: () {},
            child: Text("Continue with Google"),
          )
        ],
      ),
    );
  }
}
