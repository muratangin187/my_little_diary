import 'package:flutter/material.dart';

class Memory{
  final int id;
  final DateTime date;
  final String content;

  Memory({this.id, this.date, this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'content': content,
    };
  }

  Map<String, dynamic> toMapDb() {
    if(id != null){
      return {
        'id': id,
        'date': date.millisecondsSinceEpoch,
        'content': content,
      };
    }else{
      return {
        'date': date.millisecondsSinceEpoch,
        'content': content,
      };
    }
  }
}