import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatMapWidget extends StatelessWidget {
  final DateTime startDate;

  const HeatMapWidget({super.key, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMonthLabels(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildHeatmap(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMonthLabels() {
    List<Widget> labels = [];
    DateTime today = DateTime.now();
    int totalWeeks = ((today.difference(startDate).inDays + startDate.weekday) / 7).ceil();

    for (int week = 0; week < totalWeeks; week++) {
      DateTime firstDayOfWeek = startDate.add(Duration(days: week * 7));
      if (firstDayOfWeek.day <= 7) {
        labels.add(
          Container(
            width: 16.0 * 4, // Width of 7 days
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(right: 20),
            child: Text(
              DateFormat("MMM").format(firstDayOfWeek),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels,
    );
  }

  List<Widget> buildHeatmap() {
    List<Widget> columns = [];
    DateTime today = DateTime.now();
    int todayIndex = today.weekday % 7;

    int totalWeeks = ((today.difference(startDate).inDays + startDate.weekday) / 7).ceil();
    for (int week = 0; week < totalWeeks; week++) {
      columns.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildWeek(week, todayIndex, startDate, today),
        ),
      );
    }
    return columns;
  }

  List<Widget> buildWeek(int weekIndex, int todayIndex, DateTime startDate, DateTime today) {
    List<Widget> week = [];
    DateTime weekStartDate = startDate.add(Duration(days: weekIndex * 7));
    for (int day = 0; day < 7; day++) {
      DateTime currentDate =
          weekStartDate.add(Duration(days: max(0, day - weekStartDate.weekday % 7)));

      if (weekIndex == 0 && day < startDate.weekday % 7) {
        week.add(_createTile(0));
        print(startDate);
        print(startDate.weekday % 7);
        print("creating 0 tile for currentDate: ${currentDate}");
      } else if (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
        print(currentDate);
        week.add(_createTile(7));
      } else {
        week.add(_createTile(0));
      }
    }
    return week;
  }

  Color getColor(int count) {
    if (count == 0) return Colors.black.withOpacity(0.1);
    if (count < 3) return Colors.green[200]!;
    if (count < 6) return Colors.green[400]!;
    if (count < 9) return Colors.green[600]!;
    return Colors.green[800]!;
  }

  Widget _createTile(int data) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      width: 16.0,
      height: 16.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: getColor(data),
      ),
    );
  }
}
