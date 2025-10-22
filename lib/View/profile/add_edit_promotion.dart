import 'package:flutter/material.dart';

// This is the form for creating or editing a promotion.
class AddEditPromotionScreen extends StatefulWidget {
  final Map<String, dynamic>? promotion; // Null if creating new

  const AddEditPromotionScreen({super.key, this.promotion});

  @override
  State<AddEditPromotionScreen> createState() => _AddEditPromotionScreenState();
}

class _AddEditPromotionScreenState extends State<AddEditPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _valueController;
  String _selectedType = 'Percentage';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.promotion != null;

    // Pre-fill form if editing
    _titleController = TextEditingController(
      text: widget.promotion?['title'] ?? '',
    );
    _valueController = TextEditingController(
      text: widget.promotion?['value']?.toString() ?? '',
    );
    _selectedType = widget.promotion?['type'] ?? 'Percentage';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _savePromotion() {
    if (_formKey.currentState!.validate()) {
      // Create a new map of the promotion data
      final newPromoData = {
        'id':
            widget.promotion?['id'] ??
            'p${DateTime.now().millisecondsSinceEpoch}', // Dummy ID
        'title': _titleController.text,
        'type': _selectedType,
        'value': int.tryParse(_valueController.text) ?? 0,
        'isActive': widget.promotion?['isActive'] ?? true, // Default to active
      };

      // In a real app, send to backend.
      // For dummy data, we just pop and send the map back.
      Navigator.of(context).pop(newPromoData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Promotion' : 'Add Promotion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Promotion Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Promotion Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Percentage', 'Flat Amount', 'Free Item']
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Only show value field if not a 'Free Item'
              if (_selectedType != 'Free Item')
                TextFormField(
                  controller: _valueController,
                  decoration: InputDecoration(
                    labelText: _selectedType == 'Percentage'
                        ? 'Percentage %'
                        : 'Flat Amount ₹',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a value' : null,
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePromotion,
                  child: Text('Save Promotion'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
