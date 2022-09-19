import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';
import 'package:provider/provider.dart';

import 'state_managment.dart';

class EditScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final String? pageTitle;
  final String? contentDetail;

  static const String idScreen = "editScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());

  const EditScreen(
      {this.pageTitle, this.id, this.title, this.contentDetail, Key? key})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  void initState() {
    pageTitleController = TextEditingController(text: widget.pageTitle ?? "");
    titleController = TextEditingController(text: widget.title ?? "");
    contentController = TextEditingController(text: widget.contentDetail ?? "");
    idController = TextEditingController(text: widget.id ?? "");
    super.initState();
  }

  bool isLoading = false;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController pageTitleController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String? title;
  String? content;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(pageTitleController.text),
        actions: [
          pageTitleController.text != "View Note"
              ? IconButton(
                  icon: const Icon(
                    Icons.check_circle,
                    size: 30,
                  ),
                  onPressed: () async {
                    pageTitleController.text == "View Note"
                        ? Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeScreen.idScreen,
                            (route) => false,
                          )
                        : pageTitleController.text == "Edit Note"
                            ? data.updateNote(
                                id: widget.id,
                                title: titleController.text,
                                contentDetail: contentController.text,
                                context: context,
                              )
                            : data.addNote(
                                title: titleController.text,
                                contentDetail: contentController.text,
                                context: context);
                  },
                )
              : const SizedBox.shrink(),
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
                    enabled:
                        pageTitleController.text == "View Note" ? false : true,
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Type the title here',
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: TextFormField(
                        enabled: pageTitleController.text == "View Note"
                            ? false
                            : true,
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
