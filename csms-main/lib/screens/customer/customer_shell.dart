import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/app_data.dart';
import '../auth/login_screen.dart';
import 'customer_kiosk_screen.dart';
import 'my_orders_screen.dart';
import 'customer_feedback_screen.dart';
import 'customer_profile_screen.dart';

class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Overnight Cafe',
      onLogout: () {
        AppData.instance.logout();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
      },
      items: [
        NavItem(icon: Icons.storefront_outlined, label: 'Menu / Kiosk', builder: () => const CustomerKioskScreen()),
        NavItem(icon: Icons.receipt_long_outlined, label: 'My Orders', builder: () => const MyOrdersScreen()),
        NavItem(icon: Icons.star_border, label: 'Feedback', builder: () => const CustomerFeedbackScreen()),
        NavItem(icon: Icons.person_outline, label: 'Profile', builder: () => const CustomerProfileScreen()),
      ],
    );
  }
}
