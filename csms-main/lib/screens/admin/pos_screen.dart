import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../../models/models.dart';

/// Full POS used by both Admin and Employee. Demonstrates the POS -> Inventory
/// connection: checkout deducts stock and can trigger low-stock alerts.
class PosScreen extends StatefulWidget {
  final String cashier;
  const PosScreen({super.key, required this.cashier});
  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String _category = 'All';
  String _search = '';
  final List<CartItem> _cart = [];
  double _discount = 0;

  void _addToCart(Product p) {
    setState(() {
      final existing = _cart.where((c) => c.product.id == p.id);
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        _cart.add(CartItem(product: p));
      }
    });
  }

  double get _subtotal => _cart.fold(0, (s, c) => s + c.subtotal);
  double get _total => (_subtotal - _discount).clamp(0, double.infinity);

  void _pay() {
    if (_cart.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Payment'),
        content:
            Text('Charge ${peso(_total)} for ${_cart.length} item type(s)?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final before = {
                for (var c in _cart)
                  c.product.name: AppData.instance.inventory
                      .firstWhere((i) => i.productName == c.product.name,
                          orElse: () => InventoryItem(
                              id: '',
                              productName: c.product.name,
                              quantity: 0,
                              unit: '',
                              minimumStock: 0))
                      .quantity
              };
              AppData.instance.checkout(
                  items: List.of(_cart),
                  discount: _discount,
                  cashier: widget.cashier);
              Navigator.pop(ctx);
              _showReceipt(before);
              setState(() {
                _cart.clear();
                _discount = 0;
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showReceipt(Map<String, int> before) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✅ Transaction Completed'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inventory updated automatically:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...before.entries.map((e) {
                final after = AppData.instance.inventory
                    .firstWhere((i) => i.productName == e.key,
                        orElse: () => InventoryItem(
                            id: '',
                            productName: e.key,
                            quantity: e.value,
                            unit: '',
                            minimumStock: 0))
                    .quantity;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text('${e.key}:  ${e.value} → $after'),
                );
              }),
            ],
          ),
        ),
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
    var filtered = products
        .where((p) => p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    if (_category != 'All') {
      filtered = filtered.where((p) => p.category == _category).toList();
    }

    final productPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                isDense: true),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 120,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
            itemBuilder: (ctx, i) {
              final p = filtered[i];
              return InkWell(
                onTap: () => _addToCart(p),
                borderRadius: BorderRadius.circular(14),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.emoji, style: const TextStyle(fontSize: 22)),
                        const Spacer(),
                        Text(p.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(peso(p.price),
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
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
          const Text('Cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          Expanded(
            child: _cart.isEmpty
                ? const Center(
                    child: Text('Tap a product to add it to the cart.',
                        style: TextStyle(color: AppColors.textMuted)))
                : ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (ctx, i) {
                      final c = _cart[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(c.product.name,
                            style: const TextStyle(fontSize: 13)),
                        subtitle: Text(peso(c.product.price),
                            style: const TextStyle(fontSize: 12)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 18, color: AppColors.danger),
                                onPressed: () =>
                                    setState(() => _cart.removeAt(i))),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          Row(children: [
            const Text('Discount: '),
            Expanded(
              child: Slider(
                value: _discount,
                min: 0,
                max: _subtotal == 0 ? 1 : _subtotal,
                onChanged: (v) => setState(() => _discount = v),
              ),
            ),
            Text(peso(_discount)),
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Subtotal'), Text(peso(_subtotal))]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Discount'), Text('-${peso(_discount)}')]),
          const SizedBox(height: 4),
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
              onPressed: _cart.isEmpty ? null : _pay,
              child: const SizedBox(
                  width: double.infinity,
                  child: Text('PAY', textAlign: TextAlign.center))),
        ],
      ),
    );

    final wide = MediaQuery.of(context).size.width >= 800;
    if (wide) {
      return Row(children: [
        Expanded(flex: 2, child: productPanel),
        SizedBox(width: 340, child: cartPanel)
      ]);
    }
    return Column(children: [
      Expanded(child: productPanel),
      SizedBox(height: 320, child: cartPanel)
    ]);
  }
}
