import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(String date, int distance, String end_time,
      String start_time, int time_taken, String user_id) async {
    await _firestore
        .collection('/running record/qLGojNsNczqZF0UI95Im/record')
        .add({
      'user_id': user_id,
      'date': date,
      'distance': distance,
      'end_time': end_time,
      'start_time': start_time,
      'time_taken': time_taken
    });
  }

  Future<List<Map<String, dynamic>>> getUserReviews(String user_id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('/running record/qLGojNsNczqZF0UI95Im/record')
        .where('user_id', isEqualTo: user_id)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
