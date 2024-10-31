class Knowledge {
  final int id;
  final String title;
  final String content;
  final String slug;
  final String imageUrl;
  final String createdAt;

  Knowledge({
    required this.id,
    required this.title,
    required this.content,
    required this.slug,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      slug: json['slug'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
    );
  }
}
