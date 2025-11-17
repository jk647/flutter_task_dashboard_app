import '../../../models/item_model.dart';

class DetailService {
  Item validateAndBuildItem({
    required Item currentItem,
    required String title,
    required String description,
    required String priceText,
    required String category,
  }) {
    final t = title.trim();
    final d = description.trim();
    final pText = priceText.trim();
    final c = category.trim();

    if (t.isEmpty) throw FormatException('Title is required');
    if (t.length < 3) throw FormatException('Title must be at least 3 characters');

    if (d.isEmpty) throw FormatException('Description is required');
    if (d.length < 10) throw FormatException('Description must be at least 10 characters');

    if (pText.isEmpty) throw FormatException('Price is required');
    final price = double.tryParse(pText);
    if (price == null) throw FormatException('Please enter a valid number for price');
    if (price <= 0) throw FormatException('Price must be greater than 0');

    if (c.isEmpty) throw FormatException('Category is required');

    // Return a new Item (use copyWith to preserve id)
    return currentItem.copyWith(
      title: t,
      description: d,
      price: price,
      category: c,
    );
  }
}