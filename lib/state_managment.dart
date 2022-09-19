import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  getCollection() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("myFirst_Notes");
    return collectionReference.snapshots();
  }

  int? name;
  //getters:
  int get getNoteCount => name!;

//Setters:

  changeProductName(int? val) {
    name = val!;
    notifyListeners();
  }
}
