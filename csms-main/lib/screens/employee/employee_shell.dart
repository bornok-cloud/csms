import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/app_data.dart';
import '../auth/login_screen.dart';
import '../admin/messaging_screen.dart';
import '../admin/inventory_screen.dart';
import '../admin/pos_screen.dart';
import '../admin/feedback_screen.dart';
import 'employee_dashboard.dart';
import 'kiosk_management_screen.dart';
import 'attendance_screen.dart';
import 'employee_payroll_screen.dart';
import 'employee_profile_screen.dart';

class EmployeeShell extends StatelessWidget {
  const EmployeeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.instance.currentUser!;
    return AppShell(
      title: 'Employee Panel',
      trailing: const NotificationBell(),
      onLogout: () {
        AppData.instance.logout();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
      },
      items: [
        NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard', builder: () => const EmployeeDashboard()),
        NavItem(icon: Icons.point_of_sale_outlined, label: 'POS', builder: () => PosScreen(cashier: user.fullName)),
        NavItem(icon: Icons.storefront_outlined, label: 'Kiosk', builder: () => const KioskManagementScreen()),
        NavItem(icon: Icons.inventory_2_outlined, label: 'Inventory', builder: () => const InventoryScreen(readOnly: true)),
        NavItem(icon: Icons.fingerprint, label: 'Attendance', builder: () => const AttendanceScreen()),
        NavItem(icon: Icons.payments_outlined, label: 'Payroll', builder: () => const EmployeePayrollScreen()),
        NavItem(icon: Icons.chat_outlined, label: 'Messaging', builder: () => MessagingScreen(currentRole: user.fullName)),
        NavItem(icon: Icons.star_border, label: 'Customer Feedback', builder: () => const FeedbackScreen(canReply: false)),
        NavItem(icon: Icons.person_outline, label: 'Employee Profile', builder: () => const EmployeeProfileScreen()),
      ],
    );
  }
}
