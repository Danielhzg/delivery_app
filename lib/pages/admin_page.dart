import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';
import '../constants/categories.dart';
import '../utils/image_upload_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPopular = false;
  String? _editingId;
  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  late TabController _tabController;
  final TextEditingController _replyController = TextEditingController();
  String? _selectedUserId;
  String? _selectedChatUserId; // Add this line
  String? _selectedChatUserName; // Add this line
  String? _selectedChatUserProfilePic; // Add this line

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Update length to 3
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );

        if (image != null) {
          setState(() {
            _imageFile = File(image.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission to access gallery denied')),
        );
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission permanently denied. Please enable it from settings.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
      print('Error picking image: $e');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add), text: 'Add/Edit Item'),
            Tab(icon: Icon(Icons.list), text: 'Menu List'),
            Tab(icon: Icon(Icons.chat), text: 'Customer Chats'), // Add new tab
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAddEditForm(),
          _buildMenuList(),
          _buildChatList(), // Add new tab view
        ],
      ),
    );
  }

  Widget _buildAddEditForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildTextField(_nameController, 'Menu Name', Icons.fastfood),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildTextField(_priceController, 'Price', Icons.attach_money,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(
                  _descriptionController, 'Description', Icons.description,
                  maxLines: 3),
              const SizedBox(height: 16),
              _buildPopularSwitch(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: Icon(_editingId == null ? Icons.add : Icons.edit),
                label: Text(_editingId == null ? 'Add Item' : 'Update Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepOrange),
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_imageFile!,
                        fit: BoxFit.cover, width: double.infinity),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 50, color: Colors.deepOrange),
                      SizedBox(height: 8),
                      Text('Tap to add image',
                          style: TextStyle(color: Colors.deepOrange)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.deepOrange),
        ),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) =>
          value?.isEmpty ?? true ? '$label is required' : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _categoryController.text.isEmpty ? null : _categoryController.text,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category, color: Colors.deepOrange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8)),
      ),
      items: menuCategories
          .map((category) => DropdownMenuItem<String>(
                value: category['name'] as String,
                child: Text(category['name'] as String),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _categoryController.text = value ?? '';
        });
      },
      validator: (value) => value == null ? 'Category is required' : null,
    );
  }

  Widget _buildPopularSwitch() {
    return SwitchListTile(
      title: const Text('Popular Item'),
      value: _isPopular,
      onChanged: (bool value) {
        setState(() => _isPopular = value);
      },
      activeColor: Colors.deepOrange,
    );
  }

  Widget _buildMenuList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('menu').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading menu'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final menuItems = snapshot.data!.docs
            .map((doc) =>
                MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(item.imageUrl),
                  onBackgroundImageError: (_, __) =>
                      const AssetImage('assets/burger.jpeg'),
                ),
                title: Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${item.category} - \$${item.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () => _editItem(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(item.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').doc('admin').collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final chatDocs = snapshot.data!.docs;

        if (chatDocs.isEmpty) {
          return const Center(child: Text('No users have sent messages.'));
        }

        final userIds = chatDocs.map((doc) => doc['userId']).toSet().toList();

        return ListView.builder(
          itemCount: userIds.length,
          itemBuilder: (context, index) {
            final userId = userIds[index];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final user = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                final userName = user['firstName'] ?? 'Anonymous';
                final userProfilePic = user['profilePic'] ?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: userProfilePic.isNotEmpty
                              ? NetworkImage(userProfilePic)
                              : const AssetImage('assets/default_profile.png') as ImageProvider,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc('admin')
                              .collection('messages')
                              .where('userId', isEqualTo: userId)
                              .where('isRead', isEqualTo: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Text(
                                  '!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    title: Text(userName),
                    tileColor: Colors.orange[100], // Set the background color of the bubble
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedChatUserId = userId;
                        _selectedChatUserName = userName;
                        _selectedChatUserProfilePic = userProfilePic;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            userId: userId,
                            userName: userName,
                            userProfilePic: userProfilePic,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isUploading = true);

        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await ImageUploadService.uploadImage(_imageFile!);
        }

        final item = {
          'name': _nameController.text,
          'category': _categoryController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'isPopular': _isPopular,
          'imageUrl': imageUrl ?? (_editingId != null ? _uploadedImageUrl : ''),
        };

        if (_editingId == null) {
          await FirebaseFirestore.instance.collection('menu').add(item);
        } else {
          await FirebaseFirestore.instance
              .collection('menu')
              .doc(_editingId)
              .update(item);
        }

        _clearForm();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editingId == null
                ? 'Item added successfully'
                : 'Item updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving item: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  void _editItem(MenuItem item) {
    setState(() {
      _editingId = item.id;
      _nameController.text = item.name;
      _categoryController.text = item.category;
      _priceController.text = item.price.toString();
      _descriptionController.text = item.description;
      _isPopular = item.isPopular;
      _uploadedImageUrl = item.imageUrl;
    });
    _tabController.animateTo(0); // Switch to the Add/Edit tab
  }

  void _deleteItem(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await FirebaseFirestore.instance.collection('menu').doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error deleting item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _categoryController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _isPopular = false;
      _imageFile = null;
      _uploadedImageUrl = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class ChatDetailPage extends StatelessWidget {
  final String userId;
  final String userName;
  final String userProfilePic;

  const ChatDetailPage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc('admin')
                  .collection('messages')
                  .where('userId', isEqualTo: userId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>? ?? {};
                    final isAdmin = messageData['userId'] == 'admin';
                    return _buildMessageBubble(messageData['text'] ?? '', isAdmin, messageData['userId'] ?? '', messageData['userName'] ?? 'Anonymous');
                  },
                );
              },
            ),
          ),
          _buildReplyInput(userId),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isAdmin, String userId, String userName) {
    return Align(
      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isAdmin)
            CircleAvatar(
              backgroundImage: userProfilePic.isNotEmpty
                  ? NetworkImage(userProfilePic)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAdmin ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: isAdmin ? const Radius.circular(10) : const Radius.circular(0),
                bottomRight: isAdmin ? const Radius.circular(0) : const Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isAdmin) Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput(String userId) {
    final TextEditingController _replyController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Type a reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: () async {
              if (_replyController.text.trim().isEmpty) return;

              final message = {
                'userId': 'admin',
                'userName': 'Admin',
                'text': _replyController.text.trim(),
                'timestamp': FieldValue.serverTimestamp(),
                'isRead': false,
              };

              await FirebaseFirestore.instance.collection('chats').doc(userId).collection('messages').add(message);
              _replyController.clear();
            },
          ),
        ],
      ),
    );
  }
}
