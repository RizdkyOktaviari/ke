import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/blood_provider.dart';
import '../../models/blood_model.dart';

class BloodPressurePage extends StatefulWidget {
  const BloodPressurePage({super.key});

  @override
  State<BloodPressurePage> createState() => _BloodPressurePageState();
}

class _BloodPressurePageState extends State<BloodPressurePage> {
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  Future<void> _submitBloodPressure() async {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);

    if (systolic == null || diastolic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    final bloodPressure = BloodPressure(
      systolicPressure: systolic,
      diastolicPressure: diastolic,
    );

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final provider = Provider.of<BloodPressureProvider>(context, listen: false);
    final success = await provider.addBloodPressure(token, bloodPressure);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to save blood pressure')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations!.bloodPressureTitle),
        backgroundColor: Colors.blueAccent,
      ),
      body:  !authProvider.isAuthenticated
          ? FutureBuilder(
        future: authProvider.handleUnauthorized(context),
        builder: (context, snapshot) => const SizedBox(),
      )
          :Consumer<BloodPressureProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.checkBloodPressure,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TextField(
                      controller: _systolicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Sistolik',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: TextField(
                      controller: _diastolicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Diastolik',
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitBloodPressure,
                      child: Text(
                        localizations.save,
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }
}