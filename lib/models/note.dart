class Note {
  String? noteid; // Unique ID for each note
  String? name;
  String? semester;
  String? course;
  String? uploadedby;
  String? pdfUrl; // URL to the uploaded PDF file
  DateTime? uploadedon;

  Note({
    this.noteid,
    this.name,
    this.semester,
    this.course,
    this.pdfUrl,
    this.uploadedby,
    this.uploadedon
  });

  Note.fromMap(Map<String, dynamic> map)
  {
    noteid = map["noteid"];
    name = map["name"];
    semester = map["semester"];
    course = map["course"];
    uploadedby=map["uploadedby"];
    pdfUrl=map["pdfUrl"];
    uploadedon=map["uploadedon"].toDate();
  }

  Map<String, dynamic> toMap(){
    return {
      "noteid": noteid,
      "name": name,
      "semester": semester,
      "course": course,
      "uploadedby": uploadedby,
      "pdfUrl": pdfUrl,
      "uploadedon": uploadedon
    };
  }
}
