import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class ProcurementScreen extends StatefulWidget {
  const ProcurementScreen({super.key});
  @override
  State<ProcurementScreen> createState() => _ProcurementScreenState();
}

class _ProcurementScreenState extends State<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final needsRestock = data.inventory.where((i) => i.status == 'Low Stock' || i.status == 'Out of Stock').toList();
        return SectionPage(
          subtitle: 'Inventory → Low Stock → Admin Alert → Procurement → Restock',
          children: [
            Text('Products Needing Restock', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            if (needsRestock.isEmpty) const Text('Nothing needs restocking right now.', style: TextStyle(color: AppColors.textMuted)),
            ...needsRestock.map((i) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    title: Text(i.productName),
                    subtitle: Text('Current: ${i.quantity} ${i.unit} · Minimum: ${i.minimumStock} ${i.unit}'),
                    trailing: ElevatedButton(onPressed: () => _restockDialog(context, i.productName), child: const Text('Restock')),
                  ),
                )),
            const SizedBox(height: 24),
            Row(children: [
              Text('Procurement History', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              OutlinedButton.icon(onPressed: () => _restockDialog(context, null), icon: const Icon(Icons.add), label: const Text('New Record')),
            ]),
            const SizedBox(height: 10),
            ResponsiveTable(
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Supplier')),
                DataColumn(label: Text('Qty')),
                DataColumn(label: Text('Cost')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Status')),
              ],
              rows: data.procurement.map((p) => DataRow(cells: [
                    DataCell(Text(p.productName)),
                    DataCell(Text(p.supplier)),
                    DataCell(Text('${p.quantity}')),
                    DataCell(Text(peso(p.cost))),
                    DataCell(Text('${p.date.month}/${p.date.day}/${p.date.year}')),
                    DataCell(StatusBadge(status: p.status)),
                  ])).toList(),
            ),
          ],
        );
      },
    );
  }

  void _restockDialog(BuildContext context, String? productName) {
    final nameCtrl = TextEditingController(text: productName ?? '');
    final supplierCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Procurement Record'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Product Name')),
          TextField(controller: supplierCtrl, decoration: const InputDecoration(labelText: 'Supplier')),
          TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
          TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'Total Cost (₱)'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              AppData.instance.addProcurement(
                nameCtrl.text.trim(),
                supplierCtrl.text.trim().isEmpty ? 'Local Supplier' : supplierCtrl.text.trim(),
                int.tryParse(qtyCtrl.text) ?? 0,
                double.tryParse(costCtrl.text) ?? 0,
              );
              Navigator.pop(ctx);
            },
            child: const Text('Save & Restock'),
          ),
        ],
      ),
    );
  }
}
