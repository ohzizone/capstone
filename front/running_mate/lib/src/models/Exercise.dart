import 'package:flutter/material.dart';

// Exercise 클래스: 운동 데이터 관리
class Exercise {
  final double distance; // 운동 거리 (단위: 킬로미터)
  final Duration duration; // 운동 기간
  final DateTime date; // 운동 날짜

  //생성자
  Exercise(
      {required this.distance, required this.duration, required this.date});

  // 평균 페이스 계산 메서드
  String calculateAveragePace() {
    // 거리를 분당 소요된 시간으로 나누어 평균 페이스를 계산
    double paceSecondsPerKm = duration.inSeconds / distance;
    int minutes = paceSecondsPerKm ~/ 60; // 분
    int seconds = (paceSecondsPerKm % 60).toInt(); // 초
    return '$minutes분 $seconds초'; // 예시로 반환 형식을 문자열로 표시
  }
}
