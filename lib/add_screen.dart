import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class AddScreen extends StatefulWidget {
  static const String idScreen = "addScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const AddScreen());

  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool isLoading = false;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("myFirst_Notes");
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String? title;
  String? content;
  Future addNote() async {
    try {
      setState(() {
        isLoading = true;
      });
      log(titleController.text);
      log(contentController.text);
      await _collectionReference.add({
        "title": titleController.text,
        "contentDetail": contentController.text,
      }).then(
        (value) => Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.idScreen,
          (route) => false,
        ),
      );
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: const Text('Add new Note'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              size: 30,
            ),
            onPressed: () async {
              addNote();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cancel_sharp,
              size: 30,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.idScreen,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  TextFormField(
                    enabled: true,
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Type the title here',
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: TextFormField(
                        enabled: true,
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Type the description',
                        ),
                        onChanged: (value) {}),
                  ),
                ],
              ),
            ),
    );
  }
}
