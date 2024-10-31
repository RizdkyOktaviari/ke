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
}