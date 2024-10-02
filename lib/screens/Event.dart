// event.dart
class Event {
  final String title;
  final String eventAuthor;
  final String startTime;
  final String endTime;
  final String date;
  final String description;
  final String location;
  final List<String> categories;
  final bool isPaid;

  Event({
    required this.title,
    required this.eventAuthor,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.categories,
    required this.isPaid,
    required this.description,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    List<String> categories = (json['category'] as List)
        .map((category) => category['name'].toString())
        .toList();

    return Event(
      title: json['title'],
      eventAuthor: json['eventAuthor'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      date: json['date'],
      location: json['location'],
      description: json['description'],
      categories: categories,
      isPaid: json['isPaid'] ?? false,
    );
  }
}
