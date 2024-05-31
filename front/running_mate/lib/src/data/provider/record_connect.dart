import 'package:running_mate/src/constants/pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceHistory {
  static void saveDevice(String deviceId) {
    SharedPreferences.getInstance().then((prefs) {
      //기존의 저장된 디바이스 목록 불러오기
      List<String>? deviceList =
          prefs.getStringList(PrefsKey.deviceListKey) ?? [];

      if (!deviceList.contains(deviceId)) {
        //중복체크 후 저장
        deviceList.add(deviceId);
        prefs.setStringList(PrefsKey.deviceListKey, deviceList);
      }
    });
  }
}
