import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/Memory.dart';

class MemoryScreen extends StatefulWidget {
  Memory memory;
  List<Memory> todays;
  int currentIndex;
  List<GlobalKey> keys;

  MemoryScreen(memory, todays) {
    this.memory = memory;
    this.todays = todays;
    keys = [];
    this.todays.asMap().forEach((index, element) {
      keys.add(GlobalKey());
      if(element.content == memory.content && element.date == memory.date) {
        currentIndex = index;
      }
    });
  }

  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  ScrollController _controller;

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
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => {
              Scrollable.ensureVisible(widget.keys.last.currentContext),
            },
            child: Icon(
              Icons.edit,
              color: Color(0xFF35B62D),
              size: 32,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => {},
            child: Icon(
              Icons.delete,
              color: Color(0xFFD6554D),
              size: 32,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: getMemories(),
        ),
      ),
    );
  }

  List<Widget> getMemories(){
    List<Widget> result = [];
    widget.todays.asMap().forEach((index, element) {
      result.add(
          contentWidget(widget.keys[index], element.content, element.date)
      );
    });
    Future.delayed(Duration(milliseconds: 200),(){Scrollable.ensureVisible(widget.keys[widget.currentIndex].currentContext);});
    return result;
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

  Widget contentWidget(Key key, String content, DateTime date) {
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
          Container(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 8.0),
              children: [
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 100.00,
                    height: 100.00,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/images/placeholder.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    )),
              ],
            ),
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
}
