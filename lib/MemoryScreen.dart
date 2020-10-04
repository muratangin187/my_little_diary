import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/Memory.dart';

class MemoryScreen extends StatefulWidget {
  Memory memory;
  MemoryScreen(memory){
    this.memory = memory;
  }
  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleDate(widget.memory.date),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0x00000000),
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFF9A9A9A),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: ()=>{},
            child: Icon(
              Icons.edit,
              color: Color(0xFF73FA6A),
              size: 32,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: ()=>{},
            child: Icon(
              Icons.delete,
              color: Color(0xFFFA6A71),
              size: 32,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.memory.content)
          ],
        ),
      ),
    );
  }

  Widget titleDate(DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
      ],
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
