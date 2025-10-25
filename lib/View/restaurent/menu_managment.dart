import 'package:flutter/material.dart';
import 'package:zomato_restaurent/View/restaurent/add_edit_menu.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  // Dummy data for the menu
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'm1',
      'name': 'Margherita Pizza',
      'description': 'Classic cheese and tomato pizza.',
      'price': 450.0,
      'isAvailable': true,
    },
    {
      'id': 'm2',
      'name': 'Veggie Burger',
      'description': 'A healthy veggie patty burger.',
      'price': 300.0,
      'isAvailable': true,
    },
    {
      'id': 'm3',
      'name': 'Coke',
      'description': '500ml chilled soft drink.',
      'price': 60.0,
      'isAvailable': false,
    },
  ];

  // Function to navigate to the Add/Edit screen for adding a new item
  void _navigateToAddItem() async {
    final newItem = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditMenuItemScreen(), // No item passed
      ),
    );

    if (newItem != null) {
      setState(() {
        _menuItems.add(newItem);
      });
    }
  }

  // Function to navigate to the Add/Edit screen for editing an existing item
  void _navigateToEditItem(Map<String, dynamic> itemToEdit) async {
    final updatedItem = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMenuItemScreen(
          initialItem: itemToEdit, // Pass the item to edit
        ),
      ),
    );

    if (updatedItem != null) {
      setState(() {
        final index = _menuItems.indexWhere(
          (item) => item['id'] == updatedItem['id'],
        );
        if (index != -1) {
          _menuItems[index] = updatedItem;
        }
      });
    }
  }

  // Function to toggle the availability switch
  void _toggleAvailability(String id, bool newAvailability) {
    setState(() {
      final index = _menuItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _menuItems[index]['isAvailable'] = newAvailability;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Menu')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              title: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${item['price']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: item['isAvailable'],
                    onChanged: (newValue) {
                      _toggleAvailability(item['id'], newValue);
                    },
                    activeColor: Color.fromARGB(255, 75, 134, 78),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      _navigateToEditItem(item);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        backgroundColor: Color.fromARGB(255, 75, 134, 78),
        child: const Icon(Icons.add),
      ),
    );
  }
}
