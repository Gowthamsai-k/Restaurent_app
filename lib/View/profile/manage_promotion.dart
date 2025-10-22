import 'package:flutter/material.dart';
import 'add_edit_promotion.dart';

// This screen lists all promotions and lets you toggle them.
class ManagePromotionsScreen extends StatefulWidget {
  const ManagePromotionsScreen({super.key});

  @override
  State<ManagePromotionsScreen> createState() => _ManagePromotionsScreenState();
}

class _ManagePromotionsScreenState extends State<ManagePromotionsScreen> {
  // Dummy list of promotions
  List<Map<String, dynamic>> _promotions = [
    {
      'id': 'p1',
      'title': '20% OFF Weekends',
      'type': 'Percentage',
      'value': 20,
      'isActive': true,
    },
    {
      'id': 'p2',
      'title': '₹100 OFF Orders > ₹500',
      'type': 'Flat Amount',
      'value': 100,
      'isActive': true,
    },
    {
      'id': 'p3',
      'title': 'Free Coke with Pizza',
      'type': 'Free Item',
      'value': 0,
      'isActive': false,
    },
  ];

  void _togglePromotion(int index, bool isActive) {
    setState(() {
      _promotions[index]['isActive'] = isActive;
      // In a real app, you'd call your backend here to update the status.
    });
  }

  void _navigateToAddEditScreen([Map<String, dynamic>? promotion]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditPromotionScreen(promotion: promotion),
      ),
    );

    if (result != null) {
      // This is how we get data back from the form screen
      setState(() {
        if (promotion != null) {
          // Editing existing
          final index = _promotions.indexWhere((p) => p['id'] == result['id']);
          if (index != -1) {
            _promotions[index] = result;
          }
        } else {
          // Adding new
          _promotions.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Promotions')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _promotions.length,
        itemBuilder: (context, index) {
          final promo = _promotions[index];
          return Card(
            child: ListTile(
              title: Text(
                promo['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(promo['type']),
              trailing: Switch(
                value: promo['isActive'],
                onChanged: (value) => _togglePromotion(index, value),
              ),
              onTap: () => _navigateToAddEditScreen(promo),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
