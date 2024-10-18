import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kesehatan_mobile/helpers/providers/reminder.dart';
import 'package:kesehatan_mobile/pages/reminder/add_reminder.dart';
import 'package:provider/provider.dart';

DateTime scheduleTime = DateTime.now();

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  ReminderPageState createState() => ReminderPageState();
}

class ReminderPageState extends State<ReminderPage> {
  bool value = false;
  @override
  void initState() {
    context.read<alarmprovider>().Inituilize(context);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
    context.read<alarmprovider>().GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reminder'),
          backgroundColor: Colors.blueAccent,
        ),
        body: ListView(
          children: [
            Consumer<alarmprovider>(builder: (context, alarm, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: alarm.modelist.length,
                  itemBuilder: (contex, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddReminder(
                                isEditMode: true,
                                reminderText: alarm.modelist[index].label,
                                dateTime: alarm.modelist[index].dateTime,
                                repeat: alarm.modelist[index].check,
                                milliseconds:
                                    alarm.modelist[index].milliseconds,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            alarm.modelist[index].dateTime!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                                "| ${alarm.modelist[index].label}"),
                                          ),
                                        ],
                                      ),
                                      CupertinoSwitch(
                                          value: (alarm.modelist[index]
                                                      .milliseconds! <
                                                  DateTime.now()
                                                      .microsecondsSinceEpoch)
                                              ? false
                                              : alarm.modelist[index].check,
                                          onChanged: (v) {
                                            alarm.EditSwitch(index, v);

                                            alarm.CancelNotification(
                                                alarm.modelist[index].id!);
                                          }),
                                    ],
                                  ),
                                  Text(alarm.modelist[index].when!)
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              // Navigate to the AddFoodPage
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddReminder();
              }));
            },
            child: const Icon(Icons.add, color: Colors.white, size: 25)));
  }
}
