import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = new FlutterSecureStorage();

  // Get
  Future<String?> getStoredValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (error) {
      print('error');
    }
  }

  // 데이터 저장
  Future<void> StoreValue(String key, String value) async {
    try {
      return await storage.write(key: key, value: value);
    } catch (error) {
      print('error');
    }
  }
}
