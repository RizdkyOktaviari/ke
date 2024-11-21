import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
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
    final localizations = AppLocalizations.of(context);
    final drinkLog = DrinkLog(
      drinkName: localizations!.water,
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
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.waterIntake),
        backgroundColor: Colors.blueAccent,
      ),
      body:  !authProvider.isAuthenticated
          ? FutureBuilder(
        future: authProvider.handleUnauthorized(context),
        builder: (context, snapshot) => const SizedBox(),
      )
          :Consumer<WaterProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.enterWaterConsumed),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    waterConsumed = double.tryParse(value) ?? 0;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: localizations.enterWaterInMl,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitWaterIntake,
                  child: Text(localizations.addWaterIntake, style: TextStyle(color: Colors.white),),
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