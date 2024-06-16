import 'package:flutter/material.dart';
import 'package:running_mate/src/screens/HomeScreen.dart';
import 'package:running_mate/src/screens/Counter.dart';
import 'package:running_mate/src/screens/PracticeScreen.dart';
import 'package:running_mate/src/screens/test.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUpScreen = true;
  bool showSpinner = false;

  //사용자 등록 및 인증에 사용
  final _authentication = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  // 각 텍스트 입력 필드의 유효성 검사 결과를 저장하는 변수들
  String userNameError = '';
  String userEmailError = '';
  String userPasswordError = '';

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void _toggleScreen() {
    setState(() {
      isSignUpScreen = !isSignUpScreen;
    });
  }

  // 텍스트 입력이 변경될 때마다 유효성 검사 수행 및 결과 업데이트
  void _validateUserName(String value) {
    setState(() {
      userNameError =
          value.isEmpty || value.length < 4 ? '사용자 이름은 4글자 이상이어야 합니다.' : '';
    });
    userName = value;
  }

  void _validateUserEmail(String value) {
    setState(() {
      userEmailError =
          value.isEmpty || !value.contains('@') ? '유효한 이메일 주소를 입력하세요' : '';
    });
    userEmail = value;
  }

  void _validateUserPassword(String value) {
    setState(() {
      userPasswordError =
          value.isEmpty || value.length < 7 ? '비밀번호는 7자리 이상이어야 합니다.' : '';
    });
    userPassword = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray1,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
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
                                text: isSignUpScreen
                                    ? ' to Running Mate!'
                                    : ' back!',
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
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
                                if (!isSignUpScreen)
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
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key: ValueKey(1),
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return 'Please enter at least 4 characters';
                                      }
                                      return null;
                                    },
                                    onChanged: _validateUserName,
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                          color: gray2,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        hintText: 'User name',
                                        hintStyle: TextStyle(
                                            fontFamily: 'PretendardMedium',
                                            fontSize: 14.0,
                                            color: gray2),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  if (userNameError.isNotEmpty)
                                    Text(
                                      userNameError,
                                      style: TextStyle(
                                          color: errorColor,
                                          fontFamily: 'PretendardMedium'),
                                    ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key: ValueKey(2),
                                    validator: (value) {
                                      _validateUserEmail(value!);
                                      return userEmailError.isEmpty
                                          ? null
                                          : userEmailError;
                                    },
                                    onChanged: _validateUserEmail,
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: gray2,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        hintText: 'email',
                                        hintStyle: TextStyle(
                                            fontFamily: 'PretendardMedium',
                                            fontSize: 14.0,
                                            color: gray2),
                                        contentPadding: EdgeInsets.all(10),
                                        errorText: userEmailError.isNotEmpty
                                            ? userEmailError
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    key: ValueKey(3),
                                    validator: (value) {
                                      _validateUserPassword(value!);
                                      return userPasswordError.isEmpty
                                          ? null
                                          : userPasswordError;
                                    },
                                    onSaved: (value) {
                                      userPassword = value!;
                                    },
                                    onChanged: _validateUserPassword,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: gray2,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: gray2),
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                        ),
                                        hintText: 'password',
                                        hintStyle: TextStyle(
                                            fontFamily: 'PretendardMedium',
                                            fontSize: 14.0,
                                            color: gray2),
                                        contentPadding: EdgeInsets.all(10),
                                        errorText: userPasswordError.isNotEmpty
                                            ? userPasswordError
                                            : null),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isSignUpScreen)
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      key: ValueKey(4),
                                      validator: (value) {
                                        _validateUserEmail(value!);
                                        return userEmailError.isEmpty
                                            ? null
                                            : userEmailError;
                                      },
                                      onSaved: (value) {
                                        userEmail = value!;
                                      },
                                      onChanged: _validateUserEmail,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.mail,
                                            color: gray2,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: gray2),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: gray2),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'email',
                                          hintStyle: TextStyle(
                                              fontFamily: 'PretendardMedium',
                                              fontSize: 14.0,
                                              color: gray2),
                                          contentPadding: EdgeInsets.all(10),
                                          errorText: userEmailError.isNotEmpty
                                              ? userEmailError
                                              : null),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      key: ValueKey(5),
                                      onChanged: _validateUserPassword,
                                      validator: (value) {
                                        _validateUserPassword(value!);
                                        return userPasswordError.isEmpty
                                            ? null
                                            : userPasswordError;
                                      },
                                      onSaved: (value) {
                                        userPassword = value!;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: gray2,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: gray2),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: gray2),
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                          ),
                                          hintText: 'password',
                                          hintStyle: TextStyle(
                                              fontFamily: 'PretendardMedium',
                                              fontSize: 14.0,
                                              color: gray2),
                                          contentPadding: EdgeInsets.all(10),
                                          errorText:
                                              userPasswordError.isNotEmpty
                                                  ? userPasswordError
                                                  : null),
                                    ),
                                  ],
                                ),
                              ))
                      ],
                    ),
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
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (isSignUpScreen) {
                          _tryValidation();

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );
                            if (newUser != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return HomeScreen();
                                }),
                              );

                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch (e) {
                            // 에러 출력
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please check your email and password'),
                                backgroundColor: iris_80,
                              ),
                            );
                          }
                        }

                        if (!isSignUpScreen) {
                          //_tryValidation(); // 유효성 검사 실행

                          try {
                            final currentUser = await _authentication
                                .signInWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );

                            if (currentUser != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return PracticeScreen();
                                }),
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
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
              ),
              //구글 로그인 버튼
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
        ),
      ),
    );
  }
}
