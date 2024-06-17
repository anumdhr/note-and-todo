import 'package:anunoteapp/noteapp/models/notes_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/notes_database.dart';

class NoteAppBloc extends Cubit<List<NotesModel>> {
  NoteAppBloc() : super([]);

  refreshNote() async {
    List<NotesModel> updateNotesModel = await DatabaseService().readNote();
    emit(updateNotesModel);
  }

  addNoteItem(String title, String description)async{
    List<NotesModel> notesModel = [...state];
    await DatabaseService().create(NotesModel(title: title, description: description));
    notesModel.add(NotesModel(title: title, description: description));
    emit(notesModel);
  }


  updateNoteItem(int id, String title, String description) async {
    List<NotesModel> updateNotesModel = await DatabaseService().update(NotesModel(
      id: id,
      title: title,
      description: description,
    ));
    emit(updateNotesModel);
  }

  deleteNoteItem(int id) async {
    List<NotesModel> notesModel = await DatabaseService().delete(id);
    await refreshNote();
    emit(notesModel);

  }
  searchNotes(String query) {
    if (query.isEmpty) {
      refreshNote(); // Restore the original list of notes
    } else {
      final filteredNotes = state.where((note) {
        final titleLower = note.title.toLowerCase();
        final descriptionLower = note.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) || descriptionLower.contains(searchLower);
      }).toList();

      emit(filteredNotes);
    }
  }
}

