class Group {
  final int id;
  final String name;
  final String unit;
  final double minValue;
  final double maxValue;

  final int folderId;

  Group({
    required this.id,
    required this.name,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.folderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'minValue': minValue,
      'maxValue': maxValue,
      'folderId': folderId,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int,
      name: json['name'] as String,
      unit: json['unit'] as String,
      minValue: json['minValue'] as double,
      maxValue: json['maxValue'] as double,
      folderId: json['folderId'] as int,
    );
  }
}
