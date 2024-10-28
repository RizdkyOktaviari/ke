import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  final Function(double) onExerciseAdded;

  ExercisePage({required this.onExerciseAdded});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  double weight = 70; // Default weight in kg
  double duration = 60; // Default duration in minutes
  double caloriesBurned = 0;
  String selectedExercise = 'Rowing Machine (Intense)';

  final List<String> exercises = [
    'Rowing Machine (Intense)',
    'Low Impact Exercise',
    'Running',
    'Cycling',
    'Swimming',
    'Walking',
    'Other'
  ];

  void _calculateCalories() {
    // Placeholder formula to calculate calories
    setState(() {
      caloriesBurned = weight * duration * 0.1; // Example calculation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
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
            Text('Exercise Type'),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedExercise,
              onChanged: (newValue) {
                setState(() {
                  selectedExercise = newValue!;
                });
              },
              items: exercises.map((exercise) {
                return DropdownMenuItem(
                  child: Text(exercise),
                  value: exercise,
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _calculateCalories();
                widget.onExerciseAdded(
                    caloriesBurned); // Pass calories back to the parent
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Calculate and Add'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Text('Calories Burned: $caloriesBurned kCal',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
