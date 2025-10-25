import 'package:flutter/material.dart';

// This is a simple, read-only screen to show bank details.
class BankPayoutScreen extends StatelessWidget {
  const BankPayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank & Payouts')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.account_balance,
              size: 64,
              color: Color.fromARGB(255, 75, 134, 78),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payout Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'This is the account where your earnings will be deposited.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    title: 'Account Holder Name',
                    // Dummy Data
                    subtitle: 'Gowtham M.',
                  ),
                  _buildInfoTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Account Number',
                    // Dummy Data
                    subtitle: '**** **** **** 1234',
                  ),
                  _buildInfoTile(
                    icon: Icons.article,
                    title: 'IFSC Code',
                    // Dummy Data
                    subtitle: 'ABCD0001234',
                  ),
                  _buildInfoTile(
                    icon: Icons.business,
                    title: 'Bank Name',
                    // Dummy Data
                    subtitle: 'ICICI Bank',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'For security reasons, please contact support to update your bank details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for this screen
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 75, 134, 78)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
    );
  }
}
