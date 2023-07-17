import 'package:anunoteapp/common_widgets.dart';
import 'package:anunoteapp/todo/database/todo_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/models.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<TodoModel> todoModel = [];
  final TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshedNote();
  }

  Future refreshedNote() async {
    List<TodoModel> updateTodoModel = await DatabaseServices().readNote();
    setState(() {
      todoModel = updateTodoModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(todoModel.length);
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: todoModel.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.brown,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    value: todoModel[index].isChecked,
                    onChanged: (bool? value) async {
                      setState(() {
                        todoModel[index].isChecked = value ?? false;
                      });

                      await DatabaseServices().update(todoModel[index]);
                    },
                  ),
                  title: Text(todoModel[index].title,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      )),
                  trailing: IconButton(
                      onPressed: () async {
                        setState(() {
                          // todoModel.removeAt(index);
                          DatabaseServices().delete(todoModel[index].id!);
                        });
                        await refreshedNote();
                      },
                      icon: Icon(Icons.delete)),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TextFields(hintText: "Enter here", maxLines: 5, controller: todoController),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      onPressed: () async {
                        setState(() {
                          DatabaseServices().create(TodoModel(title: todoController.text, isChecked: false));
                          // todoModel.add(TodoModel(title: todoController.text,));
                          Navigator.pop(context);
                          todoController..clear();
                        });
                        await refreshedNote();
                      },
                      child: Text("Enter",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
    );
  }
}
