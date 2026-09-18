import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

/// Employee-facing view of incoming kiosk orders. Accepting an order
/// pushes it through POS -> Inventory (stock deduction) automatically.
class KioskManagementScreen extends StatelessWidget {
  const KioskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final orders = data.kioskOrders;
        return SectionPage(
          subtitle: 'Customer → Kiosk → POS → Inventory. Accept an order to process payment and deduct stock.',
          children: [
            if (orders.isEmpty)
              const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No incoming kiosk orders right now.', style: TextStyle(color: AppColors.textMuted)))),
            PaginatedList<OrderRecord>(
              items: orders,
              pageSize: 5,
              itemBuilder: (context, o) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.notifications_active_outlined, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Text('NEW KIOSK ORDER  ·  Order #${o.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          if (o.customerName != null) Text(o.customerName!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ]),
                        const Divider(),
                        ...o.items.map((i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('${i.quantity} × ${i.product.name}'),
                            )),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Total: ${peso(o.total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(children: [
                            OutlinedButton(onPressed: () => data.declineKioskOrder(o.id), child: const Text('Decline')),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                data.acceptKioskOrder(o.id, cashier: data.currentUser!.fullName);
                                showAppSnack(context, 'Order #${o.id} accepted — inventory updated.');
                              },
                              child: const Text('Accept Order'),
                            ),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        );
      },
    );
  }
}
