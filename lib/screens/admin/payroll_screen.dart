import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});
  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        return SectionPage(
          subtitle: 'Payroll is calculated from recorded attendance & working hours.',
          children: [
            StatGrid(cards: [
              StatCard(label: 'Total Payroll', value: peso(data.totalPayrollExpense), icon: Icons.payments_outlined, color: AppColors.brown),
              StatCard(label: 'Employees', value: '${data.employees.length}', icon: Icons.groups_outlined, color: AppColors.info),
              StatCard(
                  label: 'Pending Payouts',
                  value: '${data.employees.where((e) => e.status == 'Pending').length}',
                  icon: Icons.hourglass_bottom,
                  color: AppColors.warning),
            ]),
            const SizedBox(height: 16),
            ResponsiveTable(
              columns: const [
                DataColumn(label: Text('Employee')),
                DataColumn(label: Text('Position')),
                DataColumn(label: Text('Hours')),
                DataColumn(label: Text('Basic Salary')),
                DataColumn(label: Text('Overtime')),
                DataColumn(label: Text('Bonus')),
                DataColumn(label: Text('Deductions')),
                DataColumn(label: Text('Net Salary')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Action')),
              ],
              rows: data.employees.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e.name)),
                  DataCell(Text(e.position)),
                  DataCell(Text('${e.hoursWorked.toStringAsFixed(0)}h')),
                  DataCell(Text(peso(e.basicSalary))),
                  DataCell(Text(peso(e.overtimePay))),
                  DataCell(_EditableAmount(
                    value: e.bonus,
                    color: AppColors.success,
                    onChanged: (v) => setState(() => e.bonus = v),
                  )),
                  DataCell(_EditableAmount(
                    value: e.deductions,
                    color: AppColors.danger,
                    onChanged: (v) => setState(() => e.deductions = v),
                  )),
                  DataCell(Text(peso(e.netSalary), style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(StatusBadge(status: e.status)),
                  DataCell(
                    e.status == 'Paid'
                        ? const Text('—', style: TextStyle(color: AppColors.textMuted))
                        : TextButton(
                            onPressed: () {
                              AppData.instance.markPayrollPaid(e.id);
                              showAppSnack(context, '${e.name} marked as paid.');
                            },
                            child: const Text('Mark Paid'),
                          ),
                  ),
                ]);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _EditableAmount extends StatelessWidget {
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;
  const _EditableAmount({required this.value, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ctrl = TextEditingController(text: value.toStringAsFixed(0));
        final result = await showDialog<double>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Edit Amount'),
            content: TextField(controller: ctrl, keyboardType: TextInputType.number, autofocus: true),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text) ?? value), child: const Text('Save')),
            ],
          ),
        );
        if (result != null) onChanged(result);
      },
      child: Text(peso(value), style: TextStyle(color: color)),
    );
  }
}
