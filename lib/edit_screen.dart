import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class EditScreen extends StatefulWidget {
  final String? title;
  final String? contentDetail;

  static const String idScreen = "editScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());

  const EditScreen({this.title, this.contentDetail, Key? key})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: const Text('App Bar Title'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              size: 30,
            ),
            onPressed: () {},
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: _titleController.text,
              enabled: true,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                  controller: _descriptionController,
                  enabled: true,
                  initialValue: _descriptionController.text,
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
