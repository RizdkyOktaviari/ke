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
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/food_log_provider.dart';
import '../../services/fcm_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodLogProvider>(context, listen: false)
          .setSelectedDate(_selectedDay); // Gunakan setSelectedDate
    });
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.log,
          style: AppTextStyles.headline6,
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Language selector remains the same
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<LocaleProvider>(
              builder: (context, provider, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => provider.setLocaleByCode('id'),
                    style: TextButton.styleFrom(
                      foregroundColor: provider.locale.languageCode == 'id'
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: const Text('ID'),
                  ),
                  const Text('|', style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () => provider.setLocaleByCode('en'),
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
      drawer: _buildDrawer(localizations),
      body: Column(
        children: [
          // Calendar section
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // Fetch data for selected date
                Provider.of<FoodLogProvider>(context, listen: false)
                    .setSelectedDate(selectedDay);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                decoration: BoxDecoration(color: Colors.transparent),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.blueAccent),
                todayTextStyle: const TextStyle(color: Colors.white),
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          // FoodLogPage
          Expanded(
            child: Consumer<FoodLogProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const FoodLogPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations l10n) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Center(
              child: Column(
                children: [
                  // Text(
                  //   "Ht.Co",
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Text(
                  //   "(Hypertension Control)",
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //     fontStyle: FontStyle.italic,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Text(
                    "Joki Lebah",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.book_online_sharp,
                  title: l10n.knowledge,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PenyakitListPage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.rice_bowl_sharp,
                  title: l10n.recipe,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecipePage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.restaurant_sharp,
                  title: l10n.manage,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManagePage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.list_alt_sharp,
                  title: l10n.summary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  RecapListPage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.medication_liquid_sharp,
                  title: l10n.medicine,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ObatPage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.chat_bubble_sharp,
                  title: l10n.chat,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatPage()),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.notifications,
                  title: l10n.reminder,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  ReminderNewPage()),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: l10n.exit,
            textColor: Colors.blueAccent,
            iconColor: Colors.blueAccent,
            onTap: () => _showExitDialog(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }

  Future<void> _showExitDialog(AppLocalizations l10n) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitConfirmTitle),
        content: Text(l10n.exitConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.exit),
          ),
        ],
      ),
    );

    if (result == true) {
      // ignore: use_build_context_synchronously
      final notificationService = NotificationService();
      await notificationService.clearFCMToken();

      // Clear auth token and user data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) =>  LoginPage()),
            (route) => false,
      );
    }
  }
}