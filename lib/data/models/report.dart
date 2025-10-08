class Report {
  final int id;
  final DateTime date;
  final double value;

  final int groupId;

  Report({
    required this.id,
    required this.date,
    required this.value,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toString(),
      'value': value,
      'groupId': groupId,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      value: json['value'] as double,
      groupId: json['groupId'] as int,
    );
  }
}
