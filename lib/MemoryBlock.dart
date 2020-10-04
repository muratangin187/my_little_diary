import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_little_diary/Memory.dart';
import 'package:my_little_diary/MemoryScreen.dart';

class MemoryBlock extends StatelessWidget {
  Memory memory;
  Iterable<Memory> todays;
  final List<Memory> memories = [
    Memory(DateTime(2020, 6, 8, 13, 40),
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas id eros a neque luctus vehicula. Nullam blandit posuere lacus, sed tristique erat laoreet sed. Quisque ornare mauris justo, ut volutpat justo dapibus semper. Mauris ullamcorper massa vitae bibendum semper. Sed bibendum lectus efficitur sapien congue auctor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras eleifend at sem eu varius. Duis quis tincidunt augue. Curabitur vitae magna suscipit, fringilla libero id, porta felis. Vestibulum ipsum nisl, pellentesque sit amet dapibus sit amet, ullamcorper at augue. Nam ultricies purus et turpis sollicitudin sagittis. Integer quis justo est. Nam dapibus augue in euismod blandit. Praesent sit amet ligula nec dolor blandit condimentum vel in orci. Pellentesque mollis eleifend metus, ac scelerisque mauris vulputate quis. Aenean scelerisque aliquet turpis sed luctus."),
    Memory(DateTime(2020, 6, 8, 12, 40),
        "Pellentesque a ipsum id mi accumsan sagittis. Donec a justo ut purus ultrices porttitor at eget lorem. Cras ex felis, lacinia maximus scelerisque placerat, fermentum quis ipsum. Etiam vitae venenatis diam, vel tempor mauris. In nec lobortis felis, nec posuere quam. Morbi eget bibendum ligula, a rutrum ante. Quisque quis porta metus. Duis placerat risus augue, vel luctus ipsum pellentesque ac. Proin lacinia tellus a justo fermentum imperdiet. Cras malesuada tellus ac mi vehicula, faucibus gravida risus fermentum. Nam efficitur et turpis ac fermentum. Aenean vitae tellus auctor, blandit tortor non, imperdiet velit. Duis iaculis sem eget felis pellentesque, vitae luctus sem tincidunt. Aliquam nunc dui, tincidunt vel suscipit ac, mattis in leo. Nunc in purus dolor."),
    Memory(DateTime(2020, 6, 5, 13, 40),
        "Aliquam tempus laoreet cursus. Pellentesque dapibus tincidunt diam vitae volutpat. Praesent tempor mi enim, vel rhoncus nisi porta a. Morbi maximus sed velit vitae elementum. Maecenas quam massa, tempor eget ante vel, egestas cursus nibh. Donec in viverra tortor. Nullam facilisis ante at ipsum ullamcorper congue. Ut erat tortor, accumsan at metus eget, vulputate blandit tellus. Vestibulum suscipit lobortis lobortis. Curabitur eget massa pulvinar, congue erat ac, accumsan lorem. Vestibulum lobortis id lectus eu sodales. Aliquam in purus sed nisi tristique lacinia. Duis tempus elit eu suscipit fermentum. Mauris pellentesque tempor magna et venenatis. Cras tempus dui magna, sit amet ullamcorper ante pulvinar nec."),
    Memory(DateTime(2020, 6, 5, 12, 40),
        "Curabitur mattis metus id dolor venenatis, a volutpat ipsum placerat. Integer arcu nunc, luctus nec orci vel, ultrices malesuada purus. Mauris laoreet massa quis convallis elementum. Sed facilisis venenatis metus a posuere. Duis a velit orci. Fusce eu eleifend diam. Etiam sed ante odio. Curabitur mauris dui, posuere eget interdum at, porttitor in lectus. Nullam id molestie dolor. Aliquam tempus leo eu pellentesque gravida. Nam aliquet neque sit amet mauris finibus mollis. Pellentesque pulvinar tellus orci, faucibus malesuada nisi pharetra finibus. Integer tempor aliquam pellentesque. Suspendisse libero dolor, molestie in mauris et, viverra dignissim nibh."),
    Memory(DateTime(2020, 6, 5, 11, 40),
        "Curabitur mattis metus id dolor venenatis, a volutpat ipsum placerat. Integer arcu nunc, luctus nec orci vel, ultrices malesuada purus. Mauris laoreet massa quis convallis elementum. Sed facilisis venenatis metus a posuere. Duis a velit orci. Fusce eu eleifend diam. Etiam sed ante odio. Curabitur mauris dui, posuere eget interdum at, porttitor in lectus. Nullam id molestie dolor. Aliquam tempus leo eu pellentesque gravida. Nam aliquet neque sit amet mauris finibus mollis. Pellentesque pulvinar tellus orci, faucibus malesuada nisi pharetra finibus. Integer tempor aliquam pellentesque. Suspendisse libero dolor, molestie in mauris et, viverra dignissim nibh."),
    Memory(DateTime(2020, 6, 5, 10, 40),
        "Curabitur mattis metus id dolor venenatis, a volutpat ipsum placerat. Integer arcu nunc, luctus nec orci vel, ultrices malesuada purus. Mauris laoreet massa quis convallis elementum. Sed facilisis venenatis metus a posuere. Duis a velit orci. Fusce eu eleifend diam. Etiam sed ante odio. Curabitur mauris dui, posuere eget interdum at, porttitor in lectus. Nullam id molestie dolor. Aliquam tempus leo eu pellentesque gravida. Nam aliquet neque sit amet mauris finibus mollis. Pellentesque pulvinar tellus orci, faucibus malesuada nisi pharetra finibus. Integer tempor aliquam pellentesque. Suspendisse libero dolor, molestie in mauris et, viverra dignissim nibh."),
    Memory(DateTime(2020, 5, 8, 13, 40),
        "Pellentesque commodo, sapien id fermentum fermentum, nulla arcu semper lectus, fringilla ultrices mi nunc at diam. Maecenas auctor semper rhoncus. Phasellus maximus, risus eget sagittis rhoncus, magna leo aliquam odio, ut tristique orci nisi vel justo. Cras aliquet sollicitudin tellus, vitae rutrum nibh aliquam quis. Nam elementum augue elit, eu convallis magna bibendum vitae. Maecenas ultrices orci id nunc bibendum posuere. Morbi nec neque in enim fringilla posuere. Donec dignissim ornare ligula sit amet cursus. Donec convallis metus ac odio iaculis, ac condimentum lorem sodales."),
  ];

  MemoryBlock(memory) {
    this.memory = memory;
    this.todays = memories.where((item){
      return ((item.date.difference(memory.date) - Duration(hours: item.date.hour) + Duration(hours: item.date.hour)).inHours / 24).round() == 0;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MemoryScreen(memory, todays)))
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
                Image(
                  image: AssetImage("assets/images/placeholder.jpg"),
                  height: 50,
                )
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
}
