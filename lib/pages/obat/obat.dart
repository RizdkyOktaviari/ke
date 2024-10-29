import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kesehatan_mobile/pages/obat/obat_card.dart';

import '../../helpers/providers/medicine_provider.dart';

class ObatPage extends StatefulWidget {
  const ObatPage({Key? key}) : super(key: key);

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MedicineProvider>(context, listen: false).fetchMedicines());
  }

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
      body: Consumer<MedicineProvider>(
        builder: (context, medicineProvider, child) {
          if (medicineProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (medicineProvider.error != null) {
            return Center(child: Text(medicineProvider.error!));
          }

          return ListView.builder(
            itemCount: medicineProvider.medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicineProvider.medicines[index];
              return MedicineCard(
                imageUrl: medicine.imageUrl ?? 'https://via.placeholder.com/150',
                name: medicine.name ?? 'Nama tidak tersedia',
                type: medicine.type ?? 'Tipe tidak tersedia',
                dosage: medicine.mass ?? 'Dosis tidak tersedia',
                usage: medicine.howToUse ?? 'Cara penggunaan tidak tersedia',
                description: medicine.description ?? 'Deskripsi tidak tersedia',
                indications: medicine.indications?.split(',').where((s) => s.isNotEmpty).toList() ?? ['Indikasi tidak tersedia'],
                warnings: medicine.warnings?.split(',').where((s) => s.isNotEmpty).toList() ?? ['Peringatan tidak tersedia'],
              );
            },
          );
        },
      ),
    );
  }
}