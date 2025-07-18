class Event {
  String title;
  bool isHoliday;

  Event({
    required this.title,
    this.isHoliday = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title']
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
  };
}