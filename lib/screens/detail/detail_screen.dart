import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../models/item_model.dart';
import '../../extensions/size_ext.dart';
import 'service/detail_service.dart';
import 'widgets/detail_header.dart';
import 'widgets/detail_form.dart';
import 'widgets/save_button.dart';

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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  final item = context.read<DataProvider>().getItemById(widget.itemId);
                  if (item != null) _initializeControllers(item);
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, provider, child) {
          final item = provider.getItemById(widget.itemId);
          if (item == null) return const Center(child: Text('Item not found'));

          if (_titleController.text.isEmpty) {
            _initializeControllers(item);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DetailHeader(category: item.category),
                    24.h,
                    DetailForm(
                      isEditing: _isEditing,
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      priceController: _priceController,
                      categoryController: _categoryController,
                    ),
                    24.h,
                    if (_isEditing)
                      SaveButton(
                        onPressed: () => _saveChanges(provider, item),
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

  void _saveChanges(DataProvider provider, Item currentItem) {
    if (!_formKey.currentState!.validate()) return;

    try {
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
          const SnackBar(content: Text('Item updated successfully!'), backgroundColor: Colors.green),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}