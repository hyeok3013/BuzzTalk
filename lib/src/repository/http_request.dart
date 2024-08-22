import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Http {
  final String baseUrl;
  static final Http _instance = Http._internal('http://172.30.1.71:3000');

  factory Http() {
    return _instance;
  }

  Http._internal(this.baseUrl);

  // 쿠키를 저장합니다.
  Future<void> _saveCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('connect.sid', cookie); // connect.sid로 저장
  }

  // 쿠키를 로드합니다.
  Future<String?> _loadCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('connect.sid'); // connect.sid로 로드
  }

  // GET 요청
  Future<dynamic> get(String endpoint) async {
    final cookie = await _loadCookie();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: cookie != null
          ? {'Cookie': 'connect.sid=$cookie'}
          : {}, // connect.sid 사용
    );

    print(response.headers);

    if (response.statusCode == 200) {
      // 쿠키가 응답에 포함되어 있을 경우 저장
      final setCookieHeader = response.headers['set-cookie'];
      if (setCookieHeader != null) {
        // 쿠키를 추출하여 저장합니다.
        final cookieValue = _extractCookieValue(setCookieHeader);
        if (cookieValue != null) {
          await _saveCookie(cookieValue);
        }
      }

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // POST 요청
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final cookie = await _loadCookie();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': 'connect.sid=$cookie', // connect.sid 사용
      },
      body: jsonEncode(data),
    );
    print(response.headers);
    if (response.statusCode == 201 || response.statusCode == 200) {
      // 쿠키가 응답에 포함되어 있을 경우 저장
      final setCookieHeader = response.headers['set-cookie'];
      if (setCookieHeader != null) {
        // 쿠키를 추출하여 저장합니다.
        final cookieValue = _extractCookieValue(setCookieHeader);
        if (cookieValue != null) {
          await _saveCookie(cookieValue);
        }
      }

      return jsonDecode(response.body);
    } else {
      // 서버 오류 메시지를 처리
      Map<String, dynamic> errorResponse;
      try {
        errorResponse = jsonDecode(response.body);
      } catch (e) {
        errorResponse = {'error': 'An unexpected error occurred'};
      }
      String errorMessage = errorResponse['message'] ?? 'error!';
      throw Exception(errorMessage);
    }
  }

  // 응답 헤더에서 쿠키 값을 추출합니다.
  String? _extractCookieValue(String setCookieHeader) {
    final cookieParts = setCookieHeader.split(';');
    if (cookieParts.isNotEmpty) {
      return cookieParts[0].split('=')[1]; // 쿠키 값만 추출
    }
    return null;
  }
}
