import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../widgets/shared_widgets.dart';

/// Shared by Admin (full access + reply) and Employee (view-only, limited access).
class FeedbackScreen extends StatefulWidget {
  final bool canReply;
  const FeedbackScreen({super.key, this.canReply = false});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _search = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        var items = AppData.instance.feedbacks.where((f) => f.customerName.toLowerCase().contains(_search.toLowerCase())).toList();
        if (_filter != 'All') items = items.where((f) => f.status == _filter).toList();

        return SectionPage(children: [
          Row(children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(hintText: 'Search customer...', prefixIcon: Icon(Icons.search), isDense: true),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _filter,
              items: const ['All', 'New', 'Reviewed'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) => setState(() => _filter = v ?? 'All'),
            ),
          ]),
          const SizedBox(height: 16),
          ...items.map((f) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(child: Text(f.customerName, style: const TextStyle(fontWeight: FontWeight.bold))),
                        StarRating(rating: f.rating, size: 16),
                      ]),
                      const SizedBox(height: 6),
                      Text(f.comment, style: const TextStyle(color: AppColors.darkBrown)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Chip(label: Text(f.category, style: const TextStyle(fontSize: 11)), backgroundColor: AppColors.beige),
                        const SizedBox(width: 8),
                        StatusBadge(status: f.status),
                        const Spacer(),
                        Text('${f.date.month}/${f.date.day}/${f.date.year}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ]),
                      if (f.reply != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(10)),
                          child: Text('Café reply: ${f.reply}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                        ),
                      ],
                      if (widget.canReply && f.status == 'New') ...[
                        const SizedBox(height: 10),
                        Row(children: [
                          TextButton(onPressed: () => setState(() => AppData.instance.markFeedbackReviewed(f.id)), child: const Text('Mark as Reviewed')),
                          TextButton(onPressed: () => _replyDialog(context, f.id), child: const Text('Reply')),
                        ]),
                      ],
                    ],
                  ),
                ),
              )),
          if (items.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('No feedback found.', style: TextStyle(color: AppColors.textMuted))),
        ]);
      },
    );
  }

  void _replyDialog(BuildContext context, String id) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reply to Feedback'),
        content: TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Write your reply...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => AppData.instance.markFeedbackReviewed(id, reply: ctrl.text.trim()));
              Navigator.pop(ctx);
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }
}
