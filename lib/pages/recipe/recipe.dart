import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/recipe/recipe_card.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
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
      body: ListView(
        children: [
          RecipeCard(
            imageUrl:
                'https://cdn.hellosehat.com/wp-content/uploads/2019/03/salad-sayur.jpg',
            title: 'Salat Campur',
            portion: '1 Porsi | 2 Bahan',
            fat: 1,
            carbs: 52,
            protein: 11,
            calories: 266,
            sodium: 47,
          ),
          RecipeCard(
            imageUrl:
                'https://cdn.hellosehat.com/wp-content/uploads/2019/03/salad-sayur.jpg',
            title: 'Ayam Bakar Madu',
            portion: '2 Porsi | 2 Bahan',
            fat: 20,
            carbs: 200,
            protein: 50,
            calories: 300,
            sodium: 80,
          ),
        ],
      ),
    );
  }
}
