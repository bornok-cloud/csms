import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});
  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _search = '';
  String _roleFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        var users = AppData.instance.users
            .where(
                (u) => u.fullName.toLowerCase().contains(_search.toLowerCase()))
            .toList();
        if (_roleFilter != 'All') {
          users = users.where((u) => u.roleLabel == _roleFilter).toList();
        }

        return SectionPage(children: [
          Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _roleFilter,
              items: const ['All', 'Admin', 'Employee', 'Customer']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _roleFilter = v ?? 'All'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
                onPressed: () => _addUserDialog(context),
                icon: const Icon(Icons.person_add_alt),
                label: const Text('Add User')),
          ]),
          const SizedBox(height: 16),
          ResponsiveTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Registered')),
              DataColumn(label: Text('Actions')),
            ],
            rows: users
                .map((u) => DataRow(cells: [
                      DataCell(Text(u.fullName)),
                      DataCell(Text(u.email)),
                      DataCell(Text(u.roleLabel)),
                      DataCell(StatusBadge(status: u.status)),
                      DataCell(Text(
                          '${u.dateRegistered.month}/${u.dateRegistered.day}/${u.dateRegistered.year}')),
                      DataCell(Row(children: [
                        IconButton(
                          icon: const Icon(Icons.block,
                              size: 18, color: AppColors.warning),
                          tooltip: u.status == 'Active' ? 'Disable' : 'Enable',
                          onPressed: () => setState(() => u.status =
                              u.status == 'Active' ? 'Disabled' : 'Active'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.archive_outlined,
                              size: 18, color: AppColors.danger),
                          tooltip: 'Archive',
                          onPressed: () => _confirmArchive(context, u),
                        ),
                      ])),
                    ]))
                .toList(),
          ),
        ]);
      },
    );
  }

  void _confirmArchive(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archive User?'),
        content: const Text(
            'Instead of permanently deleting this user, the account will be moved to the Archive.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              AppData.instance.archiveUser(user.id);
              Navigator.pop(ctx);
              showAppSnack(context, 'User successfully moved to Archive.');
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _addUserDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    UserRole role = UserRole.employee;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add User'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name')),
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number')),
            DropdownButtonFormField<UserRole>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: UserRole.values
                  .map((r) => DropdownMenuItem(
                      value: r,
                      child:
                          Text(r.name[0].toUpperCase() + r.name.substring(1))))
                  .toList(),
              onChanged: (v) => setDialogState(() => role = v ?? role),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty ||
                    emailCtrl.text.trim().isEmpty) {
                  return;
                }
                AppData.instance.addUser(AppUser(
                  id: 'U-${DateTime.now().millisecondsSinceEpoch % 100000}',
                  fullName: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  role: role,
                  dateRegistered: DateTime.now(),
                  password: 'temp1234',
                ));
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
