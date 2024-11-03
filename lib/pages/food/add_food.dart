// add food page
import 'package:flutter/material.dart';

import '../../helpers/app_localizations.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  AddFoodPageState createState() => AddFoodPageState();
}

class AddFoodPageState extends State<AddFoodPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.addFood),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: localizations!.addFood,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(
                hintText: localizations!.calories,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text;
                final double calories = double.parse(caloriesController.text);

                // Add the new food item to the list
                var foodItems = [];
                foodItems.add({'name': name, 'calories': calories});

                // Go back to the previous page
                Navigator.pop(context);
              },
              child: Text(
                localizations!.addFood,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
