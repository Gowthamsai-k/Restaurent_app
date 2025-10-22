import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  // This function is passed from the parent screen
  final Function(String newStatus) onUpdateStatus;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order from ${order['customer']}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Customer'),
            Text(order['customer'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            _buildSectionTitle('Order Items'),
            ...List.generate(order['items'].length, (index) {
              return ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text(order['items'][index]),
              );
            }),

            const Divider(height: 30),

            _buildSectionTitle('Total Amount'),
            Text(
              '₹${order['total']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // This adds the action buttons at the very bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: _buildActionButtons(context),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }

  // This logic decides which buttons to show
  Widget _buildActionButtons(BuildContext context) {
    String status = order['status'];

    switch (status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Call the update function, then close the screen
                  onUpdateStatus('rejected');
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('REJECT'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Call the update function, then close the screen
                  onUpdateStatus('accepted');
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('ACCEPT'),
              ),
            ),
          ],
        );
      case 'accepted':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              onUpdateStatus('preparing');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('MARK AS PREPARING'),
          ),
        );
      case 'preparing':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // This will move it to the "History" tab
              onUpdateStatus('completed');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('MARK AS COMPLETED'),
          ),
        );
      default:
        // For 'completed' or 'rejected'
        return Text(
          'This order is ${status.toUpperCase()}.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        );
    }
  }
}
