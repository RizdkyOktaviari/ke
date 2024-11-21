// food_log_page.dart
import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/obat/home_add_obat.dart';
import 'package:provider/provider.dart';
import '../helpers/app_localizations.dart';
import '../helpers/providers/auth_provider.dart';
import '../helpers/providers/food_log_provider.dart';
import '../helpers/providers/note_provider.dart';
import '../models/note_model.dart';
import '../models/recap_model.dart';
import 'food/home_food_menu.dart';
import 'other/blood.dart';
import 'other/exercise.dart';
import 'other/notes.dart';
import 'other/water.dart';

class FoodLogPage extends StatefulWidget {
  const FoodLogPage({super.key});

  @override
  FoodLogPageState createState() => FoodLogPageState();
}

class FoodLogPageState extends State<FoodLogPage> {
  // Map untuk menyimpan total kalori per jenis makanan
  final Map<String, double> _foodEntries = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Snacks': 0,
  };

  @override
  void initState() {
    super.initState();
    // // Fetch data saat widget pertama kali dibuat
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<FoodLogProvider>(context, listen: false).fetchDailySummary();
    // });
  }

  // Helper method untuk mendapatkan jenis makanan dari nama makanan
  String _getMealType(String foodName) {
    String lowerFoodName = foodName.toLowerCase().trim();

    // Pemeriksaan spesifik untuk setiap kategori makanan
    if (lowerFoodName.startsWith('sarapan:')) {
      return 'Breakfast';
    }
    if (lowerFoodName.startsWith('makan siang:')) {
      return 'Lunch';
    }
    if (lowerFoodName.startsWith('makan malam:')) {
      return 'Dinner';
    }
    if (lowerFoodName.startsWith('makanan ringan:')) {
      return 'Snacks';
    }

    // Log untuk makanan yang tidak dikenali
    print('Unrecognized food name: $foodName');

    return 'Other';
  }

  void _updateFoodEntries(RecapModel recap) {
    // Reset semua nilai ke 0
    _foodEntries.updateAll((key, value) => 0);

    // Iterasi melalui semua makanan
    for (var food in recap.foodLogs.foods) {
      String mealType = _getMealType(food.foodName);

      // Debugging
      print('Food Name: ${food.foodName}, Meal Type: $mealType, Calories: ${food.calories}');

      // Pastikan tipe makanan ada di _foodEntries
      if (_foodEntries.containsKey(mealType)) {
        _foodEntries[mealType] = _foodEntries[mealType]! + food.calories.toDouble();
      }
    }

    // Cetak total kalori per kategori
    _foodEntries.forEach((key, value) {
      print('$key: $value calories');
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

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final recap = provider.currentRecap;
        if (recap == null) {
          return Center(child: Text(l10n.noDataAvailable));
        }

        _updateFoodEntries(recap);

        return RefreshIndicator(
          onRefresh: () => provider.fetchDailySummary(),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildMealSection(l10n),
              const SizedBox(height: 10),
              _buildCaloriesSummary(recap, l10n),
              const SizedBox(height: 20),
              _buildOtherActivities(recap, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealSection(AppLocalizations l10n) {
    final mealTypes = {
      'Breakfast': l10n.breakfast,
      'Lunch': l10n.lunch,
      'Dinner': l10n.dinner,
      'Snacks': l10n.snacks,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mealTypes.entries.map((entry) {
        double calories = _foodEntries[entry.key] ?? 0.0;
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              entry.value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${calories.toStringAsFixed(1)} ${l10n.kcal}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
              iconSize: 32,
              onPressed: () => _showMealMenu(entry.key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCaloriesSummary(RecapModel recap, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.totalCaloriesConsumed,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recap.foodLogs.totalCalories,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherActivities(RecapModel recap, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            l10n.other,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildActivityTile(
                // icon: Icons.directions_run,
                title: l10n.exercise,
                value: recap.exerciseLogs.isNotEmpty
                    ? recap.exerciseLogs.map((e) => '${e.exerciseName}: ${e.caloriesBurned}').join(', ')
                    : '0 ${l10n.kcal}',
                onTap: () => _navigateToExercise(),
              ),
              const Divider(height: 1),
              _buildActivityTile(
                // icon: Icons.water_drop,
                title: l10n.water,
                value: recap.drinkLogs.totalAmount,
                onTap: () => _navigateToWater(),
              ),
              const Divider(height: 1),
              _buildActivityTile(
                // icon: Icons.favorite,
                title: l10n.bloodPressure,
                value: recap.bloodPressure.isNotEmpty
                    ? recap.bloodPressure.last.summary
                    : l10n.noDataAvailable,
                onTap: () => _navigateToBloodPressure(),
              ),
              const Divider(height: 1),
              _buildActivityTile(
                // icon: Icons.medical_services,
                title: l10n.medicine,
                value: recap.medicineLogs.isNotEmpty
                    ? recap.medicineLogs.map((m) => m.summary).join(', ')
                    : l10n.noNotesYet,
                onTap: () => _navigateToMedicine(),
              ),
              const Divider(height: 1),
              _buildActivityTile(
                title: l10n.notes,
                value: recap.noteLogs.isNotEmpty
                    ? recap.noteLogs.map((note) => '${note.title}: ${note.content}').join('\n')
                    : l10n.noNotesYet,
                onTap: () => _navigateToNotes(),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile({
    // required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      subtitle: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showMealMenu(String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealMenuPage(
          mealType: mealType,
          onFoodAdded: (mealType, foodName, calories) async {
            await Provider.of<FoodLogProvider>(context, listen: false)
                .addFoodEntry(mealType, foodName, calories.toInt());
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _navigateToExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(
          onExerciseAdded: (caloriesBurned) async {
            final exerciseLog = ExerciseLog(
              exerciseName: 'Exercise',
              duration: '30 minutes',
              caloriesBurned: caloriesBurned.toString(),
            );
            await Provider.of<FoodLogProvider>(context, listen: false)
                .addExerciseLog(exerciseLog);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _navigateToWater() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaterPage(
          onWaterAdded: (water) async {
            await Provider.of<FoodLogProvider>(context, listen: false)
                .addWaterLog(water.toInt());
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
  void _navigateToNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesPage(
          onNoteAdded: (String content) async {
            // Refresh the daily summary after adding a note
            await Provider.of<FoodLogProvider>(context, listen: false)
                .fetchDailySummary();
          },
        ),
      ),
    );
  }

  void _navigateToBloodPressure() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BloodPressurePage(),
      ),
    );
  }

  void _navigateToMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeAddObat(),
      ),
    );
  }
}