import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String type;
  final String dosage;
  final String usage;
  final String description;
  final List<String> indications;
  final List<String> warnings;

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
  }) : super(key: key);

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
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                            TextStyle(color: Colors.red[700]))),
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
