// 서보 모터 제어를 위한 Servo 라이브러리 포함
#include <Servo.h>  

// 핀 설정: 모터 드라이버 연결 핀
int IN1=A1;
int IN2=A0;
int IN3=A3;
int IN4=A2;

// PWM 핀 설정: 모터의 속도 제어를 위한 핀
int MotorLPWM=5; // 왼쪽 모터 PWM
int MotorRPWM=6; // 오른쪽 모터 PWM

// 초음파 센서 핀 설정
int inputPin = 9;  // 초음파 센서 에코 핀
int outputPin = 8; // 초음파 센서 트리거 핀

Servo myservo;  // 서보 객체 생성

void setup() {
    Serial.begin(9600); // 시리얼 통신 시작, 9600bps
    pinMode(IN1, OUTPUT);
    pinMode(IN2, OUTPUT);
    pinMode(IN3, OUTPUT);
    pinMode(IN4, OUTPUT);
    pinMode(MotorLPWM, OUTPUT);
    pinMode(MotorRPWM, OUTPUT);
    pinMode(inputPin, INPUT);
    pinMode(outputPin, OUTPUT);
    
    // 서보 모터를 디지털 10번 핀에 연결
    myservo.attach(10);  
}

void stopp() {
    // 모든 모터 입력 핀을 LOW로 설정하여 모터 정지
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);
    digitalWrite(IN3, LOW);
    digitalWrite(IN4, LOW);
}

void detection() {
		// 서보 모터를 90도 위치로 회전
    myservo.write(90);  
    
    // 초음파 센서 신호 발생
    digitalWrite(outputPin, LOW);
    delayMicroseconds(2);
    digitalWrite(outputPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(outputPin, LOW);
    
    // 에코 핀에서 HIGH 신호의 지속 시간 측정
    float distance = pulseIn(inputPin, HIGH);
    // 거리 계산 (센티미터 단위)  
    distance = distance / 58.0;  

    if (distance < 25) {  // 거리가 25cm 미만이면 정지
        stopp();
    }
}

void loop() {
    detection();  // 반복적으로 거리 감지
}