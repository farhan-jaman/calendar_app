class Task {
  final String title;
  bool isComplete;

  Task({
    required this.title,
    this.isComplete = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isComplete: json['isComplete'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'isComplete': isComplete,
  };
}