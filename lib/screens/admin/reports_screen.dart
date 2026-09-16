import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    return Column(
      children: [
        Material(
          color: AppColors.cream,
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: AppColors.brown,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.accent,
            tabs: const [
              Tab(text: 'Sales'),
              Tab(text: 'Inventory'),
              Tab(text: 'Payroll'),
              Tab(text: 'Expenses'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _SalesReport(data: data),
              _InventoryReport(data: data),
              _PayrollReport(data: data),
              _ExpenseReport(data: data),
            ],
          ),
        ),
      ],
    );
  }
}

class _SalesReport extends StatelessWidget {
  final AppData data;
  const _SalesReport({required this.data});
  @override
  Widget build(BuildContext context) {
    final daily = data.transactions.fold(0.0, (s, t) => s + t.total);
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) => SectionPage(children: [
        StatGrid(cards: [
          StatCard(label: 'Daily Sales', value: peso(daily), icon: Icons.today_outlined, color: AppColors.success),
          StatCard(label: 'Weekly Sales', value: peso(daily * 6.2), icon: Icons.calendar_view_week_outlined, color: AppColors.info),
          StatCard(label: 'Monthly Sales', value: peso(daily * 26), icon: Icons.calendar_month_outlined, color: AppColors.brown),
        ]),
        const SizedBox(height: 16),
        Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ResponsiveTable(
          columns: const [
            DataColumn(label: Text('Transaction')),
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Subtotal')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Cashier')),
          ],
          rows: data.transactions.reversed.map((t) => DataRow(cells: [
                DataCell(Text(t.id)),
                DataCell(Text('${t.items.length} item(s)')),
                DataCell(Text(peso(t.subtotal))),
                DataCell(Text(peso(t.discount))),
                DataCell(Text(peso(t.total))),
                DataCell(Text(t.cashier)),
              ])).toList(),
        ),
      ]),
    );
  }
}

class _InventoryReport extends StatelessWidget {
  final AppData data;
  const _InventoryReport({required this.data});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) {
        final low = data.inventory.where((i) => i.status == 'Low Stock').length;
        final out = data.inventory.where((i) => i.status == 'Out of Stock').length;
        final near = data.inventory.where((i) => i.status == 'Near Expiration').length;
        final current = data.inventory.length - low - out - near;
        return SectionPage(children: [
          StatGrid(cards: [
            StatCard(label: 'Current Stock Items', value: '$current', icon: Icons.inventory_2_outlined, color: AppColors.success),
            StatCard(label: 'Low Stock', value: '$low', icon: Icons.warning_amber_outlined, color: AppColors.warning),
            StatCard(label: 'Out of Stock', value: '$out', icon: Icons.remove_shopping_cart_outlined, color: AppColors.danger),
            StatCard(label: 'Near Expiration', value: '$near', icon: Icons.timer_outlined, color: const Color(0xFFE07A2F)),
          ]),
          const SizedBox(height: 16),
          ResponsiveTable(
            columns: const [
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Status')),
            ],
            rows: data.inventory.map((i) => DataRow(cells: [
                  DataCell(Text(i.productName)),
                  DataCell(Text('${i.quantity} ${i.unit}')),
                  DataCell(StatusBadge(status: i.status)),
                ])).toList(),
          ),
        ]);
      },
    );
  }
}

class _PayrollReport extends StatelessWidget {
  final AppData data;
  const _PayrollReport({required this.data});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) => SectionPage(children: [
        StatGrid(cards: [
          StatCard(label: 'Total Payroll', value: peso(data.totalPayrollExpense), icon: Icons.payments_outlined, color: AppColors.brown),
          StatCard(label: 'Employees', value: '${data.employees.length}', icon: Icons.badge_outlined, color: AppColors.info),
        ]),
        const SizedBox(height: 16),
        Text('Payroll History', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ResponsiveTable(
          columns: const [
            DataColumn(label: Text('Employee')),
            DataColumn(label: Text('Position')),
            DataColumn(label: Text('Net Salary')),
            DataColumn(label: Text('Status')),
          ],
          rows: data.employees.map((e) => DataRow(cells: [
                DataCell(Text(e.name)),
                DataCell(Text(e.position)),
                DataCell(Text(peso(e.netSalary))),
                DataCell(StatusBadge(status: e.status)),
              ])).toList(),
        ),
      ]),
    );
  }
}

class _ExpenseReport extends StatelessWidget {
  final AppData data;
  const _ExpenseReport({required this.data});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) => SectionPage(children: [
        StatGrid(cards: [
          StatCard(label: 'Petty Cash Balance', value: peso(data.pettyCashBalance), icon: Icons.account_balance_wallet_outlined, color: AppColors.success),
          StatCard(label: 'Total Expenses', value: peso(data.pettyCashExpenses), icon: Icons.trending_down, color: AppColors.danger),
        ]),
        const SizedBox(height: 16),
        Text('Expense History', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ResponsiveTable(
          columns: const [
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Amount')),
          ],
          rows: data.pettyCash.map((e) => DataRow(cells: [
                DataCell(Text(e.description)),
                DataCell(Text(e.category)),
                DataCell(Text(peso(e.amount), style: TextStyle(color: e.amount < 0 ? AppColors.danger : AppColors.success))),
              ])).toList(),
        ),
      ]),
    );
  }
}
