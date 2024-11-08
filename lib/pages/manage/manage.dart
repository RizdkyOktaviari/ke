import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/recipe_provider.dart';
import '../../models/resep_model.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: _ManagePageContent(),
    );
  }
}

class _ManagePageContent extends StatefulWidget {
  @override
  _ManagePageContentState createState() => _ManagePageContentState();
}

class _ManagePageContentState extends State<_ManagePageContent> {
  final _foodNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _portionController = TextEditingController();
  final _fatController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _sugarController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _massController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedFoodType = 'breakfast';
  final List<String> _foodTypes = ['breakfast', 'lunch', 'dinner', 'snacks'];
  void formatNumber(TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      // Coba parse nilai sebagai double
      double? value = double.tryParse(controller.text.replaceAll(',', '.'));
      if (value != null) {
        // Format angka dengan 1 digit desimal
        String formatted = value.toStringAsFixed(1);
        // Update controller hanya jika format berbeda
        if (controller.text != formatted) {
          controller.text = formatted;
          // Pindahkan cursor ke akhir
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: formatted.length),
          );
        }
      }
    }
  }

  double? parseNumericInput(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    // Replace comma with dot for proper parsing
    value = value.replaceAll(',', '.');
    // Try parsing as double
    return double.tryParse(value);
  }
  String? validateNumericField(String? value, String fieldName, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      // Menggunakan pesan spesifik untuk setiap field
      switch (fieldName) {
        case 'fat':
          return localizations.fatRequired;
        case 'protein':
          return localizations.proteinRequired;
        case 'carbs':
          return localizations.carbRequired;
        case 'sugar':
          return localizations.sugarRequired;
        case 'cholesterol':
          return localizations.cholesterolRequired;
        case 'weight':
          return localizations.weightRequired;
        default:
          return '${fieldName} is required';
      }
    }

    // Replace koma dengan titik untuk parsing yang benar
    value = value.replaceAll(',', '.');

    // Coba parse sebagai double
    final number = double.tryParse(value);
    if (number == null) {
      return localizations.enterValidNumber;
    }

    if (number < 0) {
      return localizations.enterNonNegativeNumber;
    }

    return null;
  }
  Future<void> _saveRecipe() async {
    final localizations = AppLocalizations.of(context);
    try {
      // Validate form
      if (!_formKey.currentState!.validate()) {
        return;
      }

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations!.notAuthenticated)),
        );
        return;
      }

      // Parse numeric values with validation
      double? calories = parseNumericInput(_carbsController.text);
      double? fat = parseNumericInput(_fatController.text);
      double? protein = parseNumericInput(_proteinController.text);
      double? carbs = parseNumericInput(_carbsController.text);
      double? sugar = parseNumericInput(_sugarController.text);
      double? cholesterol = parseNumericInput(_cholesterolController.text);
      double? mass = parseNumericInput(_massController.text);

      final recipe = Recipe(
        foodName: _foodNameController.text,
        description: _descriptionController.text,
        foodType: _selectedFoodType,
        portion: _portionController.text,
        calories: _carbsController.text,         // Gunakan text langsung
        protein: _proteinController.text,        // Gunakan text langsung
        fat: _fatController.text,                // Gunakan text langsung
        carbohydrate: _carbsController.text,     // Gunakan text langsung
        sugar: _sugarController.text,            // Gunakan text langsung
        cholesterol: _cholesterolController.text, // Gunakan text langsung
        mass: _massController.text,
      );

      final success = await Provider.of<RecipeProvider>(context, listen: false)
          .addRecipe(token, recipe);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations!.recipeAddedSuccessfully)),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Provider.of<RecipeProvider>(context, listen: false).error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations!.addRecipePage,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _foodNameController,
                  decoration: InputDecoration(
                    labelText: localizations.foodName,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.foodNameRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: localizations.description,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.descriptionRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _portionController,
                  decoration: InputDecoration(
                    labelText: localizations.portion,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.portionRequired;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(localizations.foodType),
                DropdownButtonFormField<String>(
                  value: _selectedFoodType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _foodTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type.substring(0, 1).toUpperCase() + type.substring(1)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFoodType = newValue;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(localizations.fat),
                TextFormField(
                  controller: _fatController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                    validator: (value) =>
                    validateNumericField(value, 'fat', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_fatController);
                    }
                  },


                ),
                SizedBox(height: 16),
                Text(localizations.protein),
                TextFormField(
                  controller: _proteinController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                  validator: (value) =>
                    validateNumericField(value, 'protein', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_proteinController);
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(localizations.carbohydrate),
                TextFormField(
                  controller: _carbsController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                  validator: (value) =>
                    validateNumericField(value, 'carbs', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_carbsController);
                    }
                  },

                ),
                SizedBox(height: 16),
                Text(localizations.sugar),
                TextFormField(
                  controller: _sugarController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0'
                  ),
                  validator:(value) =>
                    validateNumericField(value, 'sugar', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_sugarController);
                    }
                  },
                ),
                SizedBox(height: 16),
                Text(localizations.cholesterolInMg),
                TextFormField(
                  controller: _cholesterolController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                  validator: (value) =>
                    validateNumericField(value, 'cholesterol', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_cholesterolController);
                    }
                  },

                ),
                SizedBox(height: 16),
                Text(localizations.weightInG),
                TextFormField(
                  controller: _massController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '0',
                  ),
                  validator: (value) =>
                    validateNumericField(value, 'weight', context),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      formatNumber(_massController);
                    }
                  },

                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            recipeProvider.fileName.isEmpty
                                ? localizations.noFileChosen
                                : recipeProvider.fileName,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: recipeProvider.getImage,
                      child: Text(localizations.chooseFile),
                    ),
                  ],
                ),
                if (recipeProvider.image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.file(recipeProvider.image!, height: 200),
                  ),
                SizedBox(height: 20),
                Center(
                  child: recipeProvider.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    onPressed: _saveRecipe,
                    child: Text(
                      localizations.save,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _descriptionController.dispose();
    _portionController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _sugarController.dispose();
    _cholesterolController.dispose();
    _massController.dispose();
    super.dispose();
  }
}