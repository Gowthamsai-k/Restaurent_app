import 'package:flutter/material.dart';
import 'package:zomato_restaurent/View/auth/welcome_screen.dart';
import 'package:zomato_restaurent/View/restaurent/menu_managment.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        // No back button, since it's a main tab
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // A simple header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Gowtham\'s Restaurant', // Replace with dynamic data
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),

          // Management Options
          _buildListTile(
            context,
            title: 'Manage Menu',
            icon: Icons.restaurant_menu,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuManagementScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            title: 'Manage Promotions',
            icon: Icons.local_offer,
            onTap: () {
              // TODO: Navigate to PromotionsScreen
            },
          ),
          _buildListTile(
            context,
            title: 'Bank & Payouts',
            icon: Icons.account_balance,
            onTap: () {
              // TODO: Navigate to BankInfoScreen
            },
          ),
          _buildListTile(
            context,
            title: 'Restaurant Settings',
            icon: Icons.settings,
            onTap: () {
              // TODO: Navigate to RestaurantSettingsScreen (for hours, etc.)
            },
          ),

          const Divider(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for a consistent list tile
  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
