import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/providers/recap_provider.dart';
import '../../models/recap_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/providers/recap_provider.dart';
import '../../models/recap_model.dart';


class RecapListPage extends StatefulWidget {
  const RecapListPage({super.key});

  @override
  _RecapListPageState createState() => _RecapListPageState();
}

class _RecapListPageState extends State<RecapListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecapProvider>(context, listen: false).fetchRecaps());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          localizations.dailyRecap,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<RecapProvider>(
        builder: (context, recapProvider, child) {
          if (recapProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recapProvider.error != null) {
            return Center(child: Text(recapProvider.error!));
          }

          final recaps = recapProvider.recaps;
          if (recaps.isEmpty) {
            return Center(
              child: Text(
                localizations.noDataAvailable,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            );
          }


          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recaps.length,
            itemBuilder: (context, index) {
              final recap = recaps[index];
              return _buildRecapCard(recap.date, recap, localizations);
            },
          );
        },
      ),
    );
  }


  Widget _buildRecapCard(String date, RecapModel recap, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Divider setelah tanggal
            const Divider(
              height: 24,
              thickness: 1,
              color: Colors.grey,
            ),

            // Food Section
            if (recap.foodLogs.foods.isNotEmpty) ...[
              _buildSectionTitle('🍽️ ${l10n.foodNotes}:', Colors.orange[700]!),
              ...recap.foodLogs.foods.map((food) =>
                  Text(food.foodName)),
              const SizedBox(height: 8),
              // Divider untuk makanan
              const Divider(
                height: 24,
                thickness: 1,
                color: Colors.grey,
              ),
              Text(
                'Total Kalori: ${recap.foodLogs.totalCalories}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),
            ],

            // Drink Section
            if (recap.drinkLogs.drinks.isNotEmpty) ...[
              _buildSectionTitle('🥤 ${l10n.drinkNotes}:', Colors.blue),
              ...recap.drinkLogs.drinks.map((drink) =>
                  Text(drink.drinkName)),
              const SizedBox(height: 8),

              const Divider(
                height: 24,
                thickness: 1,
                color: Colors.grey,
              ),
              Text(
                'Total: ${recap.drinkLogs.totalAmount}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
            ],

            // Exercise Section
            if (recap.exerciseLogs.isNotEmpty) ...[
              _buildSectionTitle('🏃 ${l10n.physicalActivity}:', Colors.green),
              ...recap.exerciseLogs.map((exercise) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.exerciseName),
                  Text('Durasi: ${exercise.duration}'),
                  Text('Kalori terbakar: ${exercise.caloriesBurned}'),
                ],
              )),
              const SizedBox(height: 16),
            ],

            // Blood Pressure Section
            if (recap.bloodPressure.isNotEmpty) ...[
              _buildSectionTitle('❤️ ${l10n.bloodPressure}:', Colors.red),
              ...recap.bloodPressure.map((bp) =>
                  Text('${bp.systolic}/${bp.diastolic} mmHg (${bp.createdAt})')),
              const SizedBox(height: 16),
            ],

            // Medicine Section
            if (recap.medicineLogs.isNotEmpty) ...[
              _buildSectionTitle('💊 ${l10n.medicineTaken}:', Colors.purple),
              ...recap.medicineLogs.map((medicine) =>
                  Text('${medicine.medicineName} ${medicine.dosage} (${medicine.createdAt})')),
            ],

            if (recap.foodLogs.foods.isEmpty &&
                recap.drinkLogs.drinks.isEmpty &&
                recap.exerciseLogs.isEmpty &&
                recap.bloodPressure.isEmpty &&
                recap.medicineLogs.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.noDataAvailable,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy', 'id').format(parsedDate);
  }
}