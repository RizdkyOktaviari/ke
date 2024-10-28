import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/obat/obat_card.dart';

class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Daftar Obat'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          MedicineCard(
            imageUrl:
                'https://lifepack.id/wp-content/uploads/2020/06/Paracetamol-768x512.jpg',
            name: 'Paracetamol',
            type: 'Tablet',
            dosage: '500 mg',
            usage: 'Diminum 3x sehari',
            description: 'Obat untuk meredakan nyeri dan menurunkan demam',
            indications: ['Demam', 'Nyeri kepala', 'Nyeri otot'],
            warnings: [
              'Jangan melebihi dosis yang dianjurkan',
              'Hindari penggunaan jangka panjang'
            ],
          ),
          MedicineCard(
            imageUrl:
                'https://lifepack.id/wp-content/uploads/2020/06/Paracetamol-768x512.jpg',
            name: 'Amoxicillin',
            type: 'Kapsul',
            dosage: '500 mg',
            usage: 'Diminum 2x sehari',
            description: 'Antibiotik untuk mengobati infeksi bakteri',
            indications: [
              'Infeksi saluran pernapasan',
              'Infeksi saluran kemih',
              'Infeksi kulit'
            ],
            warnings: [
              'Harus habiskan sesuai anjuran dokter',
              'Jangan diminum dengan susu'
            ],
          ),
        ],
      ),
    );
  }
}
