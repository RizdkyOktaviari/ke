import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'login/login.dart';
import 'penyakit/detail.dart';
import 'penyakit/penyakit_list.dart';
import 'food_log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final Map<String, double> foodEntries = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Snacks': 0,
  };

  final GlobalKey<FoodLogPageState> _foodLogKey = GlobalKey<FoodLogPageState>(); // Create a GlobalKey to access FoodLogPage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            // make center title
            Center(
          child: Text(
            'Log',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                    child: Text(
                      'Menu Penyakit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.local_hospital),
                    title: Text('Penyakit'),
                    children: <Widget>[
                      ListTile(
                        title: Text('Informasi Penyakit'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenyakitListPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: Text('Exit'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Konfirmasi Keluar'),
                    content: Text(
                        'Apakah Anda yakin ingin keluar dan kembali ke halaman login?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Menutup dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (Route<dynamic> route) =>
                                false, // Menghapus semua rute sebelumnya
                          );
                        },
                        child: Text('Keluar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Calendar widget
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update focusedDay

                // Call reset method on FoodLogPage when the day changes
                _foodLogKey.currentState?.reset();
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: FoodLogPage(key: _foodLogKey, foodEntries: foodEntries), // Add key to access state
          ),
        ],
      ),
    );
  }
}
