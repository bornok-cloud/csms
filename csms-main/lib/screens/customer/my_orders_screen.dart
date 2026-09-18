import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final me = data.currentUser?.fullName;
        final myOrders = data.kioskOrders.where((o) => o.customerName == me).toList();
        final myTransactions = data.transactions.where((t) => t.items.isNotEmpty).toList(); // demo: show all completed café transactions

        return SectionPage(children: [
          Text('Pending Orders', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          if (myOrders.isEmpty) const Text('No pending orders.', style: TextStyle(color: AppColors.textMuted)),
          PaginatedList<OrderRecord>(
            items: myOrders,
            pageSize: 5,
            itemBuilder: (context, o) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.hourglass_bottom, color: AppColors.warning),
                  title: Text('Order #${o.id}'),
                  subtitle: Text(o.items.map((i) => '${i.quantity}x ${i.product.name}').join(', ')),
                  trailing: Text(peso(o.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ),
          const SizedBox(height: 24),
          Text('Order History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          if (myTransactions.isEmpty) const Text('No completed orders yet.', style: TextStyle(color: AppColors.textMuted)),
          PaginatedList<TransactionRecord>(
            items: myTransactions.reversed.toList(),
            pageSize: 5,
            itemBuilder: (context, t) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: AppColors.success),
                  title: Text(t.id),
                  subtitle: Text(t.items.map((i) => '${i.quantity}x ${i.product.name}').join(', ')),
                  trailing: Text(peso(t.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ),
        ]);
      },
    );
  }
}
