class Note {
  final String title;
  final String content;

  Note({
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };

  factory Note.fromJson(Map<String, dynamic> json) {
    // Handle potential null or non-string values
    String? titleValue = json['title']?.toString();
    String? contentValue = json['content']?.toString();

    return Note(
      title: titleValue ?? '',
      content: contentValue ?? '',
    );
  }
}