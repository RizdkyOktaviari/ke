import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/recipe/recipe_card.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/recipe_provider.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecipeProvider>(context, listen: false).fetchRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Recipe'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (recipeProvider.error.isNotEmpty) {
            return Center(child: Text(recipeProvider.error));
          }

          return ListView.builder(
            itemCount: recipeProvider.recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipeProvider.recipes[index];
              return RecipeCard(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}