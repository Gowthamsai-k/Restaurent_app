import 'package:flutter/material.dart';
import 'order_details_screen.dart'; // We'll create this next

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
    {
      'id': '1003',
      'customer': 'Charlie',
      'items': ['Pasta x1', 'Salad x1'],
      'total': 550,
      'status': 'pending',
    },
    {
      'id': '1004',
      'customer': 'David',
      'items': ['Steak x1'],
      'total': 800,
      'status': 'completed',
    },
    {
      'id': '1005',
      'customer': 'Eve',
      'items': ['Fries x1', 'Coke x1'],
      'total': 150,
      'status': 'rejected',
    },
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
          // We pass a function that knows *which* order to update
          onUpdateStatus: (newStatus) {
            _updateOrderStatus(order['id'], newStatus);
          },
        ),
      ),
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
