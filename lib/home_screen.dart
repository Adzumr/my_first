import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/edit_screen.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'state_managment.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "homeScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final data = Provider.of<NotesProvider>(context, listen: false);
    data.getNotes();
    super.initState();
  }

  bool isExpanded = true;
  bool showEdit = false;
  String? pageTitle;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection("myFirst_Notes__")
      .doc(userid)
      .collection("Notes");

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<NotesProvider>(context);

    setState(() {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: Text(
              data.noteLength ?? "0",
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: Colors.grey,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
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
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    pageTitle = "View Note";
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditScreen(
                                        pageTitle: pageTitle,
                                        id: documentSnapshot.id,
                                        title: documentSnapshot["title"],
                                        contentDetail:
                                            documentSnapshot["contentDetail"],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documentSnapshot["title"],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 10),
                                    isExpanded
                                        ? Text(
                                            documentSnapshot["contentDetail"],
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                            showEdit
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                pageTitle = "Edit Note";
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditScreen(
                                                    pageTitle: pageTitle,
                                                    id: documentSnapshot.id,
                                                    title: documentSnapshot[
                                                        "title"],
                                                    contentDetail:
                                                        documentSnapshot[
                                                            "contentDetail"],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Icon(Icons.edit)),
                                        const SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return AlertDialog(
                                                  title: const Text("Delete"),
                                                  content: const Text(
                                                      "Are You Sure?"),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        data
                                                            .deleteNote(
                                                          documentId:
                                                              documentSnapshot
                                                                  .id,
                                                        )
                                                            .then((value) {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: const Text("Yes"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel"),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            );
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
                },
              ),
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
            child: isExpanded
                ? const Icon(Icons.menu)
                : const Icon(Icons.expand_circle_down_outlined),
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
              setState(() {
                pageTitle = "Add New Note";
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    pageTitle: pageTitle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
