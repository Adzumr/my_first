import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/note.dart';

import 'home_screen.dart';
import 'main.dart';

class NotesProvider extends ChangeNotifier {
  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("myFirst_Notes__")
      .doc(userid)
      .collection("Notes");
  String? noteLength;

  List<Note>? notes;
  Future<String?> getNotes() async {
    await collectionReference
        .get()
        .then((value) => noteLength = value.docs.length.toString());

    return noteLength;
  }

  Future deleteNote({String? documentId}) async {
    await collectionReference.doc(documentId).delete().then((value) async {
      await collectionReference.get().then(
            (value) => noteLength = value.docs.length.toString(),
          );

      return noteLength;
    });
  }

  Future addNote(
      {String? title, String? contentDetail, BuildContext? context}) async {
    try {
      await collectionReference.add({
        "title": "$title",
        "contentDetail": "$contentDetail",
      }).then((value) async {
        await collectionReference.get().then(
              (value) => noteLength = value.docs.length.toString(),
            );

        return noteLength;
      }).then((value) {
        Navigator.pushNamedAndRemoveUntil(
          context!,
          HomeScreen.idScreen,
          (route) => false,
        );
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateNote(
      {String? id,
      String? title,
      String? contentDetail,
      BuildContext? context}) async {
    try {
      await collectionReference.doc(id).update({
        "title": "$title",
        "contentDetail": "$contentDetail",
      }).then((value) async {
        await collectionReference.get().then(
              (value) => noteLength = value.docs.length.toString(),
            );

        return noteLength;
      }).then((value) {
        Navigator.pushNamedAndRemoveUntil(
          context!,
          HomeScreen.idScreen,
          (route) => false,
        );
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
