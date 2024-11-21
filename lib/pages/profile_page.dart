import 'package:delivery_app/pages/edit_profile_page.dart';
import 'package:delivery_app/pages/login_page.dart';
import 'package:delivery_app/pages/privacy_policy_page.dart';
import 'package:delivery_app/pages/agreement_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _name = 'Daniel';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final User? user = _auth.currentUser;
    setState(() {
      _email = user?.email ?? 'No Email Found';
      _name = user?.displayName ?? 'Daniel'; // Use displayName if available
    });
  }

  // Edit profile function
  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
    if (result != null) {
      setState(() {
        _name = result['name'];
        _email = result['email'];
      });
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToPrivacy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
  }

  void _navigateToAgreement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgreementPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 5,
        actions: [
          TextButton(
            onPressed: _editProfile,
            child: const Text(
              'Edit profile',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              color: Colors.yellow[100],
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lakukan verifikasi email agar akun lebih aman',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            const SizedBox(height: 10),
            Text(
              _name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              _email,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard('Hangry Point', '0 Poin', Icons.star),
                _buildCard('Refund Wallet', 'Rp0', Icons.wallet),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.verified, color: Colors.red),
              title: const Text('Verifikasi email kamu, yuk!'),
              subtitle: const Text('Tekan untuk mengirimkan email'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {}, // Add functionality here
            ),
            const Divider(),
            _buildInfoSection(
                'Privacy Policy', Icons.privacy_tip, _navigateToPrivacy),
            _buildInfoSection('Agreement', Icons.gavel, _navigateToAgreement),
            _buildInfoSection('Logout', Icons.logout, _logout),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 2,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 30),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
