class NotesModel {
  int? id;
   String title;
   String description;

  NotesModel({
    this.id,
    required this.title,
    required this.description,
  });
  Map<String, dynamic> toMap(){
    return{
      'title' : title,
      'description' : description,
    };
  }
}
