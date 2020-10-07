import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryImage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MemoryBlock extends StatefulWidget {
  Memory memory;

  MemoryBlock(memory) {
    this.memory = memory;
  }
  @override
  _MemoryBlockState createState() => _MemoryBlockState();
}

class _MemoryBlockState extends State<MemoryBlock> {

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
          dateText(widget.memory.date),
          Row(
            children: [
              Expanded(child: summaryText(widget.memory.content)),
              FutureBuilder<MemoryImageObject>(
                future: getImage(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done)
                    return new CircularProgressIndicator(backgroundColor: Colors.black,);
                  if(snapshot.data != null ){
                    return Image(
                      image: FileImage(File(snapshot.data.path)),
                      height: 50,
                    );
                  }else{
                    return Container(height: 0,);
                  }
                }
              )
            ],
          )
        ],
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
                style: GoogleFonts.exo(
                  textStyle: TextStyle(
                      color: Color(0xFF35B62D),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  getMonthName(date.month).toUpperCase(),
                  style: GoogleFonts.exo(
                    textStyle: TextStyle(
                        color: Color(0xF0696969),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                )),
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
    if (s.length > 150) {
      s = s.substring(0, 150);
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

  Future<MemoryImageObject> getImage() async{
    // Query the table for all The Dogs.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
          await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
        }, version: 1);
    final List<Map<String, dynamic>> maps = await db.query('memoryImages', where: "memoryId = ?" , whereArgs: [widget.memory.id]);

    List<MemoryImageObject> allMemoryImages = List.generate(maps.length, (i) {
      return MemoryImageObject(
        id: maps[i]['id'],
        memoryId: maps[i]['memoryId'],
        path: maps[i]['path'],
      );
    });

    if(allMemoryImages.length != 0)
      return allMemoryImages[0];
    else
      return null;
  }
}
