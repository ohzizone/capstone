// #include <SoftwareSerial.h>
// #include <Arduino.h>

// // HM-10 모듈을 위한 소프트웨어 시리얼 포트 설정
// SoftwareSerial HM10(2, 3); // RX, TX

// void setup() {
//   Serial.begin(9600);
//   HM10.begin(9600);
// }

// void loop() {
//   // Bluetooth로부터 데이터가 있는지 확인
//   if (HM10.available()) {

//     //String myData = HM10.read()

//     //Serial.print(myData);


//     Serial.write(HM10.read());

//     String data = HM10.readStringUntil('\n');
//     Serial.print("Received from HM10: ");
//     Serial.println(data);

//     int colonIndex = data.indexOf(':');
//     if (colonIndex != -1) {
//       String distance = data.substring(0, colonIndex);
//       String time = data.substring(colonIndex + 1);

//       Serial.print("Processed Data: Distance-");
//       Serial.print(distance);
//       Serial.print(", Time-");
//       Serial.println(time);
//     } else {
//       Serial.println(data);
//     }
//   }
// }
