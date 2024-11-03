import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/local_provider.dart';
import '../../models/register_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  Future<void> _register() async {
    if (!_validateInputs()) return;
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
      exerciseId: exerciseIds[selectedExercise] ?? 1,
      exerciseTimeSchedule: timeString,
      medicineName: _medicineController.text,
      medicineCount: _medicineCount,
    );

    final success = await context.read<AuthProvider>().register(data);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.registrationSuccess)),
      );
      Navigator.pop(context);
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordConfirmController.text.isEmpty ||
        _birthController.text.isEmpty ||
        _educationController.text.isEmpty ||
        _occupationController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _noteController.text.isEmpty ||
        _medicineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.allFieldsRequired)),
      );
      return false;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch)),
      );
      return false;
    }

    return true;
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

          return SingleChildScrollView(
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

                TextField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(l10n.name),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _usernameController,
                  decoration: _buildInputDecoration(l10n.username),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _buildInputDecoration(l10n.password),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  decoration: _buildInputDecoration(l10n.confirmPassword),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _birthController,
                  decoration: _buildInputDecoration(l10n.dateOfBirth),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _educationController,
                  decoration: _buildInputDecoration(l10n.education),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _occupationController,
                  decoration: _buildInputDecoration(l10n.occupation),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(l10n.howLongHaveYouHadHypertension),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: _phoneController,
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

                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Nama Aktifitas Fisik',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
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
                    ),
                  ],
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
                      child: TextField(
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

                TextField(
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
