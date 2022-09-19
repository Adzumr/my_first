import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state_managment.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false;
  bool showEdit = false;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection("myFirst_Notes");
  Future addNote({String? title, String? contentDetail}) async {
    try {
      await _collectionReference.add({
        "id": userid,
        "title": "$title",
        "contentDetail": "$contentDetail",
      }).then(
        (value) => log(
          value.id,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<NotesProvider>(context);
    final List<bool> selected = List.generate(20, (i) => false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: Text(
              "${count.getNoteCount}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: StreamBuilder(
        stream: _collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                // count.getNoteLength(snapshot.data!.docs.length);

                return Flexible(
                  child: InkWell(
                    onLongPress: () {
                      setState(() {
                        showEdit = !showEdit;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot["title"],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  documentSnapshot["contentDetail"],
                                ),
                              ],
                            ),
                          ),
                          showEdit
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.edit),
                                      const SizedBox(width: 20),
                                      InkWell(
                                        onTap: () async {
                                          _collectionReference
                                              .doc(documentSnapshot.id)
                                              .delete();
                                        },
                                        child: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                );
                // ListTile(
                //   onLongPress: () {
                //     setState(() {
                //       showEdit = !showEdit;
                //     });
                //   },
                //   title: Text(documentSnapshot["title"]),
                //   subtitle: isExpanded == false
                //       ? const SizedBox.shrink()
                //       : Text(documentSnapshot["contentDetail"]),
                //   trailing: showEdit
                //       ? Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           children: [
                //             const Icon(Icons.edit),
                //             InkWell(
                //               onTap: () async {
                //                 _collectionReference
                //                     .doc(documentSnapshot.id)
                //                     .delete();
                //               },
                //               child: const Icon(Icons.delete),
                //             ),
                //           ],
                //         )
                //       : const SizedBox.shrink(),
                // );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: !isExpanded
                ? const Icon(Icons.expand_circle_down_outlined)
                : const Icon(Icons.menu),
            tooltip: 'Show less. Hide notes content',
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          const SizedBox(width: 10),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((context) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: "Title",
                            ),
                          ),
                          TextFormField(
                            controller: contentController,
                            decoration: const InputDecoration(
                              labelText: "Content",
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                try {
                                  addNote(
                                    title: titleController.text,
                                    contentDetail: contentController.text,
                                  ).then((value) {
                                    Navigator.pop(context);
                                    titleController.clear();
                                    contentController.clear();
                                  });
                                } catch (e) {
                                  log(e.toString());
                                }
                              });
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    );
                  }));
            },
          ),
        ],
      ),
    );
  }
}
