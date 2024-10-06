import 'package:flutter/material.dart';

class SearchFoodPage extends StatefulWidget {
  final Function(String, double) onFoodSelected; // Callback to send back food info

  SearchFoodPage({required this.onFoodSelected});

  @override
  _SearchFoodPageState createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  String query = '';

  final List<Map<String, dynamic>> foodItems = [
    {'name': 'Puerto Rican Style Stewed Pigeon Peas', 'calories': 252.0},
    {'name': 'Sari Gandum', 'calories': 90.0},
    // Add more food items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search food...',
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
            child: ListView(
              children: foodItems
                  .where((item) => item['name'].toLowerCase().contains(query))
                  .map((item) => ListTile(
                        title: Text(item['name']),
                        subtitle: Text('${item['calories']} kcal'),
                        onTap: () {
                          widget.onFoodSelected(item['name'], item['calories']);
                          Navigator.pop(context); // Go back to the previous page
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}