class Task {
  String title;
  bool isComplete;
  DateTime day;

  Task({
    required this.title,
    this.isComplete = false,
    required this.day,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isComplete: json['isComplete'],
      day: DateTime.parse(json['day']),
    );
  }

  Map<String, dynamic> toJson() {
    String dayString = day.toIso8601String();
    return {
      'title': title,
      'isComplete': isComplete,
      'day': dayString,
    };
  }

  Task copyWith({
    String? title,
    bool? isComplete,
    DateTime? day,
  }) {
    return Task(title: title ?? this.title, isComplete: isComplete ?? this.isComplete, day: day ?? this.day);
  }

  Task copy() => Task(
    title: title,
    isComplete: isComplete,
    day: day,
  );
}