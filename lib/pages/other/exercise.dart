import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
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
  ExerciseModel? selectedExercise;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExerciseProvider>(context, listen: false).fetchExercises();
    });
  }


  final Map<String, int> exerciseIds = {
    'Rowing Machine (Intense)': 1,
    'Low Impact Exercise': 2,
    'Running': 3,
    'Cycling': 4,
    'Swimming': 5,
    'Walking': 6,
    'Other': 7,
  };
  String _getLocalizedExerciseName(AppLocalizations localizations, String exerciseKey) {
    switch (exerciseKey) {
      case 'Rowing Machine (Intense)':
        return localizations.rowingMachineIntense;
      case 'Low Impact Exercise':
        return localizations.lowImpactExercise;
      case 'Running':
        return localizations.running;
      case 'Cycling':
        return localizations.cycling;
      case 'Swimming':
        return localizations.swimming;
      case 'Walking':
        return localizations.walking;
      case 'Other':
        return localizations.other;
      default:
        return exerciseKey;
    }
  }

  void _calculateCalories() {
    setState(() {
      caloriesBurned = weight * duration * 0.1;
    });
  }

  Future<void> _submitExercise() async {
    if (selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an exercise')),
      );
      return;
    }

    _calculateCalories();

    final exercise = Exercise(
      mExerciseId: selectedExercise!.id,
      description: selectedExercise!.description,
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
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.exercise),
        backgroundColor: Colors.blueAccent,
      ),
      body: !authProvider.isAuthenticated
          ? FutureBuilder(
        future: authProvider.handleUnauthorized(context),
        builder: (context, snapshot) => const SizedBox(),
      )
          :Consumer<ExerciseProvider>(
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
                    localizations.exerciseInstructions,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(localizations.weightInKg),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      weight = double.tryParse(value) ?? 70;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localizations.enterWeightInKg,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(localizations.durationInMinutes),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      duration = double.tryParse(value) ?? 60;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localizations.enterDurationInMinutes,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(localizations.distanceInMeters),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      distance = double.tryParse(value) ?? 0;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localizations.enterDistanceInMeters,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(localizations.exerciseType),
                  DropdownButtonFormField<ExerciseModel>(
                    value: selectedExercise,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder()
                    ),
                    items: provider.exercises.map((exercise) {
                      return DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise.exerciseName),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedExercise = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitExercise,
                    child: Text(localizations.calculateAndAdd),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  ),
                  SizedBox(height: 20),
                  Text(
                    localizations.caloriesBurnedFormat(caloriesBurned),
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