import 'package:flutter/material.dart';
import 'package:map_exam/home_screen.dart';

class ViewScreen extends StatefulWidget {
  final String? title;
  final String? contentDetail;

  static const String idScreen = "viewScreen";
  static Route route() => MaterialPageRoute(builder: (_) => const ViewScreen());

  const ViewScreen({this.title, this.contentDetail, Key? key})
      : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: const Text('View Note'),
        actions: [
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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.title}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 5),
              Expanded(
                child: Text("${widget.contentDetail}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
