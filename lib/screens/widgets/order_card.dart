import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final timestamp = order['timestamp']?.toDate();
    final totalPrice = order['totalPrice'];
    final address = order['address'];
    final items = List<Map<String, dynamic>>.from(order['items'] ?? []);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Address: $address',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            if (timestamp != null)
              Text(
                'Date: ${DateFormat.yMMMMd().add_jm().format(timestamp)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const Divider(height: 16),
            ...items.map((item) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(item['title'] ?? 'Product'),
                trailing: Text('x${item['quantity'] ?? 1}'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
