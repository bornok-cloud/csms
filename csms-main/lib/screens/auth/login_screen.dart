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
  String? _error;

  void _login() {
    final user =
        AppData.instance.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (user == null) {
      setState(() => _error = 'Invalid email or password.');
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

  Widget _mockAccountChip(String label, String email, String pass) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: AppColors.beige,
      onPressed: () {
        _emailCtrl.text = email;
        _passCtrl.text = pass;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_cafe,
                        size: 40, color: AppColors.brown),
                    const SizedBox(height: 8),
                    const Text('Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBrown)),
                    const SizedBox(height: 4),
                    const Text('Login to Overnight Cafe',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    TextField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined))),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(_error!,
                          style: const TextStyle(
                              color: AppColors.danger, fontSize: 13)),
                    ],
                    const SizedBox(height: 8),
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
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('OK'))
                            ],
                          ),
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        onPressed: _login,
                        child: const SizedBox(
                            width: double.infinity,
                            child: Text('Login', textAlign: TextAlign.center))),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
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
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _mockAccountChip('Admin', 'admin@cafe.com', 'admin123'),
                        _mockAccountChip(
                            'Employee', 'maria@cafe.com', 'employee123'),
                        _mockAccountChip(
                            'Customer', 'customer@cafe.com', 'customer123'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
