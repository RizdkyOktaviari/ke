import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/obat/obat_card.dart';

class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Medicine'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          ObatCard(
            imageUrl:
                'https://cdn.hellosehat.com/wp-content/uploads/2019/03/salad-sayur.jpg',
            title: 'Paracetamol',
            portion: '1 Porsi | 2 Bahan',
            fat: 1,
            carbs: 52,
            protein: 11,
            calories: 266,
            sodium: 47,
          ),
          ObatCard(
            imageUrl:
                'https://cdn.hellosehat.com/wp-content/uploads/2019/03/salad-sayur.jpg',
            title: 'Asam Afenamat',
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
