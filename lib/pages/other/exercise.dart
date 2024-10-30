import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/exercise_provider.dart';
import '../../models/exercise_model.dart';

class ExercisePage extends StatefulWidget {
  final Function(double) onExerciseAdded;

  ExercisePage({required this.onExerciseAdded});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  double weight = 70;
  double duration = 60;
  double caloriesBurned = 0;
  double distance = 0;
  String selectedExercise = 'Rowing Machine (Intense)';

  final Map<String, int> exerciseIds = {
    'Rowing Machine (Intense)': 1,
    'Low Impact Exercise': 2,
    'Running': 3,
    'Cycling': 4,
    'Swimming': 5,
    'Walking': 6,
    'Other': 7,
  };

  void _calculateCalories() {
    setState(() {
      caloriesBurned = weight * duration * 0.1;
    });
  }

  Future<void> _submitExercise() async {
    _calculateCalories();

    final exercise = Exercise(
      mExerciseId: exerciseIds[selectedExercise] ?? 1,
      description: selectedExercise,
      duration: duration.toInt(),
      calories: caloriesBurned.toInt(),
      distance: distance.toInt(),
    );

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    final success = await exerciseProvider.addExerciseLog(token, exercise);

    if (success) {
      widget.onExerciseAdded(caloriesBurned);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(exerciseProvider.error ?? 'Failed to add exercise')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<ExerciseProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your weight, exercise duration, and the activity to estimate your energy expenditure',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text('Weight (kg)'),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      weight = double.tryParse(value) ?? 70;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter weight in kg',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Duration (minutes)'),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      duration = double.tryParse(value) ?? 60;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter duration in minutes',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Distance (meters)'),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      distance = double.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter distance in meters',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Exercise Type'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedExercise,
                    onChanged: (newValue) {
                      setState(() {
                        selectedExercise = newValue!;
                      });
                    },
                    items: exerciseIds.keys.map((exercise) {
                      return DropdownMenuItem(
                        child: Text(exercise),
                        value: exercise,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitExercise,
                    child: Text('Calculate and Add'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Calories Burned: $caloriesBurned kCal',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}