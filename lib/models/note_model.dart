class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createdDate;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      createdDate: DateTime.parse(map['created_date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_date': createdDate.toIso8601String(),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
