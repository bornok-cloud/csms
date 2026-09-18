import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class PettyCashScreen extends StatefulWidget {
  const PettyCashScreen({super.key});
  @override
  State<PettyCashScreen> createState() => _PettyCashScreenState();
}

class _PettyCashScreenState extends State<PettyCashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        return SectionPage(children: [
          StatGrid(cards: [
            StatCard(
                label: 'Starting Balance',
                value: peso(data.pettyCashStart),
                icon: Icons.account_balance_outlined,
                color: AppColors.info),
            StatCard(
                label: 'Cash Added',
                value: peso(data.pettyCashAdded),
                icon: Icons.add_circle_outline,
                color: AppColors.success),
            StatCard(
                label: 'Total Expenses',
                value: peso(data.pettyCashExpenses),
                icon: Icons.trending_down,
                color: AppColors.danger),
            StatCard(
                label: 'Remaining Balance',
                value: peso(data.pettyCashBalance),
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.brown),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Text('Transaction History',
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            OutlinedButton.icon(
                onPressed: () => _entryDialog(context, isExpense: true),
                icon: const Icon(Icons.remove),
                label: const Text('Record Expense')),
            const SizedBox(width: 8),
            ElevatedButton.icon(
                onPressed: () => _entryDialog(context, isExpense: false),
                icon: const Icon(Icons.add),
                label: const Text('Add Cash')),
          ]),
          const SizedBox(height: 10),
          ResponsiveTable(
            columns: const [
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Amount')),
            ],
            rows: data.pettyCash
                .map((e) => DataRow(cells: [
                      DataCell(Text(e.description)),
                      DataCell(Text(e.category)),
                      DataCell(
                          Text('${e.date.month}/${e.date.day}/${e.date.year}')),
                      DataCell(Text(
                        '${e.amount < 0 ? '-' : '+'}${peso(e.amount.abs())}',
                        style: TextStyle(
                            color: e.amount < 0
                                ? AppColors.danger
                                : AppColors.success,
                            fontWeight: FontWeight.bold),
                      )),
                    ]))
                .toList(),
          ),
        ]);
      },
    );
  }

  void _entryDialog(BuildContext context, {required bool isExpense}) {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = isExpense ? 'Supplies' : 'Owner Top-up';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isExpense ? 'Record Expense' : 'Add Cash'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description')),
          if (isExpense)
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                'Supplies',
                'Maintenance',
                'Utilities',
                'Miscellaneous'
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => category = v ?? category,
            ),
          TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount (₱)'),
              keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 0;
              AppData.instance.addPettyCash(
                  descCtrl.text.trim().isEmpty
                      ? (isExpense ? 'Expense' : 'Cash Added')
                      : descCtrl.text.trim(),
                  category,
                  isExpense ? -amt : amt);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
