import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../models/models.dart';
import '../admin/admin_shell.dart';
import '../employee/employee_shell.dart';
import '../customer/customer_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'admin@cafe.com');
  final _passCtrl = TextEditingController(text: 'admin123');
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    final user =
        AppData.instance.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (!mounted) return;
    if (user == null) {
      setState(() {
        _error = 'Invalid email or password.';
        _submitting = false;
      });
      return;
    }
    Widget target;
    switch (user.role) {
      case UserRole.admin:
        target = const AdminShell();
        break;
      case UserRole.employee:
        target = const EmployeeShell();
        break;
      case UserRole.customer:
        target = const CustomerShell();
        break;
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => target), (route) => false);
  }

  Widget _mockAccountChip(String label, IconData icon, String email, String pass) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.brown),
      label: Text(label, style: const TextStyle(fontSize: 12.5)),
      backgroundColor: AppColors.beige,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.25))),
      onPressed: () {
        setState(() {
          _emailCtrl.text = email;
          _passCtrl.text = pass;
          _error = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Decorative gradient backdrop
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkBrown, AppColors.brown],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.18),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppShadows.lifted,
                    ),
                    padding: const EdgeInsets.fromLTRB(32, 36, 32, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.accent, AppColors.brownDeep],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColors.accent.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6)),
                              ],
                            ),
                            child: const Icon(Icons.local_cafe_rounded,
                                size: 30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text('Welcome Back',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        const Text('Login to Overnight Cafe',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted)),
                        const SizedBox(height: 28),
                        TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined))),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          onSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: _error != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.danger.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(_error!,
                                                style: const TextStyle(color: AppColors.danger, fontSize: 13))),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Forgot Password'),
                                content: const Text(
                                    'A password reset link would be sent to your registered email.'),
                                actions: [
                                  FilledButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('OK'))
                                ],
                              ),
                            ),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: _submitting ? null : _login,
                              child: _submitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.4, color: Colors.white))
                                  : const Text('Login')),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ",
                                style: TextStyle(color: AppColors.textMuted)),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterScreen())),
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        const Text('Demo accounts (tap to autofill):',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _mockAccountChip('Admin', Icons.admin_panel_settings_outlined,
                                'admin@cafe.com', 'admin123'),
                            _mockAccountChip('Employee', Icons.badge_outlined,
                                'maria@cafe.com', 'employee123'),
                            _mockAccountChip('Customer', Icons.person_outline,
                                'customer@cafe.com', 'customer123'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
