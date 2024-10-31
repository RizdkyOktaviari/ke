import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/water_provider.dart';
import '../../models/water_model.dart';

class WaterPage extends StatefulWidget {
  final Function(double) onWaterAdded;

  WaterPage({required this.onWaterAdded});

  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  double waterConsumed = 0;

  Future<void> _submitWaterIntake() async {
    final drinkLog = DrinkLog(
      drinkName: 'Water',
      amount: waterConsumed.toInt(),
    );

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final waterProvider = Provider.of<WaterProvider>(context, listen: false);
    final success = await waterProvider.addDrinkLog(token, drinkLog);

    if (success) {
      widget.onWaterAdded(waterConsumed);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(waterProvider.error ?? 'Failed to add water intake')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<WaterProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter the amount of water consumed (in ml):'),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    waterConsumed = double.tryParse(value) ?? 0;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter water in ml',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitWaterIntake,
                  child: Text('Add Water Intake'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}