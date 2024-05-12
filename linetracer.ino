int IN1 = A1; // 모터 드라이버의 입력 핀 1
int IN2 = A0; // 모터 드라이버의 입력 핀 2

int IN3 = A3; // 모터 드라이버의 입력 핀 3
int IN4 = A2; // 모터 드라이버의 입력 핀 4

int L_IR = 1; // 왼쪽 적외선 센서 연결 핀
int R_IR = 4; // 오른쪽 적외선 센서 연결 핀

int MotorRPWM=6; // 오른쪽 모터 PWM 제어 핀
int MotorLPWM=5; // 왼쪽 모터 PWM 제어 핀

void setup()
{
    pinMode(IN1,OUTPUT); // 핀 모드 설정
    pinMode(IN2,OUTPUT);
    pinMode(IN3,OUTPUT);
    pinMode(IN4,OUTPUT);
    pinMode(L_IR,INPUT); // 센서 핀을 입력으로 설정
    pinMode(R_IR,INPUT);
    
    // 시리얼 통신 시작 (9600bps)
    Serial.begin(9600); 
}

void loop() 
{
  
  int L_VAL = digitalRead(L_IR); // 왼쪽 센서 값 읽기
  int R_VAL = digitalRead(R_IR); // 오른쪽 센서 값 읽기

  if((L_VAL == 0) && (R_VAL == 1)) // 왼쪽에 장애물이 있을 경우
  {
      motor_right(255);  // 오른쪽으로 회전
  }
  
  else if((L_VAL == 1) && (R_VAL == 0)) // 오른쪽에 장애물이 있을 경우
  {
      motor_left(255);  // 왼쪽으로 회전
  }
  
  else if((L_VAL == 1) && (R_VAL == 1)) // 양쪽 모두 장애물이 없을 경우
  {
      motor_forward(0); // 정지
  }
  
  else if((L_VAL == 0) && (R_VAL == 0)) // 양쪽 모두 장애물이 있을 경우
  {
      motor_forward(255); // 전진
  }
}

void motor_forward(int SpeedVal)
{
    analogWrite(IN1,SpeedVal); // 모터 전진
    analogWrite(IN2,0);
    analogWrite(MotorRPWM,SpeedVal);
    
    analogWrite(IN3,0);
    analogWrite(IN4,SpeedVal);
    analogWrite(MotorLPWM,SpeedVal); 
}

void motor_backward(int SpeedVal)
{
    analogWrite(IN1,0);
    analogWrite(IN2,SpeedVal); // 모터 후진
    
    analogWrite(IN3,SpeedVal);
    analogWrite(IN4,0);
    analogWrite(MotorRPWM,SpeedVal);
    analogWrite(MotorLPWM,SpeedVal); 
}

void motor_right(int SpeedVal)
{
    analogWrite(IN1,0);
    analogWrite(IN2,SpeedVal); // 오른쪽 모터 후진으로 설정하여 오른쪽으로 회전
    analogWrite(MotorRPWM,SpeedVal);
    
    analogWrite(IN3,0);
    analogWrite(IN4,SpeedVal); // 왼쪽 모터 전진으로 설정
    analogWrite(MotorLPWM,SpeedVal); 
}

void motor_left(int SpeedVal)
{
    analogWrite(IN1,SpeedVal); // 왼쪽 모터 전진으로 설정
    analogWrite(IN2,0);
    analogWrite(MotorRPWM,SpeedVal);
    
    analogWrite(IN3,SpeedVal); // 오른쪽 모터 후진으로 설정하여 왼쪽으로 회전
    analogWrite(IN4,0);
    analogWrite(MotorLPWM,SpeedVal); 
}

void motor_stop()
{
    analogWrite(IN1,0);
    analogWrite(IN2,0);
    
    analogWrite(IN3,0);
    analogWrite(IN4,0); // 모든 모터 정지
}