import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu_item.dart';
import '../constants/categories.dart';
import '../utils/imagekit_config.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPopular = false;
  String? _editingId;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      // Request permissions
      List<Permission> permissions = [Permission.storage, Permission.photos];
      Map<Permission, PermissionStatus> statuses = await permissions.request();
      bool hasAccess = statuses.values.any((status) => status.isGranted);

      if (!hasAccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to access gallery without permission')),
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) return;

      // Upload image to ImageKit
      final imageUrl = await ImageKitConfig.uploadImage(image.path, 'menu_item_${DateTime.now().millisecondsSinceEpoch}.jpg');

      setState(() {
        _imageFile = File(image.path);
        _imageUrlController.text = imageUrl;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAddItemForm(),
                  _buildMenuList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.dashboard_customize, color: Colors.white, size: 32),
          SizedBox(width: 16),
          Text(
            'Menu Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: _buildInputDecoration('Menu Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _categoryController.text.isEmpty ? null : _categoryController.text,
              decoration: _buildInputDecoration('Category'),
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
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50, color: Color(0xFFFF9800)),
                          SizedBox(height: 8),
                          Text('Tap to add image', style: TextStyle(color: Color(0xFFFF9800))),
                        ],
                      ),
              ),
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: _buildInputDecoration('Image URL'),
              validator: (value) => value?.isEmpty ?? true ? 'Image URL is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: _buildInputDecoration('Price'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Price is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: _buildInputDecoration('Description'),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Popular Item'),
              value: _isPopular,
              onChanged: (bool value) {
                setState(() => _isPopular = value);
              },
              activeColor: const Color(0xFFFF9800),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(_editingId == null ? 'Add Item' : 'Update Item'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF9800)),
      ),
      labelStyle: const TextStyle(color: Color(0xFFFF9800)),
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final item = MenuItem.fromMap(doc.id, doc.data() as Map<String, dynamic>);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    ImageKitConfig.getImageUrl(
                      item.imageUrl,
                      transformations: {
                        'w': '50',
                        'h': '50',
                        'q': '75',
                        'f': 'auto',
                        'r': '50'  // for circular image
                      }
                    ),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                title: Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item.category} - \$${item.price}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFFFF9800)),
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

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final item = MenuItem(
        id: _editingId ?? '',
        name: _nameController.text,
        category: _categoryController.text,
        imageUrl: _imageUrlController.text,
        price: double.parse(_priceController.text),
        isPopular: _isPopular,
        description: _descriptionController.text,
      );

      try {
        if (_editingId == null) {
          await FirebaseFirestore.instance.collection('menu').add(item.toMap());
        } else {
          await FirebaseFirestore.instance.collection('menu').doc(_editingId).update(item.toMap());
        }
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_editingId == null ? 'Item added successfully' : 'Item updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving item'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editItem(MenuItem item) {
    setState(() {
      _editingId = item.id;
      _nameController.text = item.name;
      _categoryController.text = item.category;
      _imageUrlController.text = item.imageUrl;
      _priceController.text = item.price.toString();
      _descriptionController.text = item.description;
      _isPopular = item.isPopular;
    });
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
      _imageUrlController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _isPopular = false;
      _imageFile = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
