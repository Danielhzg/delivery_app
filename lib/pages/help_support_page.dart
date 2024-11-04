import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9), // Light background matching HomePage
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ReviewItem(
                    reviewer: 'Alice',
                    review: 'Great service! Delivery was on time and the food was fresh.',
                    rating: 3,
                  ),
                  ReviewItem(
                    reviewer: 'Bob',
                    review: 'Had an issue with my order, but the support team resolved it quickly.',
                    rating: 4,
                  ),
                  ReviewItem(
                    reviewer: 'Charlie',
                    review: 'Very user-friendly app. I love the easy navigation!',
                    rating: 5,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Give Us Your Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Feedback Submitted'),
                        content: Text('Thank you for your feedback!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _feedbackController.clear();
                            },
                            child: Text('OK', style: TextStyle(color: Colors.orange)),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Submit Feedback'),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.orange),
                title: Text('Phone Support'),
                subtitle: Text('+123 456 789'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.orange),
                title: Text('Email Support'),
                subtitle: Text('support@deliveryapp.com'),
              ),
              ListTile(
                leading: Icon(Icons.chat, color: Colors.orange),
                title: Text('Live Chat'),
                subtitle: Text('Available 24/7 in the app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String reviewer;
  final String review;
  final int rating;

  const ReviewItem({required this.reviewer, required this.review, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reviewer,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            review,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
