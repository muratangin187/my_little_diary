import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryScreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class NewMemoryScreen extends StatefulWidget {

  @override
  _NewMemoryScreenState createState() => _NewMemoryScreenState();
}

class _NewMemoryScreenState extends State<NewMemoryScreen> {
  final textController = TextEditingController();
  Future<Database> database;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  // Define a function that inserts dogs into the database
  Future<void> insertMemory(Memory memory) async {
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) {
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, content TEXT)");
        }, version: 1);

    db.insert(
      'memories',
      memory.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Memory"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16, bottom: 16),
                        child: Text(
                          "Date: ",
                          style: GoogleFonts.exo(
                              textStyle: TextStyle(
                                  fontSize: 18, color: Color(0xF0696969))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 8, bottom: 16),
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0] +
                              "\n" +
                              selectedTime.format(context),
                          style: GoogleFonts.exo(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF35B62D))),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      OutlineButton(
                        onPressed: () => _selectDate(context), // Refer step 3
                        child: Text('Select date',
                            style: GoogleFonts.exo(
                                textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xF0696969),
                            ))),
                      ),
                      OutlineButton(
                        onPressed: loadAssets, // Refer step 3
                        child: Text('Pick Photos',
                            style: GoogleFonts.exo(
                                textStyle: TextStyle(
                              fontSize: 18,
                              color: Color(0xF0696969),
                            ))),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(height:40,child: buildGridView(context), padding: EdgeInsets.only(bottom:8),),
            Expanded(
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  controller: textController,
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Tell us about today',
                    helperText: 'Keep it with yourself forever',
                    labelText: 'Today\'s Story',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(
                      Icons.book,
                      color: Colors.green,
                    ),
                  )),
            ),
            OutlinedButton(
              onPressed: () async{
                selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                Memory newMemory = Memory(
                  id:null,
                  date: selectedDate,
                  content: textController.text);
                print(newMemory.toMap());
                await insertMemory(newMemory);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MemoryScreen(newMemory)))
                    .then((value) {
                      Navigator.pop(context);
                });
              },
              child: Text("Add new memory to diary"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print(resultList[0].identifier);

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Widget buildGridView(context) {
    if (images != null)
      return GridView.count(
        crossAxisCount: 1,
        scrollDirection: Axis.horizontal,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1),
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: InkWell(
              onTap: (){
                setState(()=>{
                  images.remove(images.firstWhere((element) => element.name == asset.name))
                });
                Fluttertoast.showToast(
                    msg: "Removed an image from memory",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
            },
              child: AssetThumb(
                asset: asset,
                width: 200,
                height: 200,
              ),
            ),
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    final TimeOfDay t =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null)
      setState(() {
        selectedTime = t;
      });
  }
}
