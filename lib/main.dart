import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/landing/landing_page.dart';

void main() {
  runApp(const CafeManagementApp());
}

class CafeManagementApp extends StatelessWidget {
  const CafeManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overnight Cafe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LandingPage(),
    );
  }
}
