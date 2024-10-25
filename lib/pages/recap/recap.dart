import 'package:flutter/material.dart';

class RecapListPage extends StatelessWidget {
  // Data dummy untuk rekapan
  final List<Map<String, dynamic>> recapData = [
    {
      'date': '24 Oktober 2024',
      'total_food': {
        'breakfast': 'Nasi Goreng',
        'lunch': 'Gado-gado',
        'dinner': 'Soup',
        'snack': 'Buah',
        'calories': 1200,
      },
      'total_drink': {
        'amount': 2000,
        'count': 8,
      },
      'physical_activity': {
        'type': 'Jogging',
        'duration': '30 menit',
        'calories_burned': 300,
      },
      'blood_pressure': {
        'systolic': 120,
        'diastolic': 80,
        'time': '08:00',
      },
      'medicines': [
        {'name': 'Paracetamol', 'dosage': '500mg', 'time': '07:00'},
        {'name': 'Vitamin C', 'dosage': '250mg', 'time': '19:00'},
      ],
    },
    // Data dummy lainnya dengan format yang sama
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekapan Harian'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: recapData.length,
        itemBuilder: (context, index) {
          final data = recapData[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                // Navigate to detail page
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal
                    Text(
                      data['date'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(height: 24),

                    // Konsumsi Makanan
                    _buildSection(
                      'Catatan Makanan:',
                      Icons.restaurant,
                      Colors.orange,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMealRow(
                              'Sarapan', data['total_food']['breakfast']),
                          _buildMealRow(
                              'Makan Siang', data['total_food']['lunch']),
                          _buildMealRow(
                              'Makan Malam', data['total_food']['dinner']),
                          _buildMealRow('Cemilan', data['total_food']['snack']),
                          Divider(),
                          Text(
                            'Total Kalori: ${data['total_food']['calories']} kkal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // Konsumsi Minuman
                    _buildSection(
                      'Catatan Minum:',
                      Icons.local_drink,
                      Colors.blue,
                      Text(
                        '${data['total_drink']['amount']} ml (${data['total_drink']['count']} kali minum)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    // Aktivitas Fisik
                    _buildSection(
                      'Aktivitas Fisik:',
                      Icons.directions_run,
                      Colors.green,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${data['physical_activity']['type']}'),
                          Text(
                              'Durasi: ${data['physical_activity']['duration']}'),
                          Text(
                              'Kalori Terbakar: ${data['physical_activity']['calories_burned']} kkal'),
                        ],
                      ),
                    ),

                    // Tekanan Darah
                    _buildSection(
                      'Tekanan Darah:',
                      Icons.favorite,
                      Colors.red,
                      Text(
                        '${data['blood_pressure']['systolic']}/${data['blood_pressure']['diastolic']} mmHg (${data['blood_pressure']['time']})',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    // Obat yang Dikonsumsi
                    _buildSection(
                      'Obat Dikonsumsi:',
                      Icons.medical_services,
                      Colors.purple,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var medicine in data['medicines'])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                '${medicine['name']} ${medicine['dosage']} (${medicine['time']})',
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Navigate to detail page
                          },
                          child: Row(
                            children: [
                              Text('Lihat Detail'),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
      String title, IconData icon, Color color, Widget content) {
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

  Widget _buildMealRow(String label, String meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label + ':',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(meal)),
        ],
      ),
    );
  }
}
