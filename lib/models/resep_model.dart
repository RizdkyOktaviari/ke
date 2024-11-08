
class Recipe {
  final int? id;
  final String? foodName;
  final String? description;
  final String? foodType;
  final String? portion;
  final String? calories;
  final String? protein;
  final String? fat;
  final String? carbohydrate;
  final String? sugar;
  final String? cholesterol;
  final String? mass;
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
  // Tambahkan method toJson
  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'description': description,
      'food_type': foodType,
      'portion': portion,
      'calories': calories?.toString(),
      'protein': protein?.toString(),
      'fat': fat?.toString(),
      'carbohydrate': carbohydrate?.toString(),
      'sugar': sugar?.toString(),
      'cholesterol': cholesterol?.toString(),
      'mass': mass?.toString(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int?,
      foodName: json['food_name'] as String?,
      description: json['description'] as String?,
      foodType: json['food_type'] as String?,
      portion: json['portion'] as String?,
      calories: json['calories'] as String?,
      protein: json['protein'] as String?,
      fat: json['fat'] as String?,
      carbohydrate: json['carbohydrate'] as String?,
      sugar: json['sugar'] as String?,
      cholesterol: json['cholesterol'] as String?,
      mass: json['mass'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }


}