import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Temporary placeholders – these can later be fetched from backend
    const restaurantName = "Spice Haven";
    const adminName = "John Doe";
    const restaurantAddress = "12 MG Road, Hyderabad";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 87, 131, 74),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            // 🔹 Profile Image
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/restaurant_logo.jpg'),
            ),
            const SizedBox(height: 20),

            // 🔹 Restaurant Info
            Text(
              restaurantName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Admin: $adminName",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "📍 $restaurantAddress",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.2),

            // 🔹 Account Info
            ListTile(
              leading: const Icon(
                Icons.phone_android,
                color: Color.fromARGB(255, 87, 131, 74),
              ),
              title: const Text("Phone Number"),
              subtitle: Text(user?.phoneNumber ?? "Not available"),
            ),
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Color.fromARGB(255, 87, 131, 74),
              ),
              title: const Text("Email"),
              subtitle: Text(user?.email ?? "No email linked"),
            ),

            const SizedBox(height: 40),

            // 🔹 Logout Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 87, 131, 74),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
