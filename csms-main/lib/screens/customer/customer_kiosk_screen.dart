import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../models/models.dart';

class CustomerKioskScreen extends StatefulWidget {
  const CustomerKioskScreen({super.key});
  @override
  State<CustomerKioskScreen> createState() => _CustomerKioskScreenState();
}

class _CustomerKioskScreenState extends State<CustomerKioskScreen> {
  String _category = 'All';
  final List<CartItem> _cart = [];

  void _add(Product p) {
    setState(() {
      final existing = _cart.where((c) => c.product.id == p.id);
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        _cart.add(CartItem(product: p));
      }
    });
  }

  double get _total => _cart.fold(0, (s, c) => s + c.subtotal);

  void _placeOrder() {
    if (_cart.isEmpty) return;
    final order = AppData.instance.placeKioskOrder(List.of(_cart),
        customerName: AppData.instance.currentUser?.fullName);
    setState(() => _cart.clear());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ Order Received'),
        content: Text(
            'Order #${order.id}\n\nYour order has been sent to the café. You can track it in "My Orders".'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = AppData.instance.products;
    final categories = [
      'All',
      ...{for (var p in products) p.category}
    ];
    var filtered = _category == 'All'
        ? products
        : products.where((p) => p.category == _category).toList();

    final menu = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            children: categories
                .map((c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                          label: Text(c),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c)),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 190,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemBuilder: (ctx, i) {
              final p = filtered[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.beige,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child:
                            Text(p.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 8),
                      Text(p.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(p.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                      const Spacer(),
                      Row(children: [
                        Expanded(
                            child: Text(peso(p.price),
                                style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold))),
                        IconButton.filled(
                            onPressed: () => _add(p),
                            icon: const Icon(Icons.add, size: 16),
                            constraints: const BoxConstraints(
                                minWidth: 32, minHeight: 32)),
                      ]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    final cartPanel = Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Your Order',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          Expanded(
            child: _cart.isEmpty
                ? const Center(
                    child: Text('Your cart is empty. Add something delicious!',
                        style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (ctx, i) {
                      final c = _cart[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(c.product.name,
                            style: const TextStyle(fontSize: 13)),
                        subtitle: Text(peso(c.subtotal),
                            style: const TextStyle(fontSize: 12)),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  size: 18),
                              onPressed: () => setState(() {
                                    c.quantity--;
                                    if (c.quantity <= 0) _cart.removeAt(i);
                                  })),
                          Text('${c.quantity}'),
                          IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  size: 18),
                              onPressed: () => setState(() => c.quantity++)),
                        ]),
                      );
                    },
                  ),
          ),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(peso(_total),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.accent)),
          ]),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: _cart.isEmpty ? null : _placeOrder,
              child: const SizedBox(
                  width: double.infinity,
                  child: Text('Place Order', textAlign: TextAlign.center))),
        ],
      ),
    );

    final wide = MediaQuery.of(context).size.width >= 800;
    if (wide) {
      return Row(children: [
        Expanded(flex: 2, child: menu),
        SizedBox(width: 340, child: cartPanel)
      ]);
    }
    return Column(children: [
      Expanded(child: menu),
      SizedBox(height: 300, child: cartPanel)
    ]);
  }
}
