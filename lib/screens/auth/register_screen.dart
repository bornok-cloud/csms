import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    final user = AppData.instance.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Join Overnight Cafe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                      const SizedBox(height: 4),
                      const Text('Create a customer account to order & earn perks.', style: TextStyle(color: AppColors.textMuted)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                        validator: (v) => (v == null || v.trim().length < 7) ? 'Enter a valid phone number' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure1,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure1 = !_obscure1)),
                        ),
                        validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: _obscure2,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure2 = !_obscure2)),
                        ),
                        validator: (v) => (v != _passCtrl.text) ? 'Passwords do not match' : null,
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton(onPressed: _register, child: const SizedBox(width: double.infinity, child: Text('Register', textAlign: TextAlign.center))),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Login')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
