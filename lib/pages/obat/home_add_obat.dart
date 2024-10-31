import 'package:flutter/material.dart';

import 'obat.dart';

class HomeAddObat extends StatefulWidget {
  const HomeAddObat({Key? key}) : super(key: key);

  @override
  State<HomeAddObat> createState() => _HomeAddObatState();
}

class _HomeAddObatState extends State<HomeAddObat> {
  void _addFoodEntry() {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => ObatPage(showAddButton: true)));}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Record daily medicines!", style: TextStyle(fontSize: 16, color: Colors.black),),
            SizedBox(height: 60,),
            InkWell(
              onTap:
              _addFoodEntry
              ,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Tambah Obat',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ))
    );
  }
}
