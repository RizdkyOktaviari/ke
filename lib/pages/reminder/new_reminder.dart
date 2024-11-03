import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/pages/reminder/new_add_reminder.dart';

import '../../helpers/app_localizations.dart';

class ReminderNewPage extends StatefulWidget {
  @override
  State<ReminderNewPage> createState() => _ReminderNewPageState();
}

class _ReminderNewPageState extends State<ReminderNewPage> {

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.reminder),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.reminderDelay,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              _buildReminderSection(localizations.breakfastpic, Colors.orange),
              _buildDivider(),
              _buildReminderSection(localizations.lunchpic, Colors.green),
              _buildDivider(),
              _buildReminderSection(localizations.dinnerpic, Colors.blue),
              _buildDivider(),
              _buildReminderSection(localizations.snackspic, Colors.deepOrange),
              _buildDivider(),
              _buildReminderSection(localizations.drinkpic, Colors.pink),
              _buildDivider(),
              _buildReminderSection(localizations.physicalActivitypic, Colors.red),
              _buildDivider(),
              _buildReminderSection(localizations.takeMedicinepic, Colors.purple),
              _buildDivider(),
              _buildReminderSection(localizations.readKnowledgepic, Colors.blue),
              _buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderSection(String title, Color color) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => AddReminderPage(
              type: title,
            )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  localizations!.addReminder,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }
}

