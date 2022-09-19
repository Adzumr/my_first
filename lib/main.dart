import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/add_screen.dart';
import 'package:map_exam/edit_screen.dart';
import 'package:map_exam/home_screen.dart';
import 'package:map_exam/view_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'login_screen.dart';
import 'state_managment.dart';
// import 'home_screen.dart';
// import 'edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: providers,
    child: const App(),
  ));
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<NotesProvider>(create: (_) => NotesProvider()),
];

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myFirst',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.idScreen,
      routes: {
        HomeScreen.idScreen: (context) => const HomeScreen(),
        LoginScreen.idScreen: (context) => const LoginScreen(),
        EditScreen.idScreen: (context) => const EditScreen(),
        ViewScreen.idScreen: (context) => const ViewScreen(),
        AddScreen.idScreen: (context) => const AddScreen(),
      },
    );
  }
}
