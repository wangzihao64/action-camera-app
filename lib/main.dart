import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    // 使用 Provider 进行状态管理
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: '运动相机 App',
      theme: CupertinoThemeData(
        primaryColor: Color(0xFFFF6B35),
      ),
      home: AuthChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 认证检查器 - 根据登录状态决定显示哪个页面
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 检查登录状态
  Future<void> _checkLoginStatus() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.init();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // 加载中显示启动画面
      return const CupertinoPageScaffold(
        child: Center(
          child: CupertinoActivityIndicator(radius: 20),
        ),
      );
    }

    // 根据登录状态决定显示哪个页面
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return authProvider.isLoggedIn
            ? const HomeScreen()  // 已登录 -> 主页
            : const LoginScreen(); // 未登录 -> 登录页
      },
    );
  }
}
