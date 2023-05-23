class Directory {
  int? id;
  String? name;
  String?  phone;

  Directory({required this.name, required this.phone});

  Directory.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
  }
}
