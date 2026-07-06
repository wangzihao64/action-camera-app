import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// 认证状态管理
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _phoneNumber;
  String? _username;
  String? _token;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get phoneNumber => _phoneNumber;
  String? get username => _username;
  String? get token => _token;
  String? get userId => _userId;

  /// 初始化 - 从本地存储读取登录状态
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _phoneNumber = prefs.getString('phoneNumber');
    _username = prefs.getString('username');
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  /// 手机号验证码登录
  Future<bool> loginWithPhone(String phone, String code) async {
    // TODO: 这里应该调用真实的后端 API
    // 目前仅做模拟验证
    if (code == '123456') {
      _isLoggedIn = true;
      _phoneNumber = phone;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      // 保存到本地
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('phoneNumber', phone);
      await prefs.setString('userId', _userId!);

      notifyListeners();
      return true;
    }
    return false;
  }

  /// 微信登录
  Future<bool> loginWithWechat() async {
    // TODO: 集成微信 SDK
    // 目前仅做模拟
    _isLoggedIn = true;
    _phoneNumber = '微信用户';
    _userId = 'wechat_${DateTime.now().millisecondsSinceEpoch}';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('phoneNumber', _phoneNumber!);
    await prefs.setString('userId', _userId!);

    notifyListeners();
    return true;
  }

  /// 用户名密码登录（示例）
  Future<bool> loginWithUsername(String username, String password) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:3000/api/v1/user/login');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_name': username, 'password': password}),
      );

      if (resp.statusCode == 200) {
        final response = jsonDecode(resp.body) as Map<String, dynamic>;

        // 检查业务状态码，只有 200 才是成功
        final status = response['Status'] ?? response['status'];
        if (status != 200) {
          if (kDebugMode) {
            print('Login failed with status: $status, msg: ${response['Msg']}');
          }
          return false;
        }

        // 从 Data 字段中获取用户信息和 token
        final data = response['Data'] ?? response['data'];
        if (data == null) {
          return false;
        }

        _isLoggedIn = true;
        _token = data['Token'] ?? data['token'];

        // 从 User 对象中获取用户信息
        final user = data['User'] ?? data['user'];
        if (user != null) {
          _username = user['user_name'] ?? user['username'] ?? username;
          _userId = user['id']?.toString() ?? 'user_${DateTime.now().millisecondsSinceEpoch}';
        } else {
          _username = username;
          _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        if (_username != null) await prefs.setString('username', _username!);
        if (_token != null) await prefs.setString('token', _token!);
        if (_userId != null) await prefs.setString('userId', _userId!);

        notifyListeners();
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('loginWithUsername error: $e');
      }
    }
    return false;
  }

  /// 退出登录
  Future<void> logout() async {
    _isLoggedIn = false;
    _phoneNumber = null;
    _userId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}
