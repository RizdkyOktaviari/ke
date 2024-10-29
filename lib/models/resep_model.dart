
class Recipe {
  final int? id;
  final String? foodName;
  final String? description;
  final String? foodType;
  final String? portion;
  final int? calories;
  final int? protein;
  final int? fat;
  final int? carbohydrate;
  final int? sugar;
  final int? cholesterol;
  final int? mass;
  final String? image;
  final String? imageUrl;

  Recipe({
    this.id,
    this.foodName,
    this.description,
    this.foodType,
    this.portion,
    this.calories,
    this.protein,
    this.fat,
    this.carbohydrate,
    this.sugar,
    this.cholesterol,
    this.mass,
    this.image,
    this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int?,
      foodName: json['food_name'] as String?,
      description: json['description'] as String?,
      foodType: json['food_type'] as String?,
      portion: json['portion'] as String?,
      calories: json['calories'] as int?,
      protein: json['protein'] as int?,
      fat: json['fat'] as int?,
      carbohydrate: json['carbohydrate'] as int?,
      sugar: json['sugar'] as int?,
      cholesterol: json['cholesterol'] as int?,
      mass: json['mass'] as int?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}