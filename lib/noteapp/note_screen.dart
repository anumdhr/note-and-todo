import 'package:anunoteapp/noteapp/noteapp_bloc/noteapp_bloc.dart';
import 'package:anunoteapp/todo/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../common_widgets.dart';
import 'database/notes_database.dart';
import 'models/notes_model.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<NotesModel> notesModel = [];
  List<NotesModel> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    context.read<NoteAppBloc>().refreshNote();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<NoteAppBloc>().searchNotes(searchController.text);
  }

  final _lightColors = [
    Colors.amber.shade300,
    Colors.lightGreen.shade300,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.tealAccent.shade100
  ];

  // Future refreshNote() async {
  //   // List<NotesModel> updatedNotesModel = await DatabaseService().readNote();
  //   // setState(() {
  //   //   notesModel = updatedNotesModel;
  //   // });
  // }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();

    print(notesModel.length);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(onPressed: _onSearchChanged, icon: Icon(Icons.search))
                ),

              ),

            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<NoteAppBloc, List<NotesModel>>(builder: (context, state) {
              return state.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final color = _lightColors[index % _lightColors.length];

                        return GestureDetector(
                          onTap: () {
                            buildShowModalBottomSheet(context,
                              descriptionController: descriptionController,
                              titleController: titleController,
                              notesModels: state[index],
                            );

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder:(context) => NewAndUpdateNotes(
                            //       titlee: state[index].title,
                            //       des: state[index].description,
                            //       index: index,
                            //     ),
                            //   ),
                            // );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Note'),
                                  content: const Text('Are you sure you want to delete this note?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<NoteAppBloc>().deleteNoteItem(state[index].id!);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                              left: index.isOdd ? 6.0 : 0.0,
                              right: index.isEven ? 6.0 : 0.0,
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state[index].title,
                                  style: const TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  state[index].description,
                                  style: const TextStyle(color: Colors.black45),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat.yMMMd().format(time),
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
          ],
        ),
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
