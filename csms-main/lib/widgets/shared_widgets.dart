import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_data.dart';

/// A single navigation destination in a sidebar/drawer/bottom-nav.
class NavItem {
  final IconData icon;
  final String label;
  final Widget Function() builder;
  NavItem({required this.icon, required this.label, required this.builder});
}

/// Responsive shell: NavigationRail/sidebar on wide screens, Drawer + AppBar
/// with bottom NavigationBar-style menu on narrow screens. Used by Admin,
/// Employee, and Customer sides alike.
class AppShell extends StatefulWidget {
  final String title;
  final List<NavItem> items;
  final VoidCallback onLogout;
  final Widget? trailing; // e.g. notification bell
  const AppShell(
      {super.key,
      required this.title,
      required this.items,
      required this.onLogout,
      this.trailing});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final current = widget.items[_selected].builder();

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 260,
              color: AppColors.darkBrown,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(Icons.local_cafe,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(widget.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 1),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: widget.items.length,
                        itemBuilder: (ctx, i) {
                          final selected = i == _selected;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            tileColor: selected
                                ? Colors.white.withValues(alpha: 0.08)
                                : null,
                            leading: Icon(widget.items[i].icon,
                                color: selected
                                    ? AppColors.accent
                                    : Colors.white70),
                            title: Text(widget.items[i].label,
                                style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            selected: selected,
                            onTap: () => setState(() => _selected = i),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.white70),
                      title: const Text('Logout',
                          style: TextStyle(color: Colors.white70)),
                      onTap: widget.onLogout,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.lightBrown
                                    .withValues(alpha: 0.25)))),
                    child: Row(
                      children: [
                        Text(widget.items[_selected].label,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontSize: 22)),
                        const Spacer(),
                        if (widget.trailing != null) widget.trailing!,
                      ],
                    ),
                  ),
                  Expanded(child: current),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.items[_selected].label),
        actions: [
          if (widget.trailing != null) widget.trailing!,
          const SizedBox(width: 8)
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.darkBrown,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  const Icon(Icons.local_cafe, color: Colors.white, size: 26),
                  const SizedBox(width: 10),
                  Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                ]),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (ctx, i) => ListTile(
                    leading: Icon(widget.items[i].icon,
                        color:
                            i == _selected ? AppColors.accent : Colors.white70),
                    title: Text(widget.items[i].label,
                        style: TextStyle(
                            color: i == _selected
                                ? Colors.white
                                : Colors.white70)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    onTap: () {
                      setState(() => _selected = i);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white70),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.white70)),
                onTap: widget.onLogout,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: current,
      bottomNavigationBar: widget.items.length <= 5
          ? NavigationBar(
              selectedIndex: _selected,
              onDestinationSelected: (i) => setState(() => _selected = i),
              destinations: widget.items
                  .map((i) =>
                      NavigationDestination(icon: Icon(i.icon), label: i.label))
                  .toList(),
            )
          : null,
    );
  }
}

/// Small KPI card used across dashboards.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      this.color = AppColors.brown});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBrown)),
                  const SizedBox(height: 2),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Responsive grid of StatCards.
class StatGrid extends StatelessWidget {
  final List<StatCard> cards;
  const StatGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols =
        width >= 1100 ? 4 : (width >= 700 ? 3 : (width >= 480 ? 2 : 1));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisExtent: 100,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (ctx, i) => cards[i],
    );
  }
}

