import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime initialTime;
  final ValueChanged<DateTime> onTimeChanged;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _meridiemController;
  late DateTime _selectedTime;

  final double _itemExtent = 50.0;
  final double _pickerHeight = 200.0; // Restored and checked height
  final List<String> _meridiems = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;

    final initialHour = _selectedTime.hour > 12
        ? _selectedTime.hour - 12
        : _selectedTime.hour == 0
        ? 12
        : _selectedTime.hour;
    final initialMeridiem = _selectedTime.hour >= 12 ? 1 : 0;

    _hourController = FixedExtentScrollController(initialItem: initialHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedTime.minute,
    );
    _meridiemController = FixedExtentScrollController(
      initialItem: initialMeridiem,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _meridiemController.dispose();
    super.dispose();
  }

  // A helper widget for the scrollable list of numbers (hours or minutes)
  Widget _buildTimeWheel({
    required FixedExtentScrollController controller,
    required int maxCount,
    required ValueChanged<int> onSelectedItemChanged,
    List<String>? labels,
    String? header,
  }) {
    return Column(
      children: [
        if (header != null)
          Text(
            header,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        SizedBox(
          width: 80.0,
          height: _pickerHeight,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _itemExtent,
            perspective: 0.005,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final value = index % maxCount;
                final isSelected =
                    (controller.hasClients &&
                        controller.selectedItem == index) ||
                    (!controller.hasClients &&
                        (controller.initialItem == index ||
                            (controller.initialItem == null && index == 0)));

                return Center(
                  child: Text(
                    labels != null
                        ? labels[value]
                        : NumberFormat('00').format(value),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: isSelected
                          ? const Color(0xFF67C6E3) // Vibrant accent color
                          : Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              childCount: labels != null ? labels.length : maxCount * 2,
            ),
          ),
        ),
      ],
    );
  }

  // Update selected time and handle AM/PM logic
  void _updateSelectedTime() {
    final hour = (_hourController.selectedItem % 12);
    final minute = _minuteController.selectedItem % 60;
    final isPM = (_meridiemController.selectedItem % 2) == 1;

    int newHour = hour;
    if (isPM && hour != 12) {
      newHour = hour + 12;
    } else if (!isPM && hour == 12) {
      newHour = 0; // Midnight hour
    }

    _selectedTime = _selectedTime.copyWith(hour: newHour, minute: minute);
    widget.onTimeChanged(_selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F41), // Card background color
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeWheel(
                controller: _hourController,
                maxCount: 12,
                header: 'Hours',
                onSelectedItemChanged: (index) => setState(_updateSelectedTime),
              ),
              const SizedBox(width: 8.0),
              _buildTimeWheel(
                controller: _minuteController,
                maxCount: 60,
                header: 'Minutes',
                onSelectedItemChanged: (index) => setState(_updateSelectedTime),
              ),
              const SizedBox(width: 8.0),
              _buildTimeWheel(
                controller: _meridiemController,
                maxCount: _meridiems.length,
                labels: _meridiems,
                header: 'AM/PM',
                onSelectedItemChanged: (index) => setState(_updateSelectedTime),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedTime);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF67C6E3),
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
