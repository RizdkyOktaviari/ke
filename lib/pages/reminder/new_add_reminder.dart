
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/reminder_provider.dart';
import '../../models/reminder_model.dart';

class AddReminderPage extends StatefulWidget {
  final String type;

  const AddReminderPage({Key? key, required this.type}) : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now(); // Ganti selectedDays dengan selectedDate
  final TextEditingController _messageController = TextEditingController();

  Future<void> _saveReminder() async {
    try {
      if (_messageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Masukkan pesan reminder')),
        );
        return;
      }

      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not authenticated')),
        );
        return;
      }

      // Format time HH:mm
      final hour = _selectedTime.hour.toString().padLeft(2, '0');
      final minute = _selectedTime.minute.toString().padLeft(2, '0');
      final timeString = '$hour:$minute';

      // Format date yyyy-MM-dd
      final dateString = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

      final reminder = Reminder(
        title: widget.type,
        message: _messageController.text.trim(),
        reminderDate: dateString,
        reminderTime: timeString,
        type: widget.type,
      );

      final success = await Provider.of<ReminderProvider>(context, listen: false)
          .addReminder(token, reminder);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reminder berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } else {
        final error = Provider.of<ReminderProvider>(context, listen: false).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Gagal menambahkan reminder')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengingat ${widget.type}'),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Waktu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text('Waktu: ${_selectedTime.format(context)}'),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (timeOfDay != null) {
                      setState(() {
                        _selectedTime = timeOfDay;
                      });
                    }
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text(
                      'Tanggal: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025, 12, 31),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Pesan Pengingat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height:40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Simpan Pengingat'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}