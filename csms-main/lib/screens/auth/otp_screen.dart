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
  int _secondsLeft = 60;
  Timer? _timer;
  String? _error;
  bool _verified = false;
  bool _resending = false;

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
    if (code.length < 6) {
      setState(() => _error = 'Enter all 6 digits.');
      return;
    }
    final error = AppData.instance.verifyOtp(widget.user.id, code);
    if (error == null) {
      setState(() {
        _verified = true;
        _error = null;
      });
    } else {
      setState(() => _error = error);
    }
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      await AppData.instance.resendOtp(widget.user.id);
      if (!mounted) return;
      setState(() {
        _error = null;
        for (final c in _controllers) {
          c.clear();
        }
      });
      _nodes.first.requestFocus();
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A new code was sent to ${widget.user.email}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not resend code: $e');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_verified) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: AppShadows.soft,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 44),
                    ),
                    const SizedBox(height: 18),
                    Text('Account Activated!', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Your account has been verified successfully.',
                        textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false),
                        child: const Text('Go to Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Verify Your Account'), backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(22),
                boxShadow: AppShadows.soft,
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                        color: AppColors.beige, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.mark_email_read_outlined, size: 30, color: AppColors.brown),
                  ),
                  const SizedBox(height: 16),
                  Text('Enter OTP Code', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('We sent a 6-digit code to ${widget.user.email}',
                      textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          width: 46,
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _nodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.darkBrown),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              fillColor: AppColors.beige.withValues(alpha: 0.5),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.lightBrown.withValues(alpha: 0.3)),
                              ),
                            ),
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
                    const SizedBox(height: 14),
                    Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(onPressed: _verify, child: const Text('Verify')),
                  ),
                  const SizedBox(height: 14),
                  _secondsLeft > 0
                      ? Text('Resend OTP in $_secondsLeft s', style: const TextStyle(color: AppColors.textMuted))
                      : TextButton(
                          onPressed: _resending ? null : _resend,
                          child: _resending
                              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Resend OTP'),
                        ),
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
    );
  }
}
