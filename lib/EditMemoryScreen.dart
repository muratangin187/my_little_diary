import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryImage.dart';
import 'package:my_little_diary/MemoryScreen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class EditMemoryScreen extends StatefulWidget {
  final id;

  EditMemoryScreen({this.id});

  @override
  _EditMemoryScreenState createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  final textController = TextEditingController();
  Future<Database> database;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  List<Asset> images = List<Asset>();
  String _error;
  Memory current;
  bool check = false;
  List<String> newImagePaths = List<String>();

  @override
  void initState() {
    super.initState();
  }

  Future<Memory> getMemory() async{
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
          await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
        }, version: 1);
    final List<Map<String, dynamic>> res = await db.query("memories",
    where: "id = ?",
    whereArgs: [widget.id]);
    current = Memory(id: res[0]["id"], content: res[0]["content"], date: DateTime.fromMillisecondsSinceEpoch(res[0]["date"]));
    if(!check){
      selectedDate = current.date;
      selectedTime = TimeOfDay.fromDateTime(selectedDate);
      textController.text = current.content;
      check = true;
    }
    return current;
  }

  // Define a function that inserts dogs into the database
  Future<void> updateMemory() async {
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
        onCreate: (db, version) async{
          await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
          return db.execute(
              "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
        }, version: 1);
    selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    await db.update(
      'memories',
      {
        'id': current.id,
        'content': textController.text,
        'date': selectedDate.millisecondsSinceEpoch
      },
      where: "id = ?",
      whereArgs: [widget.id]
    );

    newImagePaths.forEach((element) {
      MemoryImageObject image = MemoryImageObject(id: null, memoryId: current.id, path: element);
      db.insert(
        'memoryImages',
        image.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Memory"),
      ),
      body: FutureBuilder<Memory>(
        future: getMemory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState != ConnectionState.done)
            return Container(
              child: Text("No Data"),
            );

          return Container(
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
                FutureBuilder<List<MemoryImageObject>>(
                  future: getImages(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData || snapshot.connectionState != ConnectionState.done)
                      return new CircularProgressIndicator(backgroundColor: Colors.black,);
                    return Container(height:40,child: buildGridView(context, snapshot.data), padding: EdgeInsets.only(bottom:8),);
                  }
                ),
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
                        id:current.id,
                        date: selectedDate,
                        content: textController.text);
                    print(newMemory.toMap());
                    await updateMemory();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MemoryScreen(newMemory)));
                  },
                  child: Text("Update the memory"),
                )
              ],
            ),
          );
        }
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

    var uuid = Uuid();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final String basepath = appDocDir.path;
    resultList.forEach((element) async{
      ByteData imageByte = await element.getByteData();
      final String path = join(basepath, uuid.v1());
      await writeToFile(imageByte, path);
      newImagePaths.add(path);
    });

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget buildGridView(context, List<MemoryImageObject> imagePaths) {
    if (images != null)
      return GridView.count(
        crossAxisCount: 1,
        scrollDirection: Axis.horizontal,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1),
        children: List.generate(images.length + imagePaths.length, (index) {
          if(index < images.length){
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
          }else{
            return Padding(
              padding: const EdgeInsets.only(right:16.0),
              child: InkWell(
                onTap: (){
                },
                child: Image(image: FileImage(File(imagePaths[index - images.length].path))),
              ),
            );
          }
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

  Future<List<MemoryImageObject>> getImages() async{
    // Query the table for all The Dogs.
    final db = await openDatabase(join(await getDatabasesPath(), 'memories.db'),
    onCreate: (db, version) async{
    await db.execute("CREATE TABLE memoryImages(id INTEGER PRIMARY KEY, memoryId INT, path TEXT)");
    return db.execute(
    "CREATE TABLE memories(id INTEGER PRIMARY KEY, date INT, time INT, content TEXT)");
    }, version: 1);
    final List<Map<String, dynamic>> maps = await db.query('memoryImages', where: "memoryId = ?" , whereArgs: [widget.id]);

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
