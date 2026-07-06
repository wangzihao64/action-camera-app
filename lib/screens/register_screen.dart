import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 注册页面 - iOS 风格
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoadingCode = false;
  int _countdown = 0;
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
    _emailController.dispose();
    _codeController.dispose();
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
            child: Column(
              children: [
                // 返回按钮
                _buildAppBar(),
                // 滚动内容
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildHeader(),
                          const SizedBox(height: 40),
                          _buildFormCard(),
                          const SizedBox(height: 24),
                          _buildRegisterButton(),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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

  // 构建顶部导航栏
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(
              CupertinoIcons.back,
              color: Color(0xFF1A1A1A),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // 构建头部
  Widget _buildHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '创建账号',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.2,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '开启你的运动之旅 🚀',
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
          _buildEmailInput(),
          const SizedBox(height: 16),
          _buildCodeInput(),
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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(CupertinoIcons.person_fill, color: Color(0xFF6366F1), size: 20),
      ),
    );
  }

  // 邮箱输入框
  Widget _buildEmailInput() {
    return CupertinoTextField(
      controller: _emailController,
      placeholder: '邮箱',
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(CupertinoIcons.mail_solid, color: Color(0xFFA855F7), size: 20),
      ),
    );
  }

  // 邮箱验证码输入框
  Widget _buildCodeInput() {
    return Row(
      children: [
        Expanded(
          child: CupertinoTextField(
            controller: _codeController,
            placeholder: '邮箱验证码',
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            prefix: const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(CupertinoIcons.lock_fill, color: Color(0xFFEC4899), size: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _countdown > 0 ? null : _sendEmailCode,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _countdown > 0 ? const Color(0xFFF8F9FA) : const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isLoadingCode
                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                : Text(
                    _countdown > 0 ? '${_countdown}s' : '发送',
                    style: TextStyle(
                      color: _countdown > 0 ? CupertinoColors.systemGrey : CupertinoColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // 密码输入框
  Widget _buildPasswordInput() {
    return CupertinoTextField(
      controller: _passwordController,
      placeholder: '密码',
      obscureText: true,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      prefix: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Icon(CupertinoIcons.lock_shield_fill, color: Color(0xFFF97316), size: 20),
      ),
    );
  }

  // 注册按钮
  Widget _buildRegisterButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        _showAlert('提示', '注册功能开发中...');
      },
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
          '立即注册',
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

  // 发送邮箱验证码
  Future<void> _sendEmailCode() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showAlert('提示', '请输入正确的邮箱地址');
      return;
    }

    setState(() => _isLoadingCode = true);

    // TODO: 调用真实的后端 API 发送验证码
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoadingCode = false;
      _countdown = 60;
    });

    _showAlert('提示', '验证码已发送到 $email\n测试验证码: 123456');

    // 倒计时
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown > 0) {
        setState(() => _countdown--);
        _startCountdown();
      }
    });
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
