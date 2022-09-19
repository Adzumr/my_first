import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class EditScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final String? contentDetail;

  static const String idScreen = "editScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());

  const EditScreen({this.id, this.title, this.contentDetail, Key? key})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    titleController = TextEditingController(text: widget.title ?? "");
    contentController = TextEditingController(text: widget.contentDetail ?? "");
    idController = TextEditingController(text: widget.id ?? "");
    super.initState();
  }

  bool isLoading = false;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("myFirst_Notes");
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String? title;
  String? content;
  Future updateNote() async {
    try {
      setState(() {
        isLoading = true;
      });
      log(idController.text);
      log(titleController.text);
      log(contentController.text);
      await _collectionReference.doc(idController.text).update({
        "id": idController.text,
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
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              size: 30,
            ),
            onPressed: () async {
              updateNote();
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
