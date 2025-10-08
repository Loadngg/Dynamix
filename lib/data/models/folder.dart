class Folder {
  final int id;
  final String name;

  Folder({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(id: json['id'] as int, name: json['name'] as String);
  }
}
