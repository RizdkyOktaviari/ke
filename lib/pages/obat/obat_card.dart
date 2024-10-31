import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/medicine_provider.dart';
import '../../models/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String type;
  final String dosage;
  final String usage;
  final String description;
  final List<String> indications;
  final List<String> warnings;
  final bool showAddButton;
  final int? medicineId;

  const MedicineCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.dosage,
    required this.usage,
    required this.description,
    required this.indications,
    required this.warnings,
    this.showAddButton = false,
    this.medicineId,
  }) : super(key: key);

  Future<void> _addMedicine(BuildContext context) async {
    final log = MedicineLog(
      medicineId: medicineId!,
      quantity: 1,
      datetime: DateTime.now().toIso8601String(),
    );

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not authenticated')),
      );
      return;
    }

    final provider = Provider.of<MedicineProvider>(context, listen: false);
    final success = await provider.addMedicineLog(token, log);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Medicine added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to add medicine')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
    if (showAddButton) // Move ADD button here
    ElevatedButton(
    onPressed: () => _addMedicine(context),
    child: Text('ADD', style: TextStyle(color: Colors.white),),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    ),
    ),
                  ],
                ),

                SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(type, Colors.blue),
                    SizedBox(width: 8),
                    _buildInfoChip(dosage, Colors.green),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Aturan Pakai:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(usage),
                SizedBox(height: 8),
                Text(
                  'Deskripsi:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
                SizedBox(height: 16),
                Text(
                  'Indikasi:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: indications
                      .map((indication) => Padding(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• '),
                                Expanded(child: Text(indication)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                Text(
                  'Peringatan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Column(
                  children: warnings
                      .map((warning) => Padding(
                            padding: EdgeInsets.only(left: 16, top: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('! ', style: TextStyle(color: Colors.red)),
                                Expanded(
                                    child: Text(warning,
                                        style:
                                            TextStyle(color: Colors.red[700])))
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
