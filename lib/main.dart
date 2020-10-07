import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryBlock.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/MemoryScreen.dart';
import 'package:my_little_diary/NewMemoryScreen.dart';
import 'package:my_little_diary/test.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Little Diary',
      theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
      home: MyHomePage(title: 'My Little Diary'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Database> database;
  bool search = false;
  DateTime firstDate = DateTime.now().subtract(Duration(days: 1));
  DateTime lastDate = DateTime.now();

  @override
  void initState() {
    permissionInit();
    super.initState();
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Memory>> getMemories() async {
    // Query the table for all The Dogs.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
      await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
      return db.execute(
          "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
    }, version: 1);

    List<Map<String, dynamic>> maps = await db.query('memories');

    if(search){
      List<Memory> allMemories = List.generate(maps.length, (i) {
        return Memory(
          id: maps[i]['id'],
          date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
          content: maps[i]['content'],
        );
      });

      return allMemories.where((item) {
        firstDate = DateTime(firstDate.year, firstDate.month, firstDate.day, 0, 1);
        lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day, 23, 59);
        return item.date.isAfter(firstDate) && item.date.isBefore(lastDate);
      }).toList();
    }else{
      return List.generate(maps.length, (i) {
        return Memory(
          id: maps[i]['id'],
          date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
          content: maps[i]['content'],
        );
      });
    }
  }

  Future<void> permissionInit() async {
    // You can can also directly ask the permission about its status.
    if (await Permission.accessMediaLocation.request().isGranted) {
      // The OS restricts access, for example because of parental controls.
    }

    if (await Permission.camera.request().isGranted) {
      // The OS restricts access, for example because of parental controls.
    }

    if (await Permission.storage.request().isGranted) {
      // The OS restricts access, for example because of parental controls.
    }
  }

  _selectDate(BuildContext context, bool first) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: first ? firstDate : lastDate, // Refer step 1
      firstDate: first ? DateTime(2000) : firstDate,
      lastDate: first ? lastDate : DateTime.now(),
    );
    if (picked != null)
      setState(() {
        if(first)
          firstDate = picked;
        else
          lastDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: search ?
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              OutlinedButton(onPressed: (){_selectDate(context, true);}, child: Text("From " + firstDate.year.toString() + "-" + firstDate.month.toString() + "-" + firstDate.day.toString())),
              OutlinedButton(onPressed: (){_selectDate(context, false);}, child: Text("To " + lastDate.year.toString() + "-" + lastDate.month.toString() + "-" + lastDate.day.toString())),])
            : Text(
          widget.title,
          style: GoogleFonts.macondoSwashCaps(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ),
        elevation: 0,
        backgroundColor: Color(0x00000000),
        bottom: PreferredSize(
            child: Container(
              color: Color(0xFF9A9A9A),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: [
          InkWell(
            onTap: (){
              setState(() {
                search = !search;
              });
            },
            child: Icon(
              search ? Icons.cancel : Icons.search,
              color: Colors.black,
              size: 32,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: FutureBuilder<List<Memory>>(
          future: getMemories(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState != ConnectionState.done)
              return Container(
                child: Text("No Data"),
              );
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () => {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MemoryScreen(snapshot.data[index])))
                                .then((value) {
                              setState(() {
                                getMemories();
                              });
                            })
                          },
                      child: MemoryBlock(snapshot.data[index]));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewMemoryScreen()))
              .then((value) {
            setState(() {
              getMemories();
            });
          })
          //Navigator.push(context, MaterialPageRoute( builder: (context) => Test()))
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
