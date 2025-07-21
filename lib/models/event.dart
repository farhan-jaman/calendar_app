class Event {
  String title;
  bool isHoliday;
  bool isAllDay;
  DateTime startTime;
  DateTime endTime;

  Event({
    required this.title,
    this.isHoliday = false,
    this.isAllDay = false,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {

    return Event(
      title: json['title'],
      isHoliday: json['isHoliday'],
      isAllDay: json['isAllDay'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'isHoliday': isHoliday,
    'isAllDay': isAllDay,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };
}