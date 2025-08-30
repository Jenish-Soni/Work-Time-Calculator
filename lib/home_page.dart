import 'package:flutter/material.dart';
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

  Future<void> _showTimePicker(DateTime time) async {
    final selectedTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Use the custom component inside the dialog
          child: CustomTimePicker(
            initialTime: time,
            onTimeChanged: (newTime) {
              time = newTime;
            },
          ),
        );
      },
    );

    // Update the state with the new time if the user selected one
    if (selectedTime != null) {
      setState(() {
        _loginTime = selectedTime;
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
                      _showTimePicker(_loginTime);
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
                      _showTimePicker(_breakFrom);
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
                      _showTimePicker(_breakTo);
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
                    height: 140,
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
                              "05:00 PM",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
