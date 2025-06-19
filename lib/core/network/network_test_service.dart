import 'package:dio/dio.dart';

class NetworkTestService {
  static Future<bool> testConnectivity() async {
    try {
      final dio = Dio();

      // Test with a reliable public API first
      final response = await dio.get('https://httpbin.org/get');

      if (response.statusCode == 200) {
        print('✅ Basic internet connectivity: OK');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Basic internet connectivity failed: $e');
      return false;
    }
  }

  static Future<bool> testBusinessClassProfileAPI() async {
    try {
      final dio = Dio();

      // Test if the businessclassprofile.com domain is reachable
      final response = await dio.get('https://businessclassprofile.com');

      if (response.statusCode == 200) {
        print('✅ businessclassprofile.com is reachable');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ businessclassprofile.com test failed: $e');
      return false;
    }
  }
}
