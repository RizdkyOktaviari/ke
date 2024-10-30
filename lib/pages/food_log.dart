// food_log_page.dart
import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/obat/home_add_obat.dart';
import 'package:provider/provider.dart';
import '../helpers/providers/food_log_provider.dart';
import '../models/recap_model.dart';
import 'food/home_food_menu.dart';
import 'other/blood.dart';
import 'other/exercise.dart';
import 'other/notes.dart';
import 'other/water.dart';

class FoodLogPage extends StatefulWidget {
  final Map<String, double> foodEntries;

  const FoodLogPage({super.key, required this.foodEntries});

  @override
  FoodLogPageState createState() => FoodLogPageState();
}

class FoodLogPageState extends State<FoodLogPage> {
  double totalCalories = 0;
  double totalExerciseCalories = 0;
  double totalWater = 0;
  double totalBlood = 0;
  double totalMedicine = 0;
  String notes = '';

  // Method untuk update state dari provider
  void updateStateFromProvider() {
    final provider = Provider.of<FoodLogProvider>(context, listen: false);
    final recap = provider.currentRecap;

    if (recap != null) {
      setState(() {
        // Reset foodEntries
        widget.foodEntries['Breakfast'] = 0;
        widget.foodEntries['Lunch'] = 0;
        widget.foodEntries['Dinner'] = 0;
        widget.foodEntries['Snacks'] = 0;

        // Update foodEntries berdasarkan data provider
        for (var food in recap.foodLogs.foods) {
          String mealType = food.foodName.split(':')[0].trim();
          widget.foodEntries[mealType] = (widget.foodEntries[mealType] ?? 0) + food.calories;
        }

        // Update total calories
        totalCalories = double.parse(recap.foodLogs.totalCalories.split(' ')[0]);

        // Update exercise calories
        if (recap.exerciseLogs.isNotEmpty) {
          totalExerciseCalories = recap.exerciseLogs
              .map((e) => double.parse(e.caloriesBurned))
              .fold(0, (sum, calories) => sum + calories);
        } else {
          totalExerciseCalories = 0;
        }

        // Update water intake
        if (recap.drinkLogs.isNotEmpty) {
          final match = RegExp(r'(\d+)').firstMatch(recap.drinkLogs);
          if (match != null) {
            totalWater = double.parse(match.group(1)!);
          }
        } else {
          totalWater = 0;
        }
      });
    } else {
      reset();
    }
  }

  void reset() {
    setState(() {
      widget.foodEntries['Breakfast'] = 0;
      widget.foodEntries['Lunch'] = 0;
      widget.foodEntries['Dinner'] = 0;
      widget.foodEntries['Snacks'] = 0;
      totalCalories = 0;
      totalExerciseCalories = 0;
      totalWater = 0;
      notes = '';
      // Reset provider juga
      Provider.of<FoodLogProvider>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodLogProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Update state ketika tanggal berubah
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updateStateFromProvider();
        });

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _buildMealCard('Breakfast'),
            _buildMealCard('Lunch'),
            _buildMealCard('Dinner'),
            _buildMealCard('Snacks'),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildOtherSection(),
          ],
        );
      },
    );
  }

  Widget _buildMealCard(String mealType) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          mealType,
          style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
        ),
        subtitle: Text('${widget.foodEntries[mealType]} kcal'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showMealMenu(mealType),
        ),
      ),
    );
  }

  void _showMealMenu(String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealMenuPage(
          mealType: mealType,
          onFoodAdded: (mealType, foodName, calories) {
            setState(() {
              widget.foodEntries[mealType] = widget.foodEntries[mealType]! + calories;
              totalCalories += calories;
              // Update provider
              Provider.of<FoodLogProvider>(context, listen: false)
                  .addFoodEntry(mealType, foodName, calories.toInt());
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: ListTile(
        title: const Text(
          'Total Calories Consumed',
          style: TextStyle(fontSize: 20, color: Colors.blueAccent),
        ),
        subtitle: Text('$totalCalories kcal'),
      ),
    );
  }

  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Other',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
        _buildOtherItem(
          'Exercise',
          '$totalExerciseCalories kCal',
          _addExerciseEntry,
        ),
        _buildOtherItem(
          'Water',
          '$totalWater oz',
          _addWaterEntry,
        ),
        _buildOtherItem(
          'Blood Pressure',
          '$totalBlood',
          _addBloodPressure,
        ),
        _buildOtherItem('Medicine', '$totalMedicine', _addMedicine),
        _buildOtherItem(
          'Notes',
          notes.isEmpty ? 'No notes yet' : notes,
          _addNoteEntry,
        ),
      ],
    );
  }

  Widget _buildOtherItem(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _addExerciseEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(
          onExerciseAdded: (caloriesBurned) {
            setState(() {
              totalExerciseCalories += caloriesBurned;
            });
            // Update provider
            final exerciseLog = ExerciseLog(
              exerciseName: 'Exercise',
              duration: '30 minutes',
              caloriesBurned: caloriesBurned.toString(),
            );
            Provider.of<FoodLogProvider>(context, listen: false)
                .addExerciseLog(exerciseLog);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addWaterEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaterPage(
          onWaterAdded: (water) {
            setState(() {
              totalWater += water;
            });
            // Update provider
            Provider.of<FoodLogProvider>(context, listen: false)
                .addWaterLog(water.toInt());
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addBloodPressure() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BloodPressurePage(),
      ),
    );
  }
  void _addMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeAddObat(),
      ),
    );
  }

  void _addNoteEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesPage(
          onNoteAdded: (note) {
            setState(() {
              notes = note;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}