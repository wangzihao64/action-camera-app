import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证状态管理
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _phoneNumber;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get phoneNumber => _phoneNumber;
  String? get userId => _userId;

  /// 初始化 - 从本地存储读取登录状态
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _phoneNumber = prefs.getString('phoneNumber');
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
