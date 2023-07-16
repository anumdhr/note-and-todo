import 'package:anunoteapp/database/notes_database.dart';
import 'package:anunoteapp/screens/home_screen.dart';
import 'package:anunoteapp/todo/database/todo_database.dart';
import 'package:anunoteapp/todo/screens/todo_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService().connectDb();
  DatabaseServices().connectDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Todo(),
    );
  }
}
