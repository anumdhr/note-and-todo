import 'package:anunoteapp/screens/main_screen.dart';
import 'package:anunoteapp/todo/database/todo_database.dart';
import 'package:anunoteapp/todo/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'noteapp/database/notes_database.dart';
import 'noteapp/noteapp_bloc/noteapp_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoBloc(),
        ),
        BlocProvider(
          create: (context) => NoteAppBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