/// Colored status pill, e.g. "Low Stock", "Paid", "Active".
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color _color() {
    switch (status) {
      case 'In Stock':
      case 'Active':
      case 'Paid':
      case 'Present':
      case 'Reviewed':
      case 'Restocked':
      case 'Completed':
        return AppColors.success;
      case 'Low Stock':
      case 'Pending':
      case 'Pending Verification':
      case 'Requested':
      case 'Late':
      case 'New':
        return AppColors.warning;
      case 'Near Expiration':
        return const Color(0xFFE07A2F);
      case 'Out of Stock':
      case 'Expired':
      case 'Disabled':
      case 'Absent':
        return AppColors.danger;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: c.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style:
              TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

/// A page scaffold with padding + scrolling used inside AppShell tabs.
class SectionPage extends StatelessWidget {
  final String? subtitle;
  final List<Widget> children;
  final Widget? action;
  const SectionPage(
      {super.key, this.subtitle, required this.children, this.action});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (subtitle != null || action != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  if (subtitle != null)
                    Expanded(
                        child: Text(subtitle!,
                            style:
                                const TextStyle(color: AppColors.textMuted))),
                  if (action != null) action!,
                ],
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

/// Wraps a DataTable in horizontal scroll so it behaves on small screens.
/// Paginates its rows automatically — pass the FULL row list and this
/// widget slices it into pages with Prev/Next controls at the bottom.
class ResponsiveTable extends StatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int rowsPerPage;
  const ResponsiveTable({super.key, required this.columns, required this.rows, this.rowsPerPage = 10});

  @override
  State<ResponsiveTable> createState() => _ResponsiveTableState();
}

class _ResponsiveTableState extends State<ResponsiveTable> {
  int _page = 0;

  int get _maxPage => widget.rows.isEmpty ? 0 : (widget.rows.length - 1) ~/ widget.rowsPerPage;

  @override
  void didUpdateWidget(covariant ResponsiveTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If filtering/searching shrank the list (or data changed) enough that
    // the current page no longer exists, snap back to the last valid page.
    if (_page > _maxPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _page = _maxPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.rows.length;
    final start = (_page * widget.rowsPerPage).clamp(0, total).toInt();
    final end = (start + widget.rowsPerPage).clamp(0, total).toInt();
    final pageRows = widget.rows.sublist(start, end);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: widget.columns,
              rows: pageRows,
              headingRowColor: WidgetStateProperty.all(AppColors.beige),
              dataRowMinHeight: 52,
              dataRowMaxHeight: 64,
            ),
          ),
          if (total > widget.rowsPerPage) _pageBar(total, start, end),
        ],
      ),
    );
  }

  Widget _pageBar(int total, int start, int end) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.beige))),
      child: Row(
        children: [
          Text('Showing ${total == 0 ? 0 : start + 1}–$end of $total', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const Spacer(),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_left),
            onPressed: _page > 0 ? () => setState(() => _page--) : null,
          ),
          Text('Page ${_page + 1} of ${_maxPage + 1}', style: const TextStyle(fontSize: 12)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_right),
            onPressed: _page < _maxPage ? () => setState(() => _page++) : null,
          ),
        ],
      ),
    );
  }
}

/// Paginates any list of items rendered as widgets (e.g. Cards), showing
/// [pageSize] at a time with the same Prev/Next page bar as [ResponsiveTable].
/// Use this for screens that build a Column of Cards via `.map()` instead of
/// a DataTable.
class PaginatedList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final int pageSize;
  const PaginatedList({super.key, required this.items, required this.itemBuilder, this.pageSize = 6});

  @override
  State<PaginatedList<T>> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  int _page = 0;

  int get _maxPage => widget.items.isEmpty ? 0 : (widget.items.length - 1) ~/ widget.pageSize;

  @override
  void didUpdateWidget(covariant PaginatedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_page > _maxPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _page = _maxPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final total = widget.items.length;
    final start = (_page * widget.pageSize).clamp(0, total).toInt();
    final end = (start + widget.pageSize).clamp(0, total).toInt();
    final pageItems = widget.items.sublist(start, end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in pageItems) widget.itemBuilder(context, item),
        if (widget.items.length > widget.pageSize)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text('Showing ${start + 1}–$end of ${widget.items.length}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _page > 0 ? () => setState(() => _page--) : null,
                ),
                Text('Page ${_page + 1} of ${_maxPage + 1}', style: const TextStyle(fontSize: 12)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _page < _maxPage ? () => setState(() => _page++) : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Notification bell with unread badge + dropdown panel, shared by Admin/Employee shells.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'Inventory':
        return Icons.inventory_2_outlined;
      case 'Expiration':
        return Icons.timer_outlined;
      case 'POS':
        return Icons.point_of_sale_outlined;
      case 'Feedback':
        return Icons.star_outline;
      case 'Payroll':
        return Icons.payments_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final data = AppData.instance;
        return PopupMenuButton<void>(
          tooltip: 'Notifications',
          offset: const Offset(0, 44),
          onOpened: () => data.markAllNotificationsRead(),
          itemBuilder: (ctx) {
            if (data.notifications.isEmpty) {
              return [
                const PopupMenuItem(
                    enabled: false, child: Text('No notifications'))
              ];
            }
            return data.notifications.take(8).map((n) {
              return PopupMenuItem(
                enabled: false,
                child: SizedBox(
                  width: 280,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(_iconFor(n.type), size: 18, color: AppColors.brown),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(n.body,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.darkBrown),
                if (data.unreadNotifications > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: AppColors.danger, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text('${data.unreadNotifications}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Star rating display (read-only) or input (editable).
class StarRating extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;
  const StarRating(
      {super.key, required this.rating, this.size = 20, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        final star = Icon(filled ? Icons.star : Icons.star_border,
            color: AppColors.accent, size: size);
        if (onChanged == null) return star;
        return InkWell(onTap: () => onChanged!(i + 1), child: star);
      }),
    );
  }
}

Widget confirmDialogButton(BuildContext context,
    {required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm}) {
  return TextButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onConfirm();
              },
              style: TextButton.styleFrom(foregroundColor: confirmColor),
              child: Text(confirmLabel),
            ),
          ],
        ),
      );
    },
    child: Text(confirmLabel, style: TextStyle(color: confirmColor)),
  );
}

void showAppSnack(BuildContext context, String message, {bool success = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success ? AppColors.success : AppColors.danger,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
