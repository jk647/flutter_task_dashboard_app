import 'package:flutter/foundation.dart';

@immutable
class Item {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'category': category,
      };

  Item copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }

  @override
  String toString() => 'Item(id:$id, title:$title)';
}
