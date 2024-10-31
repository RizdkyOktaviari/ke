import 'package:flutter/material.dart';
import '../../models/knowledge_model.dart';


class DetailPage extends StatelessWidget {
  final Knowledge knowledge;

  DetailPage({required this.knowledge});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(knowledge.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(8),
            //   child: Image.network(
            //     knowledge.imageUrl,
            //     width: double.infinity,
            //     height: 200,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(height: 20),
            Text(
              knowledge.title,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent
              ),
            ),


            SizedBox(height: 20),
            Text(
              knowledge.content,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700]
              ),
            ),
          ],
        ),
      ),
    );
  }
}