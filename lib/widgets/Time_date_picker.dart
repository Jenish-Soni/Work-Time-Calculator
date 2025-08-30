import 'package:flutter/material.dart';
import 'package:worktime_calculator/colors/colors_const.dart';

class TimeDatePicker extends StatefulWidget {
  final String text;

  const TimeDatePicker({super.key, required this.text});

  @override
  State<TimeDatePicker> createState() => _TimeDatePickerState();
}

class _TimeDatePickerState extends State<TimeDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConst.Cardbg,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Text(
              "09:00 PM",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.navigate_next_sharp,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
