import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

/// Employees can ONLY view their own payroll — no editing.
class EmployeePayrollScreen extends StatelessWidget {
  const EmployeePayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        final me = data.employees.firstWhere(
          (e) => e.name == data.currentUser!.fullName,
          orElse: () => data.employees.first,
        );
        return SectionPage(
          subtitle: 'Admin Payroll → Employee Payroll → You view your own record (read-only).',
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Text(me.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                          const Spacer(),
                          StatusBadge(status: me.status),
                        ]),
                        Text(me.position, style: const TextStyle(color: AppColors.textMuted)),
                        const Divider(height: 24),
                        _row('Pay Period', 'Current Cycle'),
                        _row('Hours Worked', '${me.hoursWorked.toStringAsFixed(0)}h'),
                        _row('Basic Salary', peso(me.basicSalary)),
                        _row('Overtime', peso(me.overtimePay)),
                        _row('Bonus', peso(me.bonus)),
                        _row('Deductions', '-${peso(me.deductions)}'),
                        const Divider(height: 24),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Net Salary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(peso(me.netSalary), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.accent)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
