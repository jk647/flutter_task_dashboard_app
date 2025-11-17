import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/item_model.dart';

class DetailScreen extends StatefulWidget {
  final int itemId;

  const DetailScreen({super.key, required this.itemId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _initializeControllers(Item item) {
    _titleController.text = item.title;
    _descriptionController.text = item.description;
    _priceController.text = item.price.toString();
    _categoryController.text = item.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Cancel editing - reload original data
                  final provider = context.read<DataProvider>();
                  final item = provider.getItemById(widget.itemId);
                  if (item != null) {
                    _initializeControllers(item);
                  }
                }
                _isEditing = !_isEditing;
              });
            },
            tooltip: _isEditing ? 'Cancel' : 'Edit',
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          final item = provider.getItemById(widget.itemId);

          if (item == null) {
            return const Center(
              child: Text('Item not found'),
            );
          }

          // Initialize controllers with current item data
          if (_titleController.text.isEmpty) {
            _initializeControllers(item);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title Field
                    _buildFieldLabel('Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      enabled: _isEditing,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                        border: _isEditing
                            ? const OutlineInputBorder()
                            : InputBorder.none,
                        filled: !_isEditing,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Description Field
                    _buildFieldLabel('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      enabled: _isEditing,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter description',
                        border: _isEditing
                            ? const OutlineInputBorder()
                            : InputBorder.none,
                        filled: !_isEditing,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Price Field
                    _buildFieldLabel('Price'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      enabled: _isEditing,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        hintText: 'Enter price',
                        border: _isEditing
                            ? const OutlineInputBorder()
                            : InputBorder.none,
                        filled: !_isEditing,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Price is required';
                        }
                        final price = double.tryParse(value);
                        if (price == null) {
                          return 'Please enter a valid number';
                        }
                        if (price <= 0) {
                          return 'Price must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Category Field
                    _buildFieldLabel('Category'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _categoryController,
                      enabled: _isEditing,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter category',
                        border: _isEditing
                            ? const OutlineInputBorder()
                            : InputBorder.none,
                        filled: !_isEditing,
                        fillColor: Colors.grey.shade100,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save Button (only visible when editing)
                    if (_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _saveChanges(provider, item),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  void _saveChanges(DataProvider provider, Item currentItem) {
    if (_formKey.currentState!.validate()) {
      final updatedItem = Item(
        id: currentItem.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _categoryController.text.trim(),
      );

      final success = provider.updateItem(widget.itemId, updatedItem);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update item'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}