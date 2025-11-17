// lib/widgets/list_card.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../extensions/size_ext.dart';

class ListCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ListCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Text(item.category, style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ]),
                8.h,
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                4.h,
                Text(item.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
            16.w,
            Column(children: [
              Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
              8.h,
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ]),
          ]),
        ),
      ),
    );
  }
}
