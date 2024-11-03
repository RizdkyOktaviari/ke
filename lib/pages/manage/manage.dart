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

  Future<void> _saveRecipe() async {
    final localizations = AppLocalizations.of(context);
    try {
      // Validasi input
      if (_foodNameController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(localizations!.enterNameAndDescription)),
        );
        return;
      }

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations!.notAuthenticated)),
        );
        return;
      }

      final recipe = Recipe(
        foodName: _foodNameController.text,
        description: _descriptionController.text,
        foodType: 'breakfast', // or dynamic dropdown value
        portion: _portionController.text,
        calories: int.tryParse(_carbsController.text) ?? 0, // Calculate calories
        protein: int.tryParse(_proteinController.text),
        fat: int.tryParse(_fatController.text),
        carbohydrate: int.tryParse(_carbsController.text),
        sugar: int.tryParse(_sugarController.text),
        cholesterol: int.tryParse(_cholesterolController.text),
        mass: int.tryParse(_massController.text),
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
          SnackBar(
            content: Text(
                Provider.of<RecipeProvider>(context, listen: false).error
            ),
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _foodNameController,
                decoration: InputDecoration(
                  labelText: localizations.foodName,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: localizations.description,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _portionController,
                decoration: InputDecoration(
                  labelText: localizations.portion,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.fat),
              TextField(
                controller: _fatController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.protein),
              TextField(
                controller: _proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.carbohydrate),
              TextField(
                controller: _carbsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.sugar),
              TextField(
                controller: _sugarController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.cholesterolInMg),
              TextField(
                controller: _cholesterolController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
              ),
              SizedBox(height: 16),
              Text(localizations.weightInG),
              TextField(
                controller: _massController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
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