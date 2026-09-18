import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/app_data.dart';
import '../auth/login_screen.dart';
import 'admin_dashboard.dart';
import 'reports_screen.dart';
import 'messaging_screen.dart';
import 'inventory_screen.dart';
import 'payroll_screen.dart';
import 'pos_screen.dart';
import 'feedback_screen.dart';
import 'procurement_screen.dart';
import 'petty_cash_screen.dart';
import 'user_management_screen.dart';
import 'archive_screen.dart';
import 'admin_profile_screen.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Admin Panel',
      trailing: const NotificationBell(),
      onLogout: () {
        AppData.instance.logout();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
      },
      items: [
        NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard', builder: () => const AdminDashboard()),
        NavItem(icon: Icons.bar_chart_outlined, label: 'Reports & Analytics', builder: () => const ReportsScreen()),
        NavItem(icon: Icons.chat_outlined, label: 'Messaging', builder: () => const MessagingScreen(currentRole: 'Admin')),
        NavItem(icon: Icons.inventory_2_outlined, label: 'Inventory / Kitchen', builder: () => const InventoryScreen(readOnly: false)),
        NavItem(icon: Icons.payments_outlined, label: 'Payroll', builder: () => const PayrollScreen()),
        NavItem(icon: Icons.point_of_sale_outlined, label: 'POS', builder: () => const PosScreen(cashier: 'Admin')),
        NavItem(icon: Icons.star_border, label: 'Customer Feedback', builder: () => const FeedbackScreen(canReply: true)),
        NavItem(icon: Icons.local_shipping_outlined, label: 'Procurement', builder: () => const ProcurementScreen()),
        NavItem(icon: Icons.account_balance_wallet_outlined, label: 'Petty Cash', builder: () => const PettyCashScreen()),
        NavItem(icon: Icons.people_outline, label: 'User Management', builder: () => const UserManagementScreen()),
        NavItem(icon: Icons.archive_outlined, label: 'Archive', builder: () => const ArchiveScreen()),
        NavItem(icon: Icons.person_outline, label: 'Admin Profile', builder: () => const AdminProfileScreen()),
      ],
    );
  }
}
