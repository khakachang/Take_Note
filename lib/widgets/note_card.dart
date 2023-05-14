import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:take_note/style/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      //Gridview Margin
      // margin: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(
        left: 2,
        right: 2,
        top: 2,
        bottom: 2,
      ),
      decoration: BoxDecoration(
          color: AppStyle.mainColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black26,
            width: 0.5,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["note_title"],
            style: AppStyle.mainTitle,
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            doc["creation_date"],
            style: TextStyle(color: Colors.black45),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            doc["note_content"],
            style: TextStyle(color: Colors.black45),
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    ),
  );
}
