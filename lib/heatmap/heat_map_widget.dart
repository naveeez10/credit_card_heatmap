import 'dart:math';

import 'package:credit_card_heatmap/transactions/mock_transaction_generator.dart';
import 'package:credit_card_heatmap/transactions/transactions.dart';
import 'package:credit_card_heatmap/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HeatMapWidget extends StatefulWidget {
  const HeatMapWidget({
    super.key,
  });

  @override
  State<HeatMapWidget> createState() => _HeatMapWidgetState();
}

class _HeatMapWidgetState extends State<HeatMapWidget> {
  final DateTime _selectedYear = DateTime.now();
  final List<Transaction> _transactions = generateMockTransactions();

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
              _buildMonthLabels(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildHeatmap(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthLabels() {
    List<Widget> labels = [];
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(_selectedYear.year, 1, 1);
    int totalWeeks = ((today.difference(startDate).inDays + startDate.weekday) / 7).ceil();

    for (int week = 0; week < totalWeeks; week++) {
      DateTime firstDayOfWeek = startDate.add(Duration(days: week * 7));
      if (firstDayOfWeek.day <= 7) {
        labels.add(
          Container(
            width: 16.w * 4.2,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
            ),
            margin: EdgeInsets.only(right: 20.w),
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

  List<Widget> _buildHeatmap() {
    List<Widget> columns = [];
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(_selectedYear.year, 1, 1);
    int todayIndex = today.weekday % 7;

    int totalWeeks = ((today.difference(startDate).inDays + startDate.weekday) / 7).ceil();
    for (int week = 0; week < totalWeeks; week++) {
      columns.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildWeek(week, todayIndex, startDate, today),
        ),
      );
    }
    return columns;
  }

  List<Widget> _buildWeek(int weekIndex, int todayIndex, DateTime startDate, DateTime today) {
    List<Widget> week = [];
    DateTime weekStartDate = startDate.add(Duration(days: weekIndex * 7));
    for (int day = 0; day < 7; day++) {
      DateTime currentDate =
          weekStartDate.add(Duration(days: max(0, day - weekStartDate.weekday % 7)));

      final List<Transaction> transactions = _transactions
          .where((transaction) =>
              transaction.dateTime.year == currentDate.year &&
              transaction.dateTime.month == currentDate.month &&
              transaction.dateTime.day == currentDate.day)
          .toList();

      if (weekIndex == 0 && day < startDate.weekday % 7) {
        week.add(_createTile([]));
      } else if (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
        week.add(_createTile(transactions));
      } else {
        week.add(_createTile([]));
      }
    }
    return week;
  }

  Color _getColor(int count) {
    if (count == 0) return Colors.black.withOpacity(0.1);
    if (count < 3) return Colors.orange[200]!;
    if (count < 6) return Colors.orange[400]!;
    if (count < 9) return Colors.orange[600]!;
    return Colors.orange[800]!;
  }

  Widget _createTile(List<Transaction> transactions) {
    final String totalAmountSpent =
        transactions.fold(0, (previousValue, element) => previousValue + element.amount).toString();
    return GestureDetector(
      onTap: () {
        if (transactions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No transactions on this day"),
            ),
          );
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionPage(transactions: transactions),
          ),
        );
      },
      child: Tooltip(
        message: "Total amount spent on ${transactions.length} transactions: ₹$totalAmountSpent",
        child: Container(
          margin: const EdgeInsets.all(2.0),
          width: 16.0.w,
          height: 16.0.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _getColor(transactions.length),
          ),
        ),
      ),
    );
  }
}
