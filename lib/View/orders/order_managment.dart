import 'package:flutter/material.dart';
import 'order_details_screen.dart'; // Your existing details screen

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  // This list is now "state" and can be changed
  List<Map<String, dynamic>> _orders = [
    {
      'id': '1001',
      'customer': 'Alice',
      'items': ['Pizza x1', 'Coke x2'],
      'total': 450,
      'status': 'pending',
    },
    {
      'id': '1002',
      'customer': 'Bob',
      'items': ['Burger x2'],
      'total': 300,
      'status': 'accepted',
    },
    // ... your other orders
  ];

  // This function updates the order's status and rebuilds the UI
  void _updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      final index = _orders.indexWhere((order) => order['id'] == orderId);
      if (index != -1) {
        _orders[index]['status'] = newStatus;
      }
    });
  }

  // This navigates to the details page and passes the update function
  void _navigateToDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          order: order,
          onUpdateStatus: (newStatus) {
            _updateOrderStatus(order['id'], newStatus);
          },
        ),
      ),
    );
  }

  // --- NEW FUNCTION TO SIMULATE A NEW ORDER ---
  void _simulateNewOrder() {
    // 1. Create a new dummy order
    final String newId = 'ord${DateTime.now().millisecondsSinceEpoch}';
    final Map<String, dynamic> newOrder = {
      'id': newId,
      'customer': 'New Customer',
      'items': ['Special Burger x1', 'Fries x1'],
      'total': 420,
      'status': 'pending',
    };

    // 2. Add it to the list
    setState(() {
      _orders.insert(0, newOrder); // Add to the top of the list
    });

    // 3. Show the alert dialog
    _showNewOrderDialog(newOrder);
  }

  // --- NEW FUNCTION TO SHOW THE ALERT ---
  void _showNewOrderDialog(Map<String, dynamic> newOrder) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'New Order Received!',
            style: TextStyle(color: Colors.deepOrange),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From: ${newOrder['customer']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(newOrder['items'].join(', ')),
              const SizedBox(height: 8),
              Text(
                'Total: ₹${newOrder['total']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('VIEW ORDER'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToDetails(newOrder); // Open the details screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // These lists are now filtered live from your main _orders list
    final pendingOrders = _orders
        .where((o) => o['status'] == 'pending')
        .toList();
    final activeOrders = _orders
        .where((o) => o['status'] == 'accepted' || o['status'] == 'preparing')
        .toList();
    final historyOrders = _orders
        .where((o) => o['status'] == 'completed' || o['status'] == 'rejected')
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Management'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'PENDING'),
              Tab(text: 'ACTIVE'),
              Tab(text: 'HISTORY'),
            ],
          ),
          // --- ADDED THIS ACTION BUTTON ---
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active),
              onPressed: _simulateNewOrder,
              tooltip: 'Simulate New Order',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Pending Tab
            _OrderListView(orders: pendingOrders, onTap: _navigateToDetails),
            // Active Tab
            _OrderListView(orders: activeOrders, onTap: _navigateToDetails),
            // History Tab
            _OrderListView(orders: historyOrders, onTap: _navigateToDetails),
          ],
        ),
      ),
    );
  }
}

// Helper widget to display a list of orders (your original code)
class _OrderListView extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final Function(Map<String, dynamic> order) onTap;

  const _OrderListView({required this.orders, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders in this category.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => onTap(order), // Pass the tap event up
        );
      },
    );
  }
}

// Your original Card widget, now in its own class
class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'preparing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        title: Text(order['customer']),
        subtitle: Text(order['items'].join(', ')),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${order['total']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(order['status']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order['status'].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
