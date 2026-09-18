import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});
  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  String _category = 'Users';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final records = AppData.instance.archive.where((r) => r.category == _category).toList();
        return SectionPage(
          subtitle: 'Active User → Archive → Restore / Permanently Delete. Nothing is deleted immediately.',
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['Users', 'Employees', 'Products', 'Other Records']
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (records.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('No archived records in this category.', style: TextStyle(color: AppColors.textMuted))),
            ResponsiveTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Date Archived')),
                DataColumn(label: Text('Archived By')),
                DataColumn(label: Text('Actions')),
              ],
              rows: records.map((r) => DataRow(cells: [
                    DataCell(Text(r.name)),
                    DataCell(Text(r.email)),
                    DataCell(Text(r.role)),
                    DataCell(Text('${r.dateArchived.month}/${r.dateArchived.day}/${r.dateArchived.year}')),
                    DataCell(Text(r.archivedBy)),
                    DataCell(Row(children: [
                      TextButton(
                        onPressed: () {
                          AppData.instance.restoreUser(r.id);
                          showAppSnack(context, 'User successfully restored.');
                        },
                        child: const Text('Restore'),
                      ),
                      TextButton(
                        onPressed: () => _confirmPermanentDelete(context, r.id),
                        style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                        child: const Text('Permanently Delete'),
                      ),
                    ])),
                  ])).toList(),
            ),
          ],
        );
      },
    );
  }

  void _confirmPermanentDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permanently Delete?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              AppData.instance.permanentlyDelete(id);
              Navigator.pop(ctx);
            },
            child: const Text('Permanently Delete'),
          ),
        ],
      ),
    );
  }
}
