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
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9800).withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: _editProfile,
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _email,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (!(_auth.currentUser?.emailVerified ?? false))
                Container(
                  margin: const EdgeInsets.all(16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Color(0xFFE65100)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Verify your email for enhanced security',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPointsCard(
                        'Hangry Points',
                        '0',
                        Icons.star,
                        'Points',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPointsCard(
                        'Refund Wallet',
                        '0',
                        Icons.wallet,
                        'IDR',
                      ),
                    ),
                  ],
                ),
              ),
              _buildInfoSection(
                'Privacy Policy',
                Icons.privacy_tip,
                _navigateToPrivacy,
              ),
              _buildInfoSection(
                'Agreement',
                Icons.gavel,
                _navigateToAgreement,
              ),
              _buildInfoSection(
                'Logout',
                Icons.logout,
                _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard(
      String title, String value, IconData icon, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF9800), size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFE65100),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value $unit',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF9800)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE65100),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF9800)),
        onTap: onTap,
      ),
    );
  }
}
