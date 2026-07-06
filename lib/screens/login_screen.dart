import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// 现代化的登录界面 - iOS 风格
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      child: Stack(
        children: [
          // 背景装饰
          _buildBackgroundDecoration(),

          // 主内容
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildFormCard(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 16),
                    _buildSecondaryActions(),
                    const SizedBox(height: 32),
                    _buildDivider(),
                    const SizedBox(height: 32),
                    _buildWechatButton(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建背景装饰
  Widget _buildBackgroundDecoration() {
    return Positioned.fill(
      child: Stack(
        children: [
          // 顶部渐变装饰
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.15),
                    const Color(0xFF6366F1).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          // 左下装饰
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEC4899).withOpacity(0.12),
                    const Color(0xFFEC4899).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建头部区域 - 左对齐，更现代
  Widget _buildHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 小图标 Logo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.videocam_fill,
              color: CupertinoColors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 32),
          // 主标题
          const Text(
            '开始你的',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
              letterSpacing: -1,
            ),
          ),
          // 副标题带 emoji
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '运动之旅',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(text: ' ⚡️', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 描述文字
          Text(
            '记录每一个精彩瞬间',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey.withOpacity(0.8),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // 构建表单卡片
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildUsernameInput(),
          const SizedBox(height: 16),
          _buildPasswordInput(),
        ],
      ),
    );
  }

  // 用户名输入框
  Widget _buildUsernameInput() {
    return CupertinoTextField(
      controller: _usernameController,
      placeholder: '用户名',
      keyboardType: TextInputType.text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(
          CupertinoIcons.person_fill,
          color: Color(0xFF6366F1),
          size: 20,
        ),
      ),
    );
  }

  // 密码输入框
  Widget _buildPasswordInput() {
    return CupertinoTextField(
      controller: _passwordController,
      placeholder: '密码',
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(
          CupertinoIcons.lock_fill,
          color: Color(0xFFA855F7),
          size: 20,
        ),
      ),
    );
  }

  // 构建登录按钮
  Widget _buildLoginButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _handleLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Text(
          '登录',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // 构建次要操作按钮（忘记密码、立即注册）
  Widget _buildSecondaryActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          onPressed: () {
            _showAlert('提示', '忘记密码功能开发中...');
          },
          child: Text(
            '忘记密码？',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          onPressed: () {
            _showAlert('提示', '注册功能开发中...');
          },
          child: const Text(
            '立即注册',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // 构建分隔线
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '或',
            style: TextStyle(
              color: CupertinoColors.systemGrey.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
      ],
    );
  }

  // 构建微信登录按钮
  Widget _buildWechatButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: _handleWechatLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.chat_bubble_text_fill,
              color: Color(0xFF07C160),
              size: 22,
            ),
            SizedBox(width: 10),
            Text(
              '微信登录',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // （已改为用户名+密码，因此移除验证码逻辑）

  // 处理登录
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      _showAlert('提示', '请输入用户名');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      _showAlert('提示', '请输入正确的密码（至少6位）');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithUsername(username, password);

    if (success) {
      if (mounted) {
        _showAlert('成功', '登录成功！');
      }
    } else {
      _showAlert('错误', '用户名或密码错误，请重试');
    }
  }

  // 处理微信登录
  Future<void> _handleWechatLogin() async {
    final authProvider = context.read<AuthProvider>();

    // TODO: 集成真实的微信 SDK
    final success = await authProvider.loginWithWechat();

    if (success && mounted) {
      _showAlert('成功', '微信登录成功！');
    }
  }

  // 显示提示框
  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
