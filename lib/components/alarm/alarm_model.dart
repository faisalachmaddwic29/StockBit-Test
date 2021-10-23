class AlarmModel {
  int? id;
  String key;
  String? time;
  String title;
  DateTime alarmDateTime;
  bool isPending;

  AlarmModel(
      {this.id,
      required this.key,
      this.time,
      required this.title,
      required this.alarmDateTime,
      required this.isPending});

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      key: json['key'],
      time: json['time'],
      title: json['title'],
      alarmDateTime: DateTime.parse(json['alarmDateTime']),
      isPending: (json['isPending'] == 1) ? true : false,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "time": time,
        "title": title,
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isPending": (isPending) ? 1 : 0,
      };
}
