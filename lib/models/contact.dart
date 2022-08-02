
const String contactTable = "contactTable";
const String idColumn = "idColumn";
const String nameColumn = "nameColumn";
const String emailColumn = "emailColumn";
const String phoneColumn = "phoneColumn";
const String imgColumn = "imgColumn";

class Contact {

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact();

  Contact.fromMap(Map<String, dynamic> map)
  :id = map[idColumn],
  name = map[nameColumn],
  email = map[emailColumn],
  phone = map[phoneColumn],
  img = map[imgColumn];

  Map<String, dynamic> toMap() {

    Map<String,dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    }; 
    if(id!=null) {
      map[idColumn] = id;
    }
    return map;
  }
  
}