class Medicine {
  final String? id;
  final String? name;
  final String? type;
  final String? mass;
  final String? howToUse;
  final String? description;
  final String? indications;
  final String? warnings;
  final String? imageUrl;

  Medicine({
    this.id,
    this.name,
    this.type,
    this.mass,
    this.howToUse,
    this.description,
    this.indications,
    this.warnings,
    this.imageUrl,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      mass: json['mass']?.toString(),
      howToUse: json['how_to_use']?.toString(),
      description: json['description']?.toString(),
      indications: json['indications']?.toString(),
      warnings: json['warnings']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}