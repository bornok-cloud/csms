import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../models/models.dart';

/// Shared messaging UI for Admin <-> Employee conversations.
/// currentRole determines how the sender is labeled ('Admin' or the employee's name).
class MessagingScreen extends StatefulWidget {
  final String currentRole; // 'Admin' or employee name
  const MessagingScreen({super.key, required this.currentRole});
  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  int _selected = 0;
  final _msgCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  List<Conversation> get _conversations {
    final data = AppData.instance;
    if (widget.currentRole == 'Admin') return data.adminEmployeeChats;
    // Employee view: only their own conversation with Admin
    return data.adminEmployeeChats.where((c) => c.withName == widget.currentRole).toList();
  }

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    final convos = _conversations;
    if (convos.isEmpty) return;
    final convo = convos[_selected];
    setState(() {
      convo.messages.add(ChatMessage(
        sender: widget.currentRole == 'Admin' ? 'Admin' : widget.currentRole,
        text: _msgCtrl.text.trim(),
        timestamp: DateTime.now(),
        read: true,
      ));
      _msgCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final convos = _conversations;
    final wide = MediaQuery.of(context).size.width >= 800;
    if (convos.isEmpty) {
      return const Center(child: Text('No conversations yet.', style: TextStyle(color: AppColors.textMuted)));
    }
    final selected = _selected.clamp(0, convos.length - 1);
    final convo = convos[selected];

    final list = Container(
      width: wide ? 280 : double.infinity,
      color: AppColors.cardWhite,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(hintText: 'Search employees...', prefixIcon: Icon(Icons.search), isDense: true),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: convos.length,
              itemBuilder: (ctx, i) {
                final c = convos[i];
                if (_searchCtrl.text.isNotEmpty && !c.withName.toLowerCase().contains(_searchCtrl.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                final unread = c.messages.any((m) => !m.read && m.sender != widget.currentRole);
                final last = c.messages.isNotEmpty ? c.messages.last : null;
                return ListTile(
                  selected: i == selected,
                  selectedTileColor: AppColors.beige,
                  leading: CircleAvatar(backgroundColor: AppColors.brown, child: Text(c.withName[0], style: const TextStyle(color: Colors.white))),
                  title: Text(c.withName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: last != null ? Text(last.text, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
                  trailing: unread ? const CircleAvatar(radius: 5, backgroundColor: AppColors.accent) : null,
                  onTap: () => setState(() => _selected = i),
                );
              },
            ),
          ),
        ],
      ),
    );

    final chat = Column(
      children: [
        Container(
          color: AppColors.beige,
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            CircleAvatar(backgroundColor: AppColors.brown, child: Text(convo.withName[0], style: const TextStyle(color: Colors.white))),
            const SizedBox(width: 10),
            Text(convo.withName, style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: convo.messages.length,
            itemBuilder: (ctx, i) {
              final m = convo.messages[i];
              final mine = m.sender == widget.currentRole;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 320),
                  decoration: BoxDecoration(
                    color: mine ? AppColors.brown : AppColors.beige,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.text, style: TextStyle(color: mine ? Colors.white : AppColors.darkBrown)),
                      const SizedBox(height: 4),
                      Text('${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')}${mine ? (m.read ? "  ✓✓" : "  ✓") : ""}',
                          style: TextStyle(fontSize: 10, color: mine ? Colors.white70 : AppColors.textMuted)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: AppColors.cardWhite,
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration: const InputDecoration(hintText: 'Type a message...', isDense: true),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: _send, icon: const Icon(Icons.send)),
          ]),
        ),
      ],
    );

    if (wide) {
      return Row(children: [list, const VerticalDivider(width: 1), Expanded(child: chat)]);
    }
    return convos.length == 1 ? chat : Column(children: [SizedBox(height: 160, child: list), const Divider(height: 1), Expanded(child: chat)]);
  }
}
