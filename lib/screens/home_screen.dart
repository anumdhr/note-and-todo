import 'package:anunoteapp/database/notes_database.dart';
import 'package:anunoteapp/models/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

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
      appBar: AppBar(
        title: const Text(
          "Note App",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              shrinkWrap: true,
              itemCount: notesModel.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          buildShowModalBottomSheet(
                            notesModels: notesModel[index],
                            context,
                            titleController: titleController,
                            descriptionController: descriptionController,
                          );
                        },
                        child: Column(
                          children: [
                            Text(notesModel[index].title),
                            Text(notesModel[index].description),
                          ],
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
          )
        ],
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
                child: const Text(
                  "Enter",
                  style: TextStyle(
                    color: Colors.black,
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

class TextFields extends StatelessWidget {
  const TextFields({
    super.key,
    required this.hintText,
    required this.maxLines,
    required this.controller,
  });

  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1,
            )),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
