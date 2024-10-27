
import 'package:flutter/material.dart';

class AddReminderPage extends StatefulWidget {
  final String type;

  const AddReminderPage({Key? key, required this.type}) : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _selectedDays = List.generate(7, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengingat ${widget.type}'),
      ),
      body: Padding(
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
              'Pilih Hari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                'Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'
              ].asMap().entries.map((entry) {
                return FilterChip(
                  label: Text(entry.value),
                  selected: _selectedDays[entry.key],
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedDays[entry.key] = selected;
                    });
                  },
                );
              }).toList(),
            ),
           SizedBox(height:80),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi menyimpan pengingat
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Simpan Pengingat'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}