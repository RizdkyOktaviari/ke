import 'package:flutter/material.dart';

class WaterPage extends StatefulWidget {
  final Function(double) onWaterAdded;

  WaterPage({required this.onWaterAdded});

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  double waterConsumed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the amount of water consumed (in ounces):'),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                waterConsumed = double.tryParse(value) ?? 0;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter water in oz',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onWaterAdded(waterConsumed);
                Navigator.pop(context);
              },
              child: Text('Add Water Intake'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
