import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEditMenuItemScreen extends StatefulWidget {
  // If 'initialItem' is null, this screen is in "Add" mode.
  // If it's provided, this screen is in "Edit" mode.
  final Map<String, dynamic>? initialItem;

  const AddEditMenuItemScreen({super.key, this.initialItem});

  @override
  State<AddEditMenuItemScreen> createState() => _AddEditMenuItemScreenState();
}

class _AddEditMenuItemScreenState extends State<AddEditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isAvailable = true;

  bool get _isEditMode => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialItem?['name'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialItem?['description'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialItem?['price']?.toString() ?? '',
    );
    _isAvailable = widget.initialItem?['isAvailable'] ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Create the new/updated item map
      final newItem = {
        'id':
            widget.initialItem?['id'] ??
            DateTime.now().millisecondsSinceEpoch
                .toString(), // Keep old ID or create new
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'isAvailable': _isAvailable,
      };

      // Pop the screen and return the new item map
      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Item' : 'Add New Item'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '₹',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available in stock:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _isAvailable,
                    onChanged: (newValue) {
                      setState(() {
                        _isAvailable = newValue;
                      });
                    },
                    activeColor: Colors.deepOrange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
