import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../penyakit/search_food.dart';

class MealMenuPage extends StatefulWidget {
  final String mealType;
  final Function(String mealType, String foodName, double calories) onFoodAdded; // Tambahkan callback


  const MealMenuPage({Key? key, required this.mealType, required this.onFoodAdded}) : super(key: key);

  @override
  State<MealMenuPage> createState() => _MealMenuPageState();
}

class _MealMenuPageState extends State<MealMenuPage> {
  final List<String> imageList = [
    'assets/pic1.png',
    'assets/pic2.png',
    'assets/pic3.png',
  ];

  int _currentImageIndex = 0;
  void _addFoodEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFoodPage(
          mealType: widget.mealType,
          onFoodSelected: (foodName, calories) {
            widget.onFoodAdded(widget.mealType, foodName, calories);
            Navigator.pop(context); // Kembali ke MealMenuPage
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Menu ${widget.mealType}'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider for images
            Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 250.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16/9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                ),
                items: imageList.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(
                      _currentImageIndex == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tabel porsi yang direkomendasikan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Menu List Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu ${widget.mealType}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Add Menu Button
                  InkWell(
                    onTap:
                      _addFoodEntry
                    ,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Tambah Menu',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}