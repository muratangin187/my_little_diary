import 'package:flutter/material.dart';
import 'package:my_little_diary/Memory.dart';

class MemoryBlock extends StatelessWidget {
  Memory memory;

  MemoryBlock(memory) {
    this.memory = memory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Color(0xFF9A9A9A),
              ))),
      child: Column(
        children: [
          DateText(memory.date),
          SummaryText(memory.content)
        ],
      ),
    );
  }

  Widget DateText(DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                    color: Color(0xFFFF492B),
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                getMonthName(date.month),
                style: TextStyle(
                    color: Color(0xFF696969),
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 6),
              child: Text(
                date.year.toString() + ",",
                style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                getDayName(date.weekday),
                style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          date.hour.toString() + ":" + date.minute.toString(),
          style: TextStyle(
              color: Color(0xFFFF492B),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget SummaryText(String s) {
    if(s.length > 150){
      s = s.substring(0,150);
      s += "...";
    }
    return Text(
      s,
      style: TextStyle(
        color: Color(0xFF696969),
        fontSize: 18,
      ),
    );
  }

  String getDayName(int day) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[day - 1];
  }

  String getMonthName(int month) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'September',
      'Octomber',
      'November',
      'Decenmebr'
    ];
    return months[month - 1];
  }
}
