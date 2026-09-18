import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final user = data.currentUser!;
        final myAttendance = data.attendance.where((a) => a.employeeName == user.fullName).toList();
        final pendingOrders = data.kioskOrders.length;
        final lowStock = data.inventory.where((i) => i.status == 'Low Stock' || i.status == 'Out of Stock').length;

        return SectionPage(
          subtitle: 'Welcome back, ${user.fullName}! Here\'s what\'s happening today.',
          children: [
            StatGrid(cards: [
              StatCard(label: 'Pending Kiosk Orders', value: '$pendingOrders', icon: Icons.receipt_long_outlined, color: AppColors.info),
              StatCard(label: 'Low Stock Items', value: '$lowStock', icon: Icons.warning_amber_outlined, color: AppColors.warning),
              StatCard(label: 'My Attendance Logs', value: '${myAttendance.length}', icon: Icons.fingerprint, color: AppColors.brown),
              StatCard(label: 'Unread Notifications', value: '${data.unreadNotifications}', icon: Icons.notifications_outlined, color: AppColors.accent),
            ]),
            const SizedBox(height: 20),
            Text('Recent Notifications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ...data.notifications.take(5).map((n) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.circle_notifications_outlined, color: AppColors.brown),
                    title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(n.body),
                  ),
                )),
          ],
        );
      },
    );
  }
}
