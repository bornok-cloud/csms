import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

class InventoryScreen extends StatefulWidget {
  final bool readOnly; // Employees have fewer permissions than Admin
  const InventoryScreen({super.key, this.readOnly = false});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _search = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        var items = data.inventory
            .where((i) =>
                i.productName.toLowerCase().contains(_search.toLowerCase()))
            .toList();
        if (_filter != 'All') {
          items = items.where((i) => i.status == _filter).toList();
        }
        final lowStockAlerts = data.inventory
            .where((i) => i.status == 'Low Stock' || i.status == 'Out of Stock')
            .toList();
        final nearExpiry =
            data.inventory.where((i) => i.status == 'Near Expiration').toList();

        return SectionPage(children: [
          if (lowStockAlerts.isNotEmpty)
            Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'LOW STOCK ALERT — ${lowStockAlerts.map((i) => i.productName).join(", ")} at or below minimum stock.',
                      style: const TextStyle(color: AppColors.darkBrown),
                    ),
                  ),
                ]),
              ),
            ),
          if (nearExpiry.isNotEmpty && !widget.readOnly) ...[
            const SizedBox(height: 10),
            Card(
              color: const Color(0xFFE07A2F).withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  const Icon(Icons.timer_outlined, color: Color(0xFFE07A2F)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                        'NEAR EXPIRATION — ${nearExpiry.map((i) => i.productName).join(", ")}. Consider creating a promotion.',
                        style: const TextStyle(color: AppColors.darkBrown)),
                  ),
                  TextButton(
                      onPressed: () =>
                          _promoDialog(context, nearExpiry.first.productName),
                      child: const Text('Create Promo')),
                ]),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Search product...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _filter,
              items: const [
                'All',
                'In Stock',
                'Low Stock',
                'Out of Stock',
                'Near Expiration',
                'Expired'
              ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => setState(() => _filter = v ?? 'All'),
            ),
            if (!widget.readOnly) const SizedBox(width: 12),
            if (!widget.readOnly)
              ElevatedButton.icon(
                  onPressed: () => _showAddItemDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item')),
          ]),
          const SizedBox(height: 16),
          ResponsiveTable(
            columns: [
              const DataColumn(label: Text('Product')),
              const DataColumn(label: Text('Quantity')),
              const DataColumn(label: Text('Unit')),
              const DataColumn(label: Text('Min. Stock')),
              const DataColumn(label: Text('Expiration')),
              const DataColumn(label: Text('Status')),
              if (!widget.readOnly) const DataColumn(label: Text('Actions')),
            ],
            rows: items.map((i) {
              return DataRow(cells: [
                DataCell(Text(i.productName)),
                DataCell(Text('${i.quantity}')),
                DataCell(Text(i.unit)),
                DataCell(Text('${i.minimumStock}')),
                DataCell(Text(i.expiration != null
                    ? '${i.expiration!.month}/${i.expiration!.day}/${i.expiration!.year}'
                    : '—')),
                DataCell(StatusBadge(status: i.status)),
                if (!widget.readOnly)
                  DataCell(Row(children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 18),
                      tooltip: 'Adjust stock',
                      onPressed: () => setState(() =>
                          i.quantity = (i.quantity - 1).clamp(0, 1 << 30)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      tooltip: 'Restock +1',
                      onPressed: () => setState(() => i.quantity += 1),
                    ),
                  ])),
              ]);
            }).toList(),
          ),
        ]);
      },
    );
  }

  void _promoDialog(BuildContext context, String productName) {
    String promoType = 'Buy 1 Take 1';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Create Promotion — $productName'),
          content: DropdownButtonFormField<String>(
            initialValue: promoType,
            items: const [
              'Buy 1 Take 1',
              '10% Discount',
              '20% Discount',
              '30% Discount'
            ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setDialogState(() => promoType = v ?? promoType),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                AppData.instance.addPromotion(productName, promoType);
                Navigator.pop(ctx);
                showAppSnack(context, 'Promotion created for $productName.');
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'pcs');
    final minCtrl = TextEditingController(text: '5');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Inventory Item'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Product Name')),
          TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number),
          TextField(
              controller: unitCtrl,
              decoration: const InputDecoration(labelText: 'Unit')),
          TextField(
              controller: minCtrl,
              decoration: const InputDecoration(labelText: 'Minimum Stock'),
              keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              setState(() {
                AppData.instance.inventory.add(InventoryItem(
                  id: 'I-${AppData.instance.inventory.length + 1}',
                  productName: nameCtrl.text.trim(),
                  quantity: int.tryParse(qtyCtrl.text) ?? 0,
                  unit: unitCtrl.text.trim(),
                  minimumStock: int.tryParse(minCtrl.text) ?? 5,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
