import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iris_80,
      // appBar: AppBar(
      //   title: Text('BBANTO'),
      //   centerTitle: true,
      //   backgroundColor: Colors.redAccent,
      //   elevation: 0.0,
      // ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 222.0, 0.0, 0.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/splash_logo.png',
                height: 180.0,
                fit: BoxFit.fill,
              ),
              Text(
                '러닝 메이트',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardBold',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Pace maker',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
