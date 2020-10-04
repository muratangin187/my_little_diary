import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryScreen.dart';

class MemoryBlock extends StatelessWidget {
  Memory memory;

  MemoryBlock(memory) {
    this.memory = memory;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>{
        Navigator.push(
        context,
      MaterialPageRoute(builder: (context) => MemoryScreen(memory)))
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Color(0xFF9A9A9A),
                ))),
        child: Column(
          children: [
            dateText(memory.date),
            Row(
              children: [
                Expanded(child: summaryText(memory.content)),
                Image(image: AssetImage("assets/images/placeholder.jpg"),height: 50,)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget dateText(DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                date.day.toString(),
                style: GoogleFonts.exo(textStyle:TextStyle(
                    color: Color(0xFF35B62D),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                getMonthName(date.month).toUpperCase(),
                style: GoogleFonts.exo(textStyle:TextStyle(
                    color: Color(0xF0696969),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),)
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 6),
              child: Text(
                date.year.toString() + ",",
                style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                getDayName(date.weekday),
                style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Text(
          date.hour.toString() + ":" + date.minute.toString(),
          style: TextStyle(
              color: Color(0xFF4AAE4E),
              fontSize: 12,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget summaryText(String s) {
    if(s.length > 150){
      s = s.substring(0,150);
      s += "...";
    }
    return Text(
      s,
      style: TextStyle(
        color: Color(0xFF696969),
        fontSize: 14,
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
