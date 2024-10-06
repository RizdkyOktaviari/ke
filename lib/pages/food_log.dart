import 'package:flutter/material.dart';
import 'penyakit/search_food.dart';
import 'other/exercise.dart';
import 'other/notes.dart';
import 'other/water.dart';

class FoodLogPage extends StatefulWidget {
  final Map<String, double> foodEntries;

  FoodLogPage({super.key, required this.foodEntries});

  @override
  FoodLogPageState createState() => FoodLogPageState();
}

class FoodLogPageState extends State<FoodLogPage> {
  double totalCalories = 0;
  double totalExerciseCalories = 0;
  double totalWater = 0;
  String notes = '';

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
    });
  }

  void _addFoodEntry(String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFoodPage(
          onFoodSelected: (foodName, calories) {
            setState(() {
              widget.foodEntries[mealType] =
                  widget.foodEntries[mealType]! + calories;
              totalCalories += calories;
            });
          },
        ),
      ),
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
          },
        ),
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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildMealCard('Breakfast'),
        _buildMealCard('Lunch'),
        _buildMealCard('Dinner'),
        _buildMealCard('Snacks'),
        SizedBox(height: 20),
        _buildSummaryCard(),
        SizedBox(height: 20),
        _buildOtherSection(),
      ],
    );
  }

  Widget _buildMealCard(String mealType) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          mealType,
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
        subtitle: Text('${widget.foodEntries[mealType]} kcal'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _addFoodEntry(mealType);
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          'Total Calories Consumed',
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
        subtitle: Text('$totalCalories kcal'),
      ),
    );
  }

  Widget _buildOtherSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Other',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _buildOtherItem(
            'Exercise', '$totalExerciseCalories kCal', _addExerciseEntry),
        _buildOtherItem('Water', '$totalWater oz', _addWaterEntry),
        _buildOtherItem(
            'Notes', notes.isEmpty ? 'No notes yet' : notes, _addNoteEntry),
      ],
    );
  }

  Widget _buildOtherItem(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
