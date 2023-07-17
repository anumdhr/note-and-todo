import 'package:anunoteapp/database/notes_database.dart';
import 'package:anunoteapp/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common_widgets.dart';

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
    refreshNote();
  }

  Future refreshNote() async {
    List<NotesModel> updatedNotesModel = await DatabaseService().readNote();
    setState(() {
      notesModel = updatedNotesModel;
    });
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(notesModel.length);
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: notesModel.length,
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
                        notesModels: notesModel[index],
                        context,
                        titleController: titleController,
                        descriptionController: descriptionController,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notesModel[index].title,
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
                          notesModel[index].description,
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
                IconButton(
                  onPressed: () async {
                    setState(() {
                      DatabaseService().delete(notesModel[index].id!);
                    });
                    await refreshNote();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
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
                      await DatabaseService().update(NotesModel(
                        id: notesModels.id,
                        title: titleController.text,
                        description: descriptionController.text,
                      ));
                    } else {
                      // Create a new note
                      await DatabaseService().create(NotesModel(
                        title: titleController.text,
                        description: descriptionController.text,
                      ));
                    }
                    await refreshNote();
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
