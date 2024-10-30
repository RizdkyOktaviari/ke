class FoodIntake {
  final int id;
  final int mUserId;
  final int recipeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Recipe recipe;

  FoodIntake({
    required this.id,
    required this.mUserId,
    required this.recipeId,
    required this.createdAt,
    required this.updatedAt,
    required this.recipe,
  });

  factory FoodIntake.fromJson(Map<String, dynamic> json) {
    return FoodIntake(
      id: json['id'],
      mUserId: json['m_user_id'],
      recipeId: json['recipe_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      recipe: Recipe.fromJson(json['recipe']),
    );
  }
}

class Recipe {
  final int id;
  final String foodName;
  final String description;
  final String foodType;
  final String portion;
  final int calories;
  final int protein;
  final int fat;
  final int carbohydrate;
  final int sugar;
  final int cholesterol;
  final int mass;
  final String image;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.foodName,
    required this.description,
    required this.foodType,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.sugar,
    required this.cholesterol,
    required this.mass,
    required this.image,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      foodName: json['food_name'],
      description: json['description'],
      foodType: json['food_type'],
      portion: json['portion'],
      calories: json['calories'],
      protein: json['protein'],
      fat: json['fat'],
      carbohydrate: json['carbohydrate'],
      sugar: json['sugar'],
      cholesterol: json['cholesterol'],
      mass: json['mass'],
      image: json['image'],
      imageUrl: json['image_url'],
    );
  }
}