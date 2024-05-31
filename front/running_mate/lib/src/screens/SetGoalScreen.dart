import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:running_mate/src/screens/PracticeScreen.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:intl/intl.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  void _loadGoal() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference goalRef = _firestore
          .collection('goals')
          .doc(user.uid)
          .collection('goal')
          .doc('rVyj0NS9aGSYscPMxVjC');
      DocumentSnapshot goalSnapshot = await goalRef.get();
      if (goalSnapshot.exists) {
        setState(() {
          _goalController.text = goalSnapshot['goal'];
          //_selectedDate = (goalSnapshot['date'] as Timestamp).toDate();
          String dateString = goalSnapshot['date'];
          _selectedDate = _dateFormat.parse(dateString);
          _dateController.text = dateString;
        });
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormat.format(_selectedDate!);
      });
    }
  }

  void _saveGoal() async {
    if (_selectedDate == null || _selectedDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a valid future date')),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference goalRef = _firestore
          .collection('goals')
          .doc(user.uid)
          .collection('goal')
          .doc('rVyj0NS9aGSYscPMxVjC');
      await goalRef.set({
        'goal': _goalController.text,
        'date': _dateFormat.format(_selectedDate!), // 날짜를 문자열 형식으로 저장
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '목표 설정하기',
          style: TextStyle(
            color: gray4,
            fontFamily: 'PretandardMedium',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: '목표 설정하기',
                labelStyle: TextStyle(
                  fontFamily: 'PretandardMedium',
                  color: gray4, // 레이블 텍스트 색상
                  fontSize: 20, // 레이블 텍스트 크기
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: iris_100, // 기본 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: iris_80,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              //readOnly: true,
              decoration: InputDecoration(
                labelText: '날짜 설정하기',
                labelStyle: TextStyle(
                  fontFamily: 'PretandardMedium',
                  color: gray4, // 레이블 텍스트 색상
                  fontSize: 20, // 레이블 텍스ㄴ트 크기
                ),
                hintText: '날짜를 선택해주세요',
                hintStyle: TextStyle(
                  fontFamily: 'PretandardMedium',
                  color: gray4, // 레이블 텍스트 색상
                  fontSize: 14, // 레이블 텍스ㄴ트 크기
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: iris_100,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: iris_80,
                  ),
                ),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            Container(
              height: 65.0,
              width: 100.0,
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 2.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: iris_100,
              ),
              child: TextButton(
                onPressed: () {
                  _saveGoal();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PracticeScreen(),
                    ),
                  );
                },
                child: Text(
                  '확인', // 버튼에 표시될 텍스트입니다.
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
