import 'package:flutter/material.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Agreement'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Agreement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This agreement governs the use of our app. Please review it carefully to understand your rights and obligations.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Acceptance of Terms'),
              _buildSectionContent(
                  'By using this app, you agree to the terms and conditions outlined here.'),
              const SizedBox(height: 15),
              _buildSectionTitle('User Responsibilities'),
              _buildSectionContent(
                  'Users must adhere to the guidelines and not misuse the services provided. Any form of abuse may lead to account suspension.'),
              const SizedBox(height: 15),
              _buildSectionTitle('Limitation of Liability'),
              _buildSectionContent(
                  'We are not liable for damages resulting from the use or inability to use our services.'),
              const SizedBox(height: 15),
              _buildSectionTitle('Governing Law'),
              _buildSectionContent(
                  'This agreement is governed by the laws applicable in your jurisdiction.'),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Back to Profile'),
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
      style: const TextStyle(
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
