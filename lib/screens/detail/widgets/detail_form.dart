import 'package:flutter/material.dart';
import '../../../extensions/size_ext.dart';

class DetailForm extends StatelessWidget {
  final bool isEditing;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;

  const DetailForm({
    super.key,
    required this.isEditing,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.categoryController,
  });

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Title"),
        8.h,
        TextFormField(
          controller: titleController,
          enabled: isEditing,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: isEditing ? const OutlineInputBorder() : InputBorder.none,
            filled: !isEditing,
            fillColor: Colors.grey.shade100,
          ),
          validator: (v) => v!.trim().isEmpty ? "Title required" : null,
        ),
        24.h,

        _label("Description"),
        8.h,
        TextFormField(
          controller: descriptionController,
          enabled: isEditing,
          maxLines: 4,
          decoration: InputDecoration(
            border: isEditing ? const OutlineInputBorder() : InputBorder.none,
            filled: !isEditing,
            fillColor: Colors.grey.shade100,
          ),
          validator: (v) => v!.trim().isEmpty ? "Description required" : null,
        ),
        24.h,

        _label("Price"),
        8.h,
        TextFormField(
          controller: priceController,
          enabled: isEditing,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: "\$ ",
            border: isEditing ? const OutlineInputBorder() : InputBorder.none,
            filled: !isEditing,
            fillColor: Colors.grey.shade100,
          ),
          validator: (v) => v!.trim().isEmpty ? "Price required" : null,
        ),
        24.h,

        _label("Category"),
        8.h,
        TextFormField(
          controller: categoryController,
          enabled: isEditing,
          decoration: InputDecoration(
            border: isEditing ? const OutlineInputBorder() : InputBorder.none,
            filled: !isEditing,
            fillColor: Colors.grey.shade100,
          ),
          validator: (v) => v!.trim().isEmpty ? "Category required" : null,
        ),
      ],
    );
  }
}
