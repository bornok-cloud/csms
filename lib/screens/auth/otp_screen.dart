import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../models/models.dart';
import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  final AppUser user;
  const OtpScreen({super.key, required this.user});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  static const _correctOtp = '123456'; // mock OTP for demonstration
  int _secondsLeft = 60;
  Timer? _timer;
  String? _error;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _verify() {
    final code = _controllers.map((c) => c.text).join();
    if (code == _correctOtp) {
      AppData.instance.activateUser(widget.user.id);
      setState(() {
        _verified = true;
        _error = null;
      });
    } else {
      setState(() => _error = 'Incorrect OTP. Please try again. (Hint: 123456)');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_verified) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 72),
                const SizedBox(height: 16),
                const Text('Account Activated!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                const SizedBox(height: 8),
                const Text('Your account has been verified successfully.', style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mark_email_read_outlined, size: 40, color: AppColors.brown),
                    const SizedBox(height: 12),
                    const Text('Enter OTP Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                    const SizedBox(height: 8),
                    Text('We sent a 6-digit code to ${widget.user.email}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: 44,
                            child: TextField(
                              controller: _controllers[i],
                              focusNode: _nodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(counterText: ''),
                              onChanged: (v) {
                                if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
                                if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13), textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: _verify, child: const SizedBox(width: double.infinity, child: Text('Verify', textAlign: TextAlign.center))),
                    const SizedBox(height: 14),
                    _secondsLeft > 0
                        ? Text('Resend OTP in $_secondsLeft s', style: const TextStyle(color: AppColors.textMuted))
                        : TextButton(onPressed: _startTimer, child: const Text('Resend OTP')),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Change Email'),
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
