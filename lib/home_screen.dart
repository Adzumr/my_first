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
    ValueNotifier<int> noteCount = ValueNotifier(0);
    final count = Provider.of<NotesProvider>(context);

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
                count.getNoteLength(snapshot.data!.docs.length);

                return ListTile(
                  onTap: () async {
                    _collectionReference.doc(documentSnapshot.id).delete();
                  },
                  title: Text(documentSnapshot["title"]),
                  subtitle: isExpanded == false
                      ? const SizedBox.shrink()
                      : Text(documentSnapshot["contentDetail"]),
                  trailing: const Text("Hello"),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
      // ListView.separated(
      //   itemCount: 4,
      //   separatorBuilder: (context, index) => const Divider(
      //     color: Colors.blueGrey,
      //   ),
      //   itemBuilder: (context, index) => ListTile(
      //     trailing: SizedBox(
      //       width: 110.0,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           IconButton(
      //             icon: const Icon(Icons.edit, color: Colors.blue),
      //             onPressed: () {},
      //           ),
      //           IconButton(
      //             icon: const Icon(
      //               Icons.delete,
      //               color: Colors.blue,
      //             ),
      //             onPressed: () {},
      //           ),
      //         ],
      //       ),
      //     ),
      //     title: const Text('Note title'),
      //     subtitle: const Text('Note content'),
      //     onTap: () {},
      //     onLongPress: () {},
      //   ),
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: isExpanded
                ? const Icon(Icons.expand_circle_down_outlined)
                : const Icon(Icons.menu),
            tooltip: 'Show less. Hide notes content',
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),

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
                              try {
                                addNote(
                                  title: titleController.text,
                                  contentDetail: contentController.text,
                                ).then((value) => Navigator.pop(
                                      context,
                                    ));
                              } catch (e) {
                                log(e.toString());
                              }
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    );
                  }));
              // setState(() {
              //   addNote();
              // });
            },
          ),
        ],
      ),
    );
  }
}
