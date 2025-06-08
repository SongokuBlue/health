import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_data.dart'; // Để dùng HealthLog

typedef OnCustomRangeApplied = void Function(List<FlSpot>, List<DateTime>);

class CustomRangeButton extends StatelessWidget {
  final String selectedFilter;
  final List<HealthLog> logs;
  final void Function(String) onFilterChanged;
  final OnCustomRangeApplied onCustomRangeApplied;

  const CustomRangeButton({
    super.key,
    required this.selectedFilter,
    required this.logs,
    required this.onFilterChanged,
    required this.onCustomRangeApplied,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        child: const Text("Custom Range"),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedFilter == "Custom" ? Colors.purple : Colors.white,
          foregroundColor: selectedFilter == "Custom" ? Colors.white : Colors.purple,
          shape: const StadiumBorder(),
          elevation: 2,
        ),
        onPressed: () async {
          final dateTimeList = await showOmniDateTimeRangePicker(
            context: context,
            startInitialDate: DateTime.now().subtract(const Duration(hours: 1)),
            startFirstDate: DateTime(2000),
            startLastDate: DateTime.now(),
            endInitialDate: DateTime.now(),
            endFirstDate: DateTime(2000),
            endLastDate: DateTime.now(),
            is24HourMode: true,
            isShowSeconds: false,
            minutesInterval: 1,
            secondsInterval: 1,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
            transitionBuilder: (context, anim1, anim2, child) {
              return FadeTransition(
                opacity: anim1.drive(Tween(begin: 0, end: 1)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            barrierDismissible: true,
          );
          //sau khi chọn xong sẽ có 2 ngày . tái thiết lập lại biểu đồ
          if (dateTimeList != null && dateTimeList.length == 2) {
            final start = dateTimeList[0];
            final end = dateTimeList[1];
            List<FlSpot> newSpots = [];
            List<DateTime> newDates = [];

            for (int i = 0; i < logs.length; i++) {
              final log = logs[i];
              if (log.timestamp.isAfter(start) && log.timestamp.isBefore(end)) {
                newSpots.add(FlSpot(newDates.length.toDouble(), log.heartRate));
                newDates.add(log.timestamp);
              }
            }

            onFilterChanged("Custom");
            onCustomRangeApplied(newSpots, newDates);
          }
        },
      ),
    );
  }
}
