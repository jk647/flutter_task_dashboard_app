import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../models/item_model.dart';
import '../../extensions/size_ext.dart';
import 'service/detail_service.dart';

class DetailScreen extends StatefulWidget {
  final int itemId;

  const DetailScreen({super.key, required this.itemId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final DetailService _service = DetailService();
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
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.05;

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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
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
                      24.h,

                      // Title Field
                      _buildFieldLabel('Title'),
                      8.h,
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
                      24.h,

                      // Description Field
                      _buildFieldLabel('Description'),
                      8.h,
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
                      24.h,

                      // Price Field
                      _buildFieldLabel('Price'),
                      8.h,
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
                      24.h,

                      // Category Field
                      _buildFieldLabel('Category'),
                      8.h,
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
                      32.h,

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
    // First validate form UI rules
    if (!_formKey.currentState!.validate()) return;

    try {
      // Use service to validate and create updated Item 
      final updatedItem = _service.validateAndBuildItem(
        currentItem: currentItem,
        title: _titleController.text,
        description: _descriptionController.text,
        priceText: _priceController.text,
        category: _categoryController.text,
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
    } on FormatException catch (fe) {
      // Validation error from service
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fe.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: ${e.toString()}')),
      );
    }
  }
}