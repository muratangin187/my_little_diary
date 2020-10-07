import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/EditMemoryScreen.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryImage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MemoryScreen extends StatefulWidget {
  Memory memory;
  int currentIndex;
  List<GlobalKey> keys;
  GlobalKey selectedKey;

  MemoryScreen(memory) {
    this.memory = memory;
  }

  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  ScrollController _controller;
  Future<Database> database;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

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
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: FutureBuilder<List<Memory>>(
          future: getMemories(),
          builder: (context, snapshot) {
            if(!snapshot.hasData || snapshot.connectionState != ConnectionState.done)
              return Container(child: Text("No Data"),);
            widget.keys = [];
            List<Widget> result = [];
            snapshot.data.forEach((element) {
              widget.keys.add(GlobalKey());
              if(element.content == widget.memory.content && element.date == widget.memory.date) {
                widget.selectedKey = widget.keys.last;
              }
              result.add(
                  contentWidget(widget.keys.last, element, context)
              );
            });

            Future.delayed(Duration(milliseconds: 100),(){Scrollable.ensureVisible(widget.selectedKey.currentContext);});
            return Column(
              children: result,
            );
          }
        ),
      ),
    );
  }

  Future<List<Memory>> getMemories() async{
    // Query the table for all The Dogs.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
          await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
        }, version: 1);
    final List<Map<String, dynamic>> maps = await db.query('memories');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Memory> allMemories = List.generate(maps.length, (i) {
      return Memory(
        id: maps[i]['id'],
        date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
        content: maps[i]['content'],
      );
    });

    List<Memory> todaysMemories = allMemories.where((item) {
      return ((item.date.difference(widget.memory.date) -
          Duration(hours: item.date.hour) +
          Duration(hours: item.date.hour))
          .inHours /
          24)
          .round() ==
          0;
    }).toList();

    return todaysMemories;

  }

  Future<void> deleteMemory(id) async {
    // Get a reference to the database.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
          await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
        }, version: 1);

    // Remove the Dog from the Database.
    await db.delete(
      'memories',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    await db.delete(
      'memoryImages',
      // Use a `where` clause to delete a specific dog.
      where: "memoryId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    setState(() {
      getMemories();
    });
  }

  Widget titleDate(DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  Widget contentWidget(Key key, Memory memory, BuildContext context) {
    String content = memory.content;
    DateTime date = memory.date;
    int id = memory.id;
    return Container(
      key: key,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF9A9A9A),
      ))),
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
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
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    date.hour.toString() + ":" + date.minute.toString(),
                    style: GoogleFonts.exo(
                      textStyle: TextStyle(
                          color: Color(0xF0696969),
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          FutureBuilder<List<MemoryImageObject>>(
            future: getImagesForMemory(memory.id),
            builder: (context, snapshot) {
              if(!snapshot.hasData || snapshot.connectionState != ConnectionState.done)
                return new CircularProgressIndicator(backgroundColor: Colors.black,);
              return Container(
                height: snapshot.data.length == 0 ? 0 : 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 8.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                          width: 100.00,
                          height: 100.00,
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: FileImage(File(snapshot.data[index].path)),
                              fit: BoxFit.fitHeight,
                            ),
                          ));
                  },
                ),
              );
            }
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(onPressed: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditMemoryScreen(id:id)));

              }, child: Text("Edit",)),
              OutlinedButton(onPressed: (){deleteMemory(id);}, child: Text("Delete", style: TextStyle(color: Color(0xAFFF0000)),))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              content,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
    );
  }

  Future<List<MemoryImageObject>> getImagesForMemory(int id) async{
      // Query the table for all The Dogs.
      final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
          onCreate: (db, version) async{
            await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
            return db.execute(
                "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
          }, version: 1);
      final List<Map<String, dynamic>> maps = await db.query('memoryImages', where: "memoryId = ?" , whereArgs: [id]);

      List<MemoryImageObject> allMemoryImages = List.generate(maps.length, (i) {
        return MemoryImageObject(
          id: maps[i]['id'],
          memoryId: maps[i]['memoryId'],
          path: maps[i]['path'],
        );
      });

      return allMemoryImages;
    }
  }
