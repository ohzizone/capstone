import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String message;

    if (user != null) {
      message = "${user.email ?? '사용자'}님, 로그인이 되었습니다.";
    } else {
      message = "로그인이 안돼 있습니다.";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
