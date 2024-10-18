import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kesehatan_mobile/helpers/providers/reminder.dart';
import 'package:provider/provider.dart';

class AddReminder extends StatefulWidget {
  final bool isEditMode;
  final String? reminderText;
  final String? dateTime;
  final bool? repeat;
  final int? milliseconds;

  const AddReminder({
    super.key,
    this.isEditMode = false,
    this.reminderText,
    this.dateTime,
    this.repeat,
    this.milliseconds,
  });

  @override
  AddReminderState createState() => AddReminderState();
}

class AddReminderState extends State<AddReminder> {
  late TextEditingController controller;
  String? dateTime;
  bool repeat = false;
  DateTime? notificationtime;
  String? name = "none";
  int? milliSeconds;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
        text: widget.isEditMode ? widget.reminderText : "");
    dateTime = widget.isEditMode ? widget.dateTime : null;
    milliSeconds = widget.isEditMode ? widget.milliseconds : null;
    repeat = widget.isEditMode ? widget.repeat ?? false : false;

    if (widget.isEditMode && repeat) {
      name = "Everyday";
    }

    context.read<alarmprovider>().GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                showDayOfWeek: true,
                minimumDate: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                use24hFormat: true,
                onDateTimeChanged: (va) {
                  dateTime = DateFormat().add_jms().format(va);
                  milliSeconds = va.microsecondsSinceEpoch;
                  notificationtime = va;
                },
                initialDateTime: widget.isEditMode
                    ? DateTime.fromMicrosecondsSinceEpoch(milliSeconds!)
                    : DateTime.now(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Enter your reminder",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                controller: controller,
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Repeat daily"),
              ),
              CupertinoSwitch(
                value: repeat,
                onChanged: (bool value) {
                  setState(() {
                    repeat = value;
                    name = repeat ? "Everyday" : "none";
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.isEditMode) {
                context.read<alarmprovider>().CancelNotification(milliSeconds!);
                context.read<alarmprovider>().modelist.removeWhere(
                    (element) => element.milliseconds == widget.milliseconds);
                context.read<alarmprovider>().SetData();
                context.read<alarmprovider>().SetAlaram(
                      controller.text,
                      dateTime!,
                      true,
                      name!,
                      Random().nextInt(100),
                      milliSeconds!,
                    );
                context.read<alarmprovider>().SetData();
                context
                    .read<alarmprovider>()
                    .SecduleNotification(notificationtime!, milliSeconds!);
                Navigator.pop(context);
              } else {
                Random random = Random();
                int randomNumber = random.nextInt(100);
                context.read<alarmprovider>().SetAlaram(
                      controller.text,
                      dateTime!,
                      true,
                      name!,
                      randomNumber,
                      milliSeconds!,
                    );
                context.read<alarmprovider>().SetData();
                context
                    .read<alarmprovider>()
                    .SecduleNotification(notificationtime!, randomNumber);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Set Alarm",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          // delete button if in edit mode
          if (widget.isEditMode)
            ElevatedButton(
              onPressed: () {
                context
                    .read<alarmprovider>()
                    .CancelNotification(widget.milliseconds!);
                context.read<alarmprovider>().modelist.removeWhere(
                    (element) => element.milliseconds == widget.milliseconds);
                context.read<alarmprovider>().SetData();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Delete Alarm",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
