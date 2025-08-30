import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worktime_calculator/widgets/Time_date_picker.dart';
import 'package:worktime_calculator/widgets/custom_time_picker.dart';

import 'colors/colors_const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _loginTime = DateTime.now();
  DateTime _breakFrom = DateTime.now();
  DateTime _breakTo = DateTime.now();
  DateTime? finalTime;

  Future<void> _showTimePicker(DateTime time, String type) async {
    final selectedTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CustomTimePicker(
            initialTime: time,
            onTimeChanged: (newTime) {},
          ),
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        if (type == "login") {
          _loginTime = selectedTime;
        } else if (type == "breakFrom") {
          _breakFrom = selectedTime;
        } else if (type == "breakTo") {
          _breakTo = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/bg.jpeg',
              height: MediaQuery.sizeOf(context).height,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Text(
                    "40",
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Total hours worked this week",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTimePicker(_loginTime, "login");
                    },
                    child: TimeDatePicker(
                      text: "Login Time",
                      dateTime: _loginTime,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTimePicker(_breakFrom, "breakFrom");
                    },
                    child: TimeDatePicker(
                      text: "Break From",
                      dateTime: _breakFrom,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTimePicker(_breakTo, "breakTo");
                    },
                    child: TimeDatePicker(
                      text: "Break To",
                      dateTime: _breakTo,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorsConst.Cardbg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: const SizedBox(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Logout Time",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              finalTime == null
                                  ? '00:00'
                                  : DateFormat('hh:mm a').format(finalTime!),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Duration actualTime = const Duration(
                        hours: 8,
                        minutes: 30,
                      );
                      if (_loginTime.hour == DateTime.now().hour &&
                          _loginTime.minute == DateTime.now().minute &&
                          _breakFrom.hour == DateTime.now().hour &&
                          _breakFrom.minute == DateTime.now().minute &&
                          _breakTo.hour == DateTime.now().hour &&
                          _breakTo.minute == DateTime.now().minute) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Select Time")),
                        );
                        return;
                      } else if (_breakFrom.isAfter(_breakTo)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "From Time cannot be after To Time",
                            ),
                          ),
                        );
                        return;
                      }

                      Duration breakDuration = _breakTo.difference(_breakFrom);
                      DateTime logoutTime = _loginTime
                          .add(actualTime)
                          .add(breakDuration);
                      setState(() {
                        finalTime = logoutTime;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsConst.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
