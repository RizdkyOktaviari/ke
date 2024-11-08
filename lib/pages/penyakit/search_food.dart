import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/manage/manage.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/recipe_provider.dart';
import '../../models/resep_model.dart';
import '../food/add_food.dart';

class SearchFoodPage extends StatefulWidget {
  final Function(String, double) onFoodSelected;
  final String mealType; // Tambah parameter mealType

  SearchFoodPage({
    required this.onFoodSelected,
    required this.mealType, // Terima mealType dari MealMenuPage
  });

  @override
  _SearchFoodPageState createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  String query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecipeProvider>(context, listen: false).fetchRecipes());
  }

  // Fungsi untuk mendapatkan food_type sesuai mealType
  String _getFoodType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'breakfast';
      case 'lunch':
        return 'lunch';
      case 'dinner':
        return 'dinner';
      case 'snacks':
        return 'snack';
      default:
        return mealType.toLowerCase();
    }
  }
  String _getLocalizedMealType(BuildContext context, String mealType) {
    final localizations = AppLocalizations.of(context);
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return localizations!.breakfast;
      case 'lunch':
        return localizations!.lunch;
      case 'dinner':
        return localizations!.dinner;
      case 'snacks':
        return localizations!.snacks;
      default:
        return mealType;
    }
  }

  Future<void> _handleAddRecipe(Recipe recipe, String token) async {
    if (recipe.id == null) return;

    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final success = await recipeProvider.addFoodIntake(token, recipe.id!);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resep berhasil ditambahkan')),
      );
      double calories = 0.0;
      if (recipe.calories != null && recipe.calories!.isNotEmpty) {
        calories = double.tryParse(recipe.calories!) ?? 0.0;
      }
      widget.onFoodSelected(
        recipe.foodName ?? '',
        calories,
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(recipeProvider.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final foodType = _getFoodType(widget.mealType);
    final localizations = AppLocalizations.of(context);
    final localizedMealType = _getLocalizedMealType(context, widget.mealType);
    return Scaffold(
      appBar: AppBar(
        title:Text(localizations!.searchMeal(localizedMealType)),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: localizations!.searchFood,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                if (recipeProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                // Filter berdasarkan food_type dan search query
                final filteredRecipes = recipeProvider.recipes
                    .where((recipe) =>
                (recipe.foodType?.toLowerCase() == foodType) && // Filter by type
                    (recipe.foodName?.toLowerCase().contains(query) ?? false))
                    .toList();

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Text(
                      query.isEmpty
                          ? 'Tidak ada resep untuk ${widget.mealType}'
                          : 'Tidak ada hasil pencarian',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filteredRecipes.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          recipe.foodName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.foodType ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '${recipe.calories ?? 0}kcal | ',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  recipe.portion ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '${localizations.fat}: ${recipe.fat?.toString() ?? "0"}g | ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${localizations.totalCarbs}: ${recipe.carbohydrate?.toString() ?? "0"}g | ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${localizations.protein}: ${recipe.protein?.toString() ?? "0"}g',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: recipeProvider.isSubmitting
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : ElevatedButton(
                          onPressed: () => _handleAddRecipe(
                            recipe,
                            authProvider.token ?? '',
                          ),
                          child: Text(
                            localizations.addRecipe,
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagePage()),
          );
        },
        label: Text(
          localizations.createRecipe,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}