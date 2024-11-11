import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Our privacy policy outlines how we collect, use, and protect your information. Please read carefully.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Information Collection'),
              _buildSectionContent(
                  'We collect personal information to improve our services. This includes your name, email, and usage data.'),
              SizedBox(height: 15),
              _buildSectionTitle('Information Usage'),
              _buildSectionContent(
                  'We use the collected data to provide better services, customize user experience, and enhance app functionality.'),
              SizedBox(height: 15),
              _buildSectionTitle('Data Protection'),
              _buildSectionContent(
                  'We implement various security measures to protect your information. However, no method of transmission over the internet is completely secure.'),
              SizedBox(height: 15),
              _buildSectionTitle('Your Rights'),
              _buildSectionContent(
                  'You have the right to access, modify, or delete your personal data at any time. Contact us for assistance.'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Back to Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    );
  }
}
