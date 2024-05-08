import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUpScreen = true;

  void _toggleScreen() {
    setState(() {
      isSignUpScreen = !isSignUpScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray1,
      body: Stack(
        children: [
          // 배경
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/blue_40.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 20),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Welcome',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PretendardMedium',
                          color: iris_100,
                        ),
                        children: [
                          TextSpan(
                            text:
                                isSignUpScreen ? ' to Running Mate!' : ' back!',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'PretendardMedium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 텍스트 폼 필드
          Positioned(
            top: 220,
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: isSignUpScreen ? 280.0 : 250.0,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _toggleScreen();
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: !isSignUpScreen ? gray4 : gray2,
                                fontFamily: 'PretendardMedium',
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 55,
                            color: Colors.yellow,
                            margin: EdgeInsets.only(top: 3),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _toggleScreen();
                            },
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSignUpScreen ? gray4 : gray2,
                                fontFamily: 'PretendardMedium',
                              ),
                            ),
                          ),
                          if (isSignUpScreen)
                            Container(
                              height: 2,
                              width: 55,
                              color: Colors.yellow,
                              margin: EdgeInsets.only(top: 3),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (isSignUpScreen)
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: gray2,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  hintText: 'User name',
                                  hintStyle: TextStyle(
                                      fontFamily: 'PretendardMedium',
                                      fontSize: 14.0,
                                      color: gray2),
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: gray2,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  hintText: 'email',
                                  hintStyle: TextStyle(
                                      fontFamily: 'PretendardMedium',
                                      fontSize: 14.0,
                                      color: gray2),
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: gray2,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: gray2),
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  hintText: 'password',
                                  hintStyle: TextStyle(
                                      fontFamily: 'PretendardMedium',
                                      fontSize: 14.0,
                                      color: gray2),
                                  contentPadding: EdgeInsets.all(10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isSignUpScreen)
                    Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: gray2,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: gray2),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: gray2),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    hintText: 'email',
                                    hintStyle: TextStyle(
                                        fontFamily: 'PretendardMedium',
                                        fontSize: 14.0,
                                        color: gray2),
                                    contentPadding: EdgeInsets.all(10)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: gray2,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: gray2),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: gray2),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    hintText: 'password',
                                    hintStyle: TextStyle(
                                        fontFamily: 'PretendardMedium',
                                        fontSize: 14.0,
                                        color: gray2),
                                    contentPadding: EdgeInsets.all(10)),
                              ),
                            ],
                          ),
                        ))
                ],
              ),
            ),
          ),
          // 전송 버튼
          Positioned(
            top: isSignUpScreen ? 460 : 420,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [iris_80, iris_100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 1,
                          spreadRadius: 1,
                          //offset: offset(0, 1)),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
          Positioned(
            top: isSignUpScreen
                ? MediaQuery.of(context).size.height - 125
                : MediaQuery.of(context).size.height - 165,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(
                  isSignUpScreen ? 'or SignUp with' : 'or SignIn with',
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  onPressed: () {},

                  style: TextButton.styleFrom(

                      //primary: Colors.white,
                      //minimumSize: Size(155.0, 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: gray2), // 여기에 구글 컬러
                  icon: Icon(Icons.add),
                  label: Text('Google'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
