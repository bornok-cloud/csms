import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.instance.currentUser!;
    return SectionPage(children: [
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  CircleAvatar(radius: 44, backgroundColor: AppColors.brown, child: Text(user.fullName[0], style: const TextStyle(fontSize: 32, color: Colors.white))),
                  const SizedBox(height: 6),
                  TextButton.icon(onPressed: () => showAppSnack(context, 'Profile picture updated (mock).'), icon: const Icon(Icons.camera_alt_outlined, size: 16), label: const Text('Change Profile Picture')),
                  const SizedBox(height: 8),
                  Text(user.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
                  Text(user.roleLabel, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
                  const Divider(height: 32),
                  _row(Icons.email_outlined, 'Email', user.email),
                  _row(Icons.phone_outlined, 'Phone', user.phone),
                  _row(Icons.badge_outlined, 'Role', user.roleLabel),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => showAppSnack(context, 'Profile updated (mock).'), child: const Text('Edit Profile'))),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(onPressed: () => showAppSnack(context, 'Password changed (mock).'), child: const Text('Change Password'))),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.brown),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
