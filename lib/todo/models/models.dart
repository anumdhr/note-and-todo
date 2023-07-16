class TodoModel {
  final int? id;
  final String title;
   bool isChecked;

  TodoModel({this.id, required this.title,  this.isChecked = false});
  Map<String, dynamic> toMap(){
    return{
      'title' : title,
      'isChecked' : isChecked ? 1 : 0,
    };
  }
}
