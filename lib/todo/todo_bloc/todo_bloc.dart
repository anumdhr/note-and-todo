import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/todo_database.dart';
import '../models/models.dart';

class TodoBloc extends Cubit<List<TodoModel>> {
  TodoBloc() : super([]);

  refreshedNote() async {
    List<TodoModel> todoModel = await DatabaseServices().readNote();
    emit(todoModel);
  }

  addTodoItem({required String title}) {
    List<TodoModel> todoModel = [...state];
    todoModel.add(TodoModel(title: title));
    emit(todoModel);
  }

   deleteTodoItem(int id) async {
    List<TodoModel> todoModel = await DatabaseServices().delete(id);
    refreshedNote();
    emit(todoModel);
  }

  updateTodoItem(TodoModel todo) async {
    List<TodoModel> todoModel = await DatabaseServices().update(todo);
   await refreshedNote();
    emit(todoModel);
  }
}

// context.read<TodoBloc>().obs(state[index],index);
// context.read<TodoBloc>().updateTodoItem(state[index]);

// todoModel[index]
// obs(TodoModel todoModel, int index) {
//   todoModel.isChecked = !todoModel.isChecked;
//   final maList = (state);
//   if (maList.isNotEmpty) {
//     maList.removeAt(index);
//     maList.insert(index, todoModel);
//   }
//   emit(maList);
// }
// o0bs(TodoModel todoModel, int index) {
//   todoModel.isChecked = !todoModel.isChecked;
//   final maList = state ?? [];
//   if (maList.isNotEmpty) {
//     maList.removeAt(index);
//     maList.insert(index, todoModel);
//   }
//   emit(maList);
// }
