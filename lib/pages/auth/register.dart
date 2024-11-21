import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/exercise_provider.dart';
import '../../helpers/providers/local_provider.dart';
import '../../models/exercise_model.dart';
import '../../models/register_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _validateName(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.nameRequired;
    }
    if (value.length < 3) {
      return localizations.nameTooShort;
    }
    return null;
  }

  String? _validateUsername(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.usernameRequired;
    }
    if (value.length < 4) {
      return localizations.usernameTooShort;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.passwordRequired;
    }
    if (value.length < 8) {
      return localizations.passwordTooShort;
    }
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return localizations.passwordsDoNotMatch;
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.birthDateRequired;
    }
    // Validasi format tanggal YYYY-MM-DD
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return localizations.invalidDateFormat;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.phoneRequired;
    }
    if (!RegExp(r'^\d{10,13}$').hasMatch(value)) {
      return localizations.invalidPhoneFormat;
    }
    return null;
  }

  String? _validateDuration(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.durationRequired;
    }
    if (int.tryParse(value) == null) {
      return localizations.invalidNumberFormat;
    }
    return null;
  }
  String? _validateEducation(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.educationRequired;
    }
    return null;
  }

  String? _validateOccupation(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.occupationRequired;
    }
    return null;
  }

  String? _validateMedicineName(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.medicineNameRequired;
    }
    return null;
  }

  String? _validateNote(String? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.bloodPressureNoteRequired;
    }
    if (value.length < 4) {
      return localizations.bloodPressureNoteTooShort;
    }
    return null;
  }
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _birthController = TextEditingController();
  final _educationController = TextEditingController();
  final _occupationController = TextEditingController();
  final _durationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  final _medicineController = TextEditingController();
  ExerciseModel? selectedExercise;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ExerciseProvider>(context, listen: false).fetchExercises();
    // });
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

  String _selectedGender = 'M';
  int _medicineCount = 0;

  Widget _buildLanguageButton(String label, VoidCallback onPressed, bool isSelected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String? _validateExercise(ExerciseModel? value) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null) {
      return localizations.exerciseTypeRequired;
    }
    return null;
  }


  Future<void> _register() async {
    final localizations = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      final timeString = '$hour:$minute';

      final data = RegisterData(
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmController.text,
        dateOfBirth: _birthController.text,
        education: _educationController.text,
        occupation: _occupationController.text,
        durationOfHypertension: int.parse(_durationController.text),
        phoneNumber: _phoneController.text,
        gender: _selectedGender,
        noteHypertension: _noteController.text,
        exerciseId: selectedExercise!.id,
        exerciseTimeSchedule: timeString,
        medicineName: _medicineController.text,
        medicineCount: _medicineCount,
      );

      final success = await context.read<AuthProvider>().register(data);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.registrationSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final error = context.read<AuthProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? localizations.registrationFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.unexpectedError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.blue,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<LocaleProvider>(
                builder: (context, provider, child) => Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.locale.languageCode == 'id'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () async {
                        await provider.setLocaleByCode('id');
                        setState(() {}); // Refresh UI
                      },
                      child: Text(
                        'ID',
                        style: TextStyle(
                          color: provider.locale.languageCode == 'id'
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.locale.languageCode == 'en'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () async {
                        await provider.setLocaleByCode('en');
                        setState(() {}); // Refresh UI
                      },
                      child: Text(
                        'EN',
                        style: TextStyle(
                          color: provider.locale.languageCode == 'en'
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.createAccount,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    l10n.signUpToGetStarted,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),

                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration(l10n.name),
                    validator: _validateName,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _usernameController,
                    decoration: _buildInputDecoration(l10n.username),
                    validator: _validateUsername,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _buildInputDecoration(l10n.password),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: true,
                    decoration: _buildInputDecoration(l10n.confirmPassword),
                    validator: _validatePasswordConfirm,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _birthController,
                    decoration: _buildInputDecoration(l10n.dateOfBirth),
                    validator: _validateBirthDate,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _educationController,
                    decoration: _buildInputDecoration(l10n.education),
                    validator: _validateEducation,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _occupationController,
                    decoration: _buildInputDecoration(l10n.occupation),
                    validator: _validateOccupation,
                  ),
                  SizedBox(height: 16),
            
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    validator: _validateDuration,
                    decoration: _buildInputDecoration(l10n.howLongHaveYouHadHypertension),
                  ),
                  SizedBox(height: 16),
            
                  TextFormField(
                    controller: _phoneController,
                    validator: _validatePhone,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration(l10n.phone),
                  ),
                  SizedBox(height: 24),
            
                  Text(
                    l10n.notificationSettings,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),

                  Consumer<ExerciseProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.physicalActivity,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(
                            child: provider.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonFormField<ExerciseModel>(
                              value: selectedExercise,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                              validator: _validateExercise,
                              items: provider.exercises.map((exercise) {
                                return DropdownMenuItem<ExerciseModel>(
                                  value: exercise,
                                  child: Text(
                                    exercise.exerciseName,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (ExerciseModel? newValue) {
                                setState(() {
                                  selectedExercise = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Waktu Aktifitas Fisik',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('${_selectedTime.format(context)}'),
                          trailing: Icon(Icons.access_time),
                          onTap: () async {
                            final TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (timeOfDay != null) {
                              setState(() {
                                _selectedTime = timeOfDay;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.medicine,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          validator: _validateMedicineName,
                          controller: _medicineController,
                          decoration: _buildInputDecoration('Nama Obat'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
            
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.timesPerDay,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownButton<int>(
                          value: _medicineCount,
                          items: [0,1,2,3,4,5].map((count) {
                            return DropdownMenuItem(
                              value: count,
                              child: Text('$count kali'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _medicineCount = value ?? 0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
            
                  Text(
                    l10n.gender,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(AppLocalizations.of(context)!.male),
                          value: 'M',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(AppLocalizations.of(context)!.female),
                          value: 'F',
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
            
                  TextFormField(
                    validator: _validateNote,
                    controller: _noteController,
                    maxLines: 3,
                    decoration: _buildInputDecoration(l10n.bloodPressureNote),
                  ),
                  SizedBox(height: 30),
            
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        auth.error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _register,
                      child: Text(
                        l10n.signUp,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.blue[200]),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _birthController.dispose();
    _educationController.dispose();
    _occupationController.dispose();
    _durationController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    _medicineController.dispose();
    super.dispose();
  }
}
