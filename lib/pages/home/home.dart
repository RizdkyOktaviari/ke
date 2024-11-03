import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/constants/text_style.dart';
import 'package:kesehatan_mobile/helpers/providers/local_provider.dart';
import 'package:kesehatan_mobile/pages/auth/login.dart';
import 'package:kesehatan_mobile/pages/chat/chat.dart';
import 'package:kesehatan_mobile/pages/food_log.dart';
import 'package:kesehatan_mobile/pages/manage/manage.dart';
import 'package:kesehatan_mobile/pages/obat/obat.dart';
import 'package:kesehatan_mobile/pages/penyakit/penyakit_list.dart';
import 'package:kesehatan_mobile/pages/recap/recap.dart';
import 'package:kesehatan_mobile/pages/recipe/recipe.dart';
import 'package:kesehatan_mobile/pages/reminder/new_reminder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_localizations.dart';
import '../../helpers/providers/food_log_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final Map<String, double> foodEntries = {
    'Breakfast': 0,
    'Lunch': 0,
    'Dinner': 0,
    'Snacks': 0,
  };

  final GlobalKey<FoodLogPageState> _foodLogKey =
      GlobalKey<FoodLogPageState>(); // Create a GlobalKey to access FoodLogPage

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            // make center title
            Text(
              localizations.log,
          style: AppTextStyles.headline6,
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<LocaleProvider>(
              builder: (context, provider, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      provider.setLocaleByCode('id');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: provider.locale.languageCode == 'id'
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: const Text('ID'),
                  ),
                  Text('|', style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () {
                      provider.setLocaleByCode('en');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: provider.locale.languageCode == 'en'
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: const Text('EN'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: Text(
                      localizations.menu,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  // ExpansionTile(
                  //   leading: Icon(Icons.local_hospital),
                  //   title: Text('Penyakit'),
                  //   children: <Widget>[
                  //     ListTile(
                  //       title: Text('Informasi Penyakit'),
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => PenyakitListPage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //     ListTile(
                  //       title: Text('Manajemen Diri'),
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => PenyakitListPage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  ExpansionTile(
                    leading: Icon(Icons.book_online_sharp),
                    title: Text(localizations.knowledge),
                    children: <Widget>[
                      ListTile(
                        title: Text(localizations.knowledge),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenyakitListPage(),
                            ),
                          );
                        },
                      ),
                      // ListTile(
                      //   title: Text('Hipertensi'),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => PenyakitListPage(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      // ListTile(
                      //   title: Text('Manajemen Diri'),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => PenyakitListPage(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      // ListTile(
                      //   title: Text('Dash'),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => PenyakitListPage(),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),

                  ListTile(
                    leading: Icon(Icons.rice_bowl_sharp),
                    title: Text(localizations.recipe),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.restaurant_sharp),
                    title: Text(localizations.manage),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt_sharp),
                    title: Text(localizations.summary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecapListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.medication_liquid_sharp),
                    title: Text(localizations.medicine),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObatPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat_bubble_sharp),
                    title: Text(localizations.chat),
                    onTap: () {
                      // Navigasi ke ReminderPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatPage(),
                        ),
                      );
                    },
                  ),
                  //
                  // listtile to setting reminder
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(localizations.reminder),
                    onTap: () {
                      // Navigasi ke ReminderPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReminderNewPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.blueAccent),
              title: Text(localizations.exit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.exitConfirmTitle),
                    content: Text(
                        localizations.exitConfirmMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(localizations.cancel),
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
                        child: Text(localizations.exit),
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
              Provider.of<FoodLogProvider>(context, listen: false)
                  .setSelectedDate(selectedDay);
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
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: FoodLogPage(
                key: _foodLogKey,
                foodEntries: foodEntries), // Add key to access state
          ),
        ],
      ),
    );
  }
}
