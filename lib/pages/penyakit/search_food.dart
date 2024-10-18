import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/food/add_food.dart';

class SearchFoodPage extends StatefulWidget {
  final Function(String, double)
      onFoodSelected; // Callback to send back food info

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
          backgroundColor: Colors.blueAccent,
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
                            widget.onFoodSelected(
                                item['name'], item['calories']);
                            Navigator.pop(
                                context); // Go back to the previous page
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            // Navigate to the AddFoodPage
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddFoodPage();
            }));
          },
          label: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 25),
        ));
  }
}
