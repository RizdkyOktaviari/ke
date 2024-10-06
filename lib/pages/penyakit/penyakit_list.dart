import 'package:flutter/material.dart';
import 'detail.dart';
class PenyakitListPage extends StatelessWidget {
  final List<Pengetahuan> pengetahuanList = [
    Pengetahuan(
      title: 'Hipertensi',
      description: 'Tekanan darah tinggi adalah kondisi kronis...',
    ),
    Pengetahuan(
      title: 'Diabetes',
      description: 'Diabetes adalah penyakit kronis yang ditandai oleh kadar gula darah tinggi...',
    ),
    Pengetahuan(
      title: 'Kolesterol Tinggi',
      description: 'Kolesterol tinggi dapat menyebabkan berbagai masalah kesehatan serius...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Penyakit'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: pengetahuanList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                pengetahuanList[index].title,
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              ),
              subtitle: Text(pengetahuanList[index].description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(pengetahuan: pengetahuanList[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Pengetahuan {
  final String title;
  final String description;

  Pengetahuan({required this.title, required this.description});
}
