import 'package:flutter/material.dart';
import 'package:zomato_restaurent/View/auth/welcome_screen.dart';
import 'package:zomato_restaurent/View/profile/bank_payout.dart';
import 'package:zomato_restaurent/View/profile/manage_promotion.dart';
import 'package:zomato_restaurent/View/profile/restaurent_manager.dart';
import 'package:zomato_restaurent/View/restaurent/menu_managment.dart';

// --- ADD THIS IMPORT for logout functionality ---
import 'package:firebase_auth/firebase_auth.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagePromotionsScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            title: 'Bank & Payouts',
            icon: Icons.account_balance,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BankPayoutScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            title: 'Restaurant Settings',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantSettingsScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // --- MODIFIED LOGOUT BUTTON ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // Make the function async
              try {
                // 1. Sign the user out of Firebase
                await FirebaseAuth.instance.signOut();

                // 2. Clear the navigation stack and send to WelcomeScreen
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    // This predicate removes all routes from the stack
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                // Show an error if logout fails
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error logging out: $e')),
                  );
                }
              }
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
      leading: Icon(icon, color: Color.fromARGB(255, 75, 134, 78)),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
