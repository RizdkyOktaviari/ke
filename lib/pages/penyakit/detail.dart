import 'package:flutter/material.dart';
import '../main.dart';
import 'penyakit_list.dart';

class DetailPage extends StatelessWidget {
  final Pengetahuan pengetahuan;

  DetailPage({required this.pengetahuan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pengetahuan.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengetahuan.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            SizedBox(height: 20),
            Text(
              pengetahuan.description,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}