// widgets/recipe_card.dart
import 'package:flutter/material.dart';
import '../../helpers/app_localizations.dart';
import '../../models/resep_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              recipe.imageUrl ?? 'https://via.placeholder.com/640x480',
              fit: BoxFit.cover,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.foodName ?? 'No Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('${recipe.portion ?? 'N/A'} ${localizations!.portion}  | ${recipe.foodType ?? 'N/A'}'),
                Text(
                  recipe.description ?? localizations.noDescriptionAvailable,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionInfo(label: localizations.fat, value: '${recipe.fat ?? 0} g'),
                    NutritionInfo(
                        label: localizations.carbs, value: '${recipe.carbohydrate ?? 0} g'),
                    NutritionInfo(
                        label: localizations.protein, value: '${recipe.protein ?? 0} g'),
                    NutritionInfo(
                        label: localizations.cal, value: '${recipe.calories ?? 0}'),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Column(
                    children: [
                      Text('${recipe.cholesterol ?? 0} mg',
                          style: TextStyle(color: Colors.blue)),
                      Text(localizations.cholesterol,
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionInfo extends StatelessWidget {
  final String label;
  final String value;

  const NutritionInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}