class Note {
  final int id;
  final String title;
  final String content;
  final DateTime createdDate;
  final DateTime lastModified;
  final bool isPinned;
  final String colorCode;
  final double fontSize;
  final String fontFamily;
  final String textColor;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    DateTime? lastModified,
    this.isPinned = false,
    this.colorCode = 'default',
    this.fontSize = 16.0,
    this.fontFamily = 'default',
    this.textColor = 'black',
  }) : lastModified = lastModified ?? createdDate;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      createdDate: DateTime.parse(map['created_date'] as String),
      lastModified: map['last_modified'] != null
          ? DateTime.parse(map['last_modified'] as String)
          : DateTime.parse(map['created_date'] as String),
      isPinned: (map['is_pinned'] as int?) == 1,
      colorCode: map['color_code'] as String? ?? 'default',
      fontSize: (map['font_size'] as num?)?.toDouble() ?? 16.0,
      fontFamily: map['font_family'] as String? ?? 'default',
      textColor: map['text_color'] as String? ?? 'black',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_date': createdDate.toIso8601String(),
      'last_modified': lastModified.toIso8601String(),
      'is_pinned': isPinned ? 1 : 0,
      'color_code': colorCode,
      'font_size': fontSize,
      'font_family': fontFamily,
      'text_color': textColor,
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdDate,
    DateTime? lastModified,
    bool? isPinned,
    String? colorCode,
    double? fontSize,
    String? fontFamily,
    String? textColor,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      lastModified: lastModified ?? this.lastModified,
      isPinned: isPinned ?? this.isPinned,
      colorCode: colorCode ?? this.colorCode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      textColor: textColor ?? this.textColor,
    );
  }
}
