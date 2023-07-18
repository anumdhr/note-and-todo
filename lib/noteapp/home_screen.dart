import 'package:anunoteapp/noteapp/noteapp_bloc/noteapp_bloc.dart';
import 'package:anunoteapp/todo/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common_widgets.dart';
import 'database/notes_database.dart';
import 'models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NotesModel> notesModel = [];

  @override
  void initState() {
    super.initState();
    context.read<NoteAppBloc>().refreshNote();
  }

  // Future refreshNote() async {
  //   // List<NotesModel> updatedNotesModel = await DatabaseService().readNote();
  //   // setState(() {
  //   //   notesModel = updatedNotesModel;
  //   // });
  // }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(notesModel.length);
    return Scaffold(
      body: BlocBuilder<NoteAppBloc,List<NotesModel>>(
        builder: (context,state) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.brown,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          buildShowModalBottomSheet(
                            notesModels: state[index],
                            context,
                            titleController: titleController,
                            descriptionController: descriptionController,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state[index].title,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              state[index].description,
                              maxLines: 3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<NoteAppBloc, List<NotesModel>>(builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          context.read<NoteAppBloc>().deleteNoteItem(state[index].id!);
                          // setState(() {
                          //   // DatabaseService().delete(notesModel[index].id!);
                          // });
                        },
                        icon: const Icon(Icons.delete),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          buildShowModalBottomSheet(
            context,
            descriptionController: descriptionController,
            titleController: titleController,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.green,
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(
    BuildContext context, {
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    NotesModel? notesModels,
  }) {
    titleController.text = notesModels?.title ?? '';
    descriptionController.text = notesModels?.description ?? '';

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            children: [
              TextFields(
                hintText: "Title",
                maxLines: 1,
                controller: titleController,
              ),
              TextFields(
                hintText: "Description",
                maxLines: 10,
                controller: descriptionController,
              ),
          ElevatedButton(
            style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 5,
              )),
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
            ),
            onPressed: () async {
              if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                if (notesModels != null) {
                  // Update an existing note
                  context.read<NoteAppBloc>().updateNoteItem(
                    notesModels.id!,
                    titleController.text,
                    descriptionController.text,
                  );
                } else {

                  context.read<NoteAppBloc>().addNoteItem(titleController.text, descriptionController.text);
                  context.read<NoteAppBloc>().refreshNote();

                  // Create a new note
                  // await DatabaseService().create(NotesModel(
                  //   title: titleController.text,
                  //   description: descriptionController.text,
                  // ));
                }
                await context.read<NoteAppBloc>().refreshNote();
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              }
            },
            child: Text(
              "Enter",
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
            ],
          ),
        );
      },
    );
  }
}
