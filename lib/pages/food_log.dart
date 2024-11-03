// food_log_page.dart
import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/obat/home_add_obat.dart';
import 'package:provider/provider.dart';
import '../helpers/app_localizations.dart';
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
  String totalMedicine = '';
  String notes = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        updateStateFromProvider();
        _isInitialized = true;
      }
    });
  }

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
      totalMedicine = '';
      // Reset provider juga
      Provider.of<FoodLogProvider>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<FoodLogProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final mealTypes = {
          'Breakfast': l10n.breakfast,
          'Lunch': l10n.lunch,
          'Dinner': l10n.dinner,
          'Snacks': l10n.snacks,
        };


        // Update state ketika tanggal berubah
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updateStateFromProvider();
        });

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ...mealTypes.entries.map((entry) =>
                _buildMealCard(entry.value, entry.key)
            ),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildOtherSection(),
          ],
        );
      },
    );
  }

  Widget _buildMealCard(String displayName, String mealType) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          displayName,
          style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
        ),
        subtitle: Text('${widget.foodEntries[mealType]} ${l10n.kcal}'),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          l10n.totalCaloriesConsumed,
          style: TextStyle(fontSize: 20, color: Colors.blueAccent),
        ),
        subtitle: Text('$totalCalories ${l10n.kcal}'),
      ),
    );
  }


  Widget _buildOtherSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            l10n.other,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
        _buildOtherItem(
          l10n.exercise,
          '$totalExerciseCalories ${l10n.kcal}',
          _addExerciseEntry,
        ),
        _buildOtherItem(
          l10n.water,
          '$totalWater ${l10n.oz}',
          _addWaterEntry,
        ),
        _buildOtherItem(
          l10n.bloodPressure,
          '$totalBlood',
          _addBloodPressure,
        ),
        _buildOtherItem(
            l10n.medicine,
            totalMedicine.isEmpty ? l10n.noNotesYet : totalMedicine,
            _addMedicine
        ),
        _buildOtherItem(
          l10n.notes,
          notes.isEmpty ? l10n.noNotesYet : notes,
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