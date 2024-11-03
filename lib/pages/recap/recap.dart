import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/providers/recap_provider.dart';
import '../../models/recap_model.dart';


class RecapListPage extends StatefulWidget {
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
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.dailyRecap),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<RecapProvider>(
        builder: (context, recapProvider, child) {
          if (recapProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (recapProvider.error != null) {
            return Center(child: Text(recapProvider.error!));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: recapProvider.recaps.length,
            itemBuilder: (context, index) {
              final recap = recapProvider.recaps[index];
              return _buildRecapCard(recap, localizations);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecapCard(RecapModel recap, AppLocalizations localizations) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to detail page if needed
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:230.0),
                child: Text(
                  recap.date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 24),

              // Catatan Makanan
              _buildSection(
                localizations.foodNotes,
                Icons.restaurant,
                Colors.orange,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...recap.foodLogs.foods.map((food) => Text('${food.foodName}: ${food.calories} kcal')),
                    Divider(),
                    Text(
                      '${localizations.totalCaloriesConsumed} ${recap.foodLogs.totalCalories}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Catatan Minum
              _buildSection(
                localizations.drinkNotes,
                Icons.local_drink,
                Colors.blue,
                Text(recap.drinkLogs),
              ),

              // Aktivitas Fisik
              _buildSection(
                localizations.physicalActivity,
                Icons.directions_run,
                Colors.green,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recap.exerciseLogs.map((exercise) =>
                      Text('${exercise.exerciseName}: ${exercise.duration}, ${exercise.caloriesBurned}')
                  ).toList(),
                ),
              ),

              // Tekanan Darah
              if (recap.bloodPressure.isNotEmpty)
                _buildSection(
                  localizations.bloodPressureNote,
                  Icons.favorite,
                  Colors.red,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recap.bloodPressure.map((bp) =>
                        Text('${bp.toString()}')  // Sesuaikan dengan properti yang ada di model BloodPressure
                    ).toList(),
                  ),
                ),

              // Obat yang Dikonsumsi
              _buildSection(
                localizations.medicineTaken,
                Icons.medical_services,
                Colors.purple,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recap.medicineLogs.map((medicine) =>
                      Text('${medicine.medicineName} ${medicine.dosage} (${medicine.createdAt})')
                  ).toList(),
                ),
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, top: 4),
            child: content,
          ),
        ],
      ),
    );
  }
}