import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final todaySales = data.transactions.fold(0.0, (s, t) => s + t.total);
        final lowStock = data.inventory
            .where((i) => i.status == 'Low Stock' || i.status == 'Out of Stock')
            .toList();
        final nearExpiry =
            data.inventory.where((i) => i.status == 'Near Expiration').toList();
        final customers =
            data.users.where((u) => u.role.name == 'customer').length;
        final employees = data.employees.length;

        return SectionPage(
          subtitle: 'Overview of café performance today.',
          children: [
            StatGrid(cards: [
              StatCard(
                  label: "Today's Sales",
                  value: peso(todaySales),
                  icon: Icons.trending_up,
                  color: AppColors.success),
              StatCard(
                  label: 'Total Sales',
                  value: peso(todaySales),
                  icon: Icons.attach_money,
                  color: AppColors.brown),
              StatCard(
                  label: 'Total Customers',
                  value: '$customers',
                  icon: Icons.people_alt_outlined,
                  color: AppColors.info),
              StatCard(
                  label: 'Total Employees',
                  value: '$employees',
                  icon: Icons.badge_outlined,
                  color: AppColors.accent),
              StatCard(
                  label: 'Low Stock Items',
                  value: '${lowStock.length}',
                  icon: Icons.warning_amber_outlined,
                  color: AppColors.warning),
              StatCard(
                  label: 'Near-Expiration',
                  value: '${nearExpiry.length}',
                  icon: Icons.timer_outlined,
                  color: const Color(0xFFE07A2F)),
              StatCard(
                  label: 'Payroll Expenses',
                  value: peso(data.totalPayrollExpense),
                  icon: Icons.payments_outlined,
                  color: AppColors.danger),
              StatCard(
                  label: 'Petty Cash Balance',
                  value: peso(data.pettyCashBalance),
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppColors.success),
            ]),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: _MiniChartCard(
                        title: 'Weekly Sales Trend', child: _BarSketch())),
                const SizedBox(width: 16),
                Expanded(
                    child: _MiniChartCard(
                        title: 'Best-Selling Products',
                        child: _BestSellers(products: data.products))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _MiniChartCard(
                        title: 'Inventory Status',
                        child:
                            _InventoryDonutSketch(inventory: data.inventory))),
                const SizedBox(width: 16),
                Expanded(child: _NotificationPanel()),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _MiniChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _MiniChartCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _BarSketch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [0.5, 0.7, 0.4, 0.9, 0.65, 0.8, 1.0];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 110 * values[i],
                    decoration: BoxDecoration(
                      color: i == values.length - 1
                          ? AppColors.accent
                          : AppColors.brown.withValues(alpha: 0.75),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(days[i],
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BestSellers extends StatelessWidget {
  final List products;
  const _BestSellers({required this.products});
  @override
  Widget build(BuildContext context) {
    final top = products.take(4).toList();
    return Column(
      children: top.map<Widget>((p) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Text(p.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(p.name, style: const TextStyle(fontSize: 13))),
              Text(peso(p.price),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InventoryDonutSketch extends StatelessWidget {
  final List inventory;
  const _InventoryDonutSketch({required this.inventory});
  @override
  Widget build(BuildContext context) {
    final total = inventory.length;
    final low = inventory.where((i) => i.status == 'Low Stock').length;
    final out = inventory.where((i) => i.status == 'Out of Stock').length;
    final near = inventory.where((i) => i.status == 'Near Expiration').length;
    final ok = total - low - out - near;
    Widget row(String label, int count, Color color) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        );
    return Column(children: [
      row('In Stock', ok, AppColors.success),
      row('Low Stock', low, AppColors.warning),
      row('Out of Stock', out, AppColors.danger),
      row('Near Expiration', near, const Color(0xFFE07A2F)),
    ]);
  }
}

class _NotificationPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (data.notifications.isEmpty)
              const Text('No notifications yet.',
                  style: TextStyle(color: AppColors.textMuted)),
            ...data.notifications.take(4).map((n) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle_notifications_outlined,
                          color: AppColors.brown, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(n.body,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
