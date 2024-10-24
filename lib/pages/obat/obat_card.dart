import 'package:flutter/material.dart';

class ObatCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String portion;
  final int fat;
  final int carbs;
  final int protein;
  final int calories;
  final int sodium;

  const ObatCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.portion,
    required this.fat,
    required this.carbs,
    required this.protein,
    required this.calories,
    required this.sodium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover, height: 200),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(portion),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionInfo(label: 'Fat', value: '$fat g'),
                    NutritionInfo(label: 'Carbs', value: '$carbs g'),
                    NutritionInfo(label: 'Protein', value: '$protein g'),
                    NutritionInfo(label: 'Cal', value: '$calories'),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$sodium', style: TextStyle(color: Colors.blue)),
                    Text(' mg', style: TextStyle(color: Colors.black)),
                  ],
                )),
                Center(
                    child:
                        Text('Sodium', style: TextStyle(color: Colors.black))),
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

  const NutritionInfo({Key? key, required this.label, required this.value})
      : super(key: key);

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
