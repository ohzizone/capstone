import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRecord {
  final DateTime date;
  final String distance;
  final String startTime;
  final String endTime;
  final String pace;

  MyRecord({
    required this.date,
    required this.distance,
    required this.startTime,
    required this.endTime,
    required this.pace,
  });

  factory MyRecord.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MyRecord(
      date: (data['date'] as Timestamp).toDate(),
      distance: data['distance'] as String,
      startTime: data['start_time'] as String,
      endTime: data['end_time'] as String,
      pace: data['pace'] as String,
    );
  }
}
