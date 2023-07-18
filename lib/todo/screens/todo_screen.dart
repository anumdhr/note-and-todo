import 'package:anunoteapp/common_widgets.dart';
import 'package:anunoteapp/todo/database/todo_database.dart';
import 'package:anunoteapp/todo/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<TodoBloc>().refreshedNote();
  }

  // Future refreshedNote() async {
  //   List<TodoModel> updateTodoModel = await DatabaseServices().readNote();
  //   setState(() {
  //     todoModel = updateTodoModel;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<TodoBloc, List<TodoModel>>(
            builder: (context, state) {
              print(state.length);
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    print(' state name : ${state[index].title}');
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
                          value: state[index].isChecked,
                          onChanged: (bool? value) {
                            if (value != null) {
                              final updatedTodo = state[index].copyWith(isChecked: value);
                              context.read<TodoBloc>().updateTodoItem(updatedTodo);
                            }
                          },
                        ),
                        title: Text(state[index].title,
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            )),
                        trailing: IconButton(
                            onPressed: () async {
                              context.read<TodoBloc>().deleteTodoItem(state[index].id!);
                              // setState(() {
                              //   // todoModel.removeAt(index);
                              //   // DatabaseServices().delete(todoModel[index].id!);
                              // });
                              // await refreshedNote();
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    );
                  },
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
                    TextFields(
                      hintText: "Enter here",
                      maxLines: 5,
                      controller: todoController,

                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        DatabaseServices().create(
                          TodoModel(
                            title: todoController.text.trim(),
                            isChecked: false,
                          ),
                        );
                        context.read<TodoBloc>().addTodoItem(title: todoController.text);
                        context.read<TodoBloc>().refreshedNote();
                        Navigator.pop(context);
                        todoController.clear();
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
